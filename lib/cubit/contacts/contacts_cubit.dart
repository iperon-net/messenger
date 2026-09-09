import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../../api.dart';
import '../../constants.dart';
import '../../crypto.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../protobuf.dart';
import '../../repositories/repositories.dart';
import '../../utils.dart';
import 'contacts_state.dart';

/// Нормализованная запись телефонной книги: [raw] — вход OPRF (та же строка
/// цифр без `+`, что сервер хэшировал при регистрации, см. Utils.phoneNormalization),
/// [phoneE164]/[phone] — для кэша/показа.
class _Entry {
  final String raw;
  final String phoneE164;
  final String phone;
  final String displayName;

  const _Entry({required this.raw, required this.phoneE164, required this.phone, required this.displayName});
}

/// Экран «Контакты»: находит, кто из телефонной книги зарегистрирован в Iperon,
/// не раскрывая серверу сырые номера. Раунд 1 — слепая OPRF-оценка, раунд 2 —
/// проверка членства по отпечаткам. См. docs/plans/functional-stirring-giraffe.md.
class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit() : super(const ContactsState());

  final logger = getIt.get<Logger>();
  final api = getIt.get<API>();
  final utils = getIt.get<Utils>();
  final crypto = getIt.get<Crypto>();
  final repositories = getIt.get<Repositories>();

  // Батч discovery. Совпадает по духу с серверным contactsDiscoveryBatchLimit
  // (1024) — держим ниже лимита, чтобы большая книга уходила пачками.
  static const int _batchSize = 512;

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading, permissionDenied: false, error: ""));

    final permission = await FlutterContacts.permissions.request(PermissionType.read);
    if (isClosed) return;
    // granted / limited (iOS 18+ частичный доступ) — этого достаточно для поиска.
    if (permission != PermissionStatus.granted && permission != PermissionStatus.limited) {
      emit(state.copyWith(status: Status.success, permissionDenied: true));
      return;
    }

    final deviceContacts = await FlutterContacts.getAll(properties: {ContactProperty.name, ContactProperty.phone});
    if (isClosed) return;

    // Уникальные записи по e164; первое встреченное имя выигрывает.
    final entries = <String, _Entry>{};
    for (final contact in deviceContacts) {
      for (final phone in contact.phones) {
        final normalization = utils.phoneNormalization(phoneNumber: phone.number);
        if (normalization.e164.isEmpty || normalization.raw.isEmpty) continue;

        entries.putIfAbsent(
          normalization.e164,
          () => _Entry(
            raw: normalization.raw,
            phoneE164: normalization.e164,
            phone: normalization.international,
            displayName: (contact.displayName?.isNotEmpty ?? false) ? contact.displayName! : normalization.international,
          ),
        );
      }
    }

    if (entries.isEmpty) {
      emit(state.copyWith(status: Status.success, registered: const [], invitable: const []));
      return;
    }

    // Мгновенный показ зарегистрированных из кэша прошлого поиска.
    final cached = await repositories.contacts.getRegistered();
    if (isClosed) return;
    final cachedUsers = {for (final match in cached) match.phoneE164: Uint8List.fromList(match.userID)};
    _emitLists(entries, cachedUsers);

    // OPRF-поиск. Ошибка сети не критична — остаёмся на данных из кэша.
    try {
      final matched = await _discover(entries.values.toList(growable: false));
      if (isClosed) return;

      _emitLists(entries, {for (final entry in matched.entries) entry.key: entry.value});
      await repositories.contacts.replaceAll([
        for (final entry in matched.entries) ContactMatch(phoneE164: entry.key, userID: entry.value),
      ]);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      if (!isClosed) emit(state.copyWith(status: Status.success));
    }
  }

  /// Повторный запуск поиска (pull-to-refresh / после выдачи разрешения).
  Future<void> refresh() => initialization();

  void search(String query) => emit(state.copyWith(query: query));

  /// Выполняет двухраундовый OPRF-поиск по [allEntries] пачками и возвращает
  /// карту `e164 -> userID` для зарегистрированных.
  Future<Map<String, Uint8List>> _discover(List<_Entry> allEntries) async {
    final result = <String, Uint8List>{};

    for (var offset = 0; offset < allEntries.length; offset += _batchSize) {
      final chunk = allEntries.sublist(offset, (offset + _batchSize).clamp(0, allEntries.length));

      // Раунд 1: ослепляем и просим сервер оценить.
      final blinds = <Uint8List>[];
      final blindedElements = <List<int>>[];
      for (final entry in chunk) {
        final (blind, blindedElement) = await crypto.oprf.blind(utf8.encode(entry.raw));
        blinds.add(blind);
        blindedElements.add(blindedElement);
      }

      final (evaluateStatus, evaluatePayload) = await api.unaryEncodedWithResponse(
        MessageType.CONTACTS_DISCOVERY_EVALUATE,
        ContactsDiscoveryEvaluate_Request(blindedElements: blindedElements).writeToBuffer(),
      );
      if (evaluateStatus.status != APIStatus.success || evaluatePayload == null) {
        throw Exception('contacts: evaluate failed (${evaluateStatus.error})');
      }
      final evaluateResponse = ContactsDiscoveryEvaluate_Response.fromBuffer(evaluatePayload);

      // Финализируем каждый ответ → OPRF-отпечаток (== user.oprf на сервере).
      final oprfOutputs = <List<int>>[];
      final entryByOprf = <String, _Entry>{};
      for (var i = 0; i < chunk.length; i++) {
        final output = await crypto.oprf.finalize(
          input: utf8.encode(chunk[i].raw),
          blind: blinds[i],
          evaluation: Uint8List.fromList(evaluateResponse.evaluatedElements[i]),
        );
        oprfOutputs.add(output);
        entryByOprf[utils.bytesToHex(output)] = chunk[i];
      }

      // Раунд 2: проверка членства.
      final (matchStatus, matchPayload) = await api.unaryEncodedWithResponse(
        MessageType.CONTACTS_DISCOVERY_MATCH,
        ContactsDiscoveryMatch_Request(oprfOutputs: oprfOutputs).writeToBuffer(),
      );
      if (matchStatus.status != APIStatus.success || matchPayload == null) {
        throw Exception('contacts: match failed (${matchStatus.error})');
      }
      final matchResponse = ContactsDiscoveryMatch_Response.fromBuffer(matchPayload);

      for (final match in matchResponse.matches) {
        final entry = entryByOprf[utils.bytesToHex(Uint8List.fromList(match.oprf))];
        if (entry != null) {
          result[entry.phoneE164] = Uint8List.fromList(match.userID);
        }
      }
    }

    return result;
  }

  void _emitLists(Map<String, _Entry> entries, Map<String, Uint8List> userByE164) {
    if (isClosed) return;

    final registered = <ContactItem>[];
    final invitable = <ContactItem>[];

    for (final entry in entries.values) {
      final userID = userByE164[entry.phoneE164];
      final item = ContactItem(displayName: entry.displayName, phone: entry.phone, phoneE164: entry.phoneE164, userID: userID);
      (userID != null ? registered : invitable).add(item);
    }

    registered.sort((a, b) => a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));
    invitable.sort((a, b) => a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));

    emit(state.copyWith(status: Status.success, permissionDenied: false, registered: registered, invitable: invitable));
  }
}
