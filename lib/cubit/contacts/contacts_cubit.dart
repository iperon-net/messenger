import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

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

  // Один discover идёт за раз (guard от параллельных запусков), а _discoverStarted
  // помнит, был ли он вообще запущен в этой сессии — чтобы первый показ вкладки не
  // дублировал уже стартовавшую фоновую дозагрузку.
  bool _discovering = false;
  bool _discoverStarted = false;

  /// Старт на уровне shell: сперва мгновенный показ снимка из БД, затем — тихая
  /// фоновая дозагрузка, если доступ к контактам уже выдан (без диалога).
  Future<void> bootstrap() async {
    await preload();
    await discoverIfAlreadyGranted();
  }

  /// Фаза A — мгновенный показ полного снимка из БД, без разрешений и без сети.
  /// Вызывается на уровне shell при старте, ещё до открытия вкладки.
  Future<void> preload() async {
    final cached = await repositories.contacts.getAll();
    if (isClosed || cached.isEmpty) return;

    // Пустое имя = legacy-запись из миграции 2→3 (до неё имя/номер не хранились) —
    // её нечем показать, пропускаем; первый же discover перезапишет снимок целиком.
    final visible = cached.where((entry) => entry.displayName.isNotEmpty).toList(growable: false);
    if (visible.isEmpty) return;

    _emitFromCache(visible);
  }

  /// Фаза B без диалога: если доступ к контактам уже выдан, тихо запускаем полный
  /// discover в фоне (номера и так доступны — системного диалога не будет).
  /// Иначе ничего не делаем: запрос разрешения откладываем до открытия вкладки.
  Future<void> discoverIfAlreadyGranted() async {
    final status = await ph.Permission.contacts.status;
    if (isClosed) return;
    if (status.isGranted || status.isLimited) await discover();
  }

  /// Фаза B — запрос разрешения, чтение книги и OPRF-поиск. Вызывается при первом
  /// показе вкладки (осознанный запрос разрешения) и из refresh().
  Future<void> discover() async {
    if (_discovering) return;
    _discovering = true;
    _discoverStarted = true;
    try {
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

      // Книга пуста (или частичный доступ ничего не отдал) — не трогаем снимок,
      // чтобы не стереть прошлый кэш; просто показываем пусто.
      if (entries.isEmpty) {
        emit(state.copyWith(status: Status.success, registered: const [], invitable: const []));
        return;
      }

      // Сразу перерисовываем оба списка по свежей книге, используя лучшие known-userID
      // (из уже показанного снимка), и записываем обновлённый снимок в БД.
      final known = {
        for (final item in state.registered)
          if (item.userID != null) item.phoneE164: item.userID!,
      };
      _emitLists(entries, known);
      await _writeSnapshot(entries, known);
      if (isClosed) return;

      // OPRF-поиск. Ошибка сети не критична — остаёмся на данных из снимка.
      try {
        final matched = await _discoverOprf(entries.values.toList(growable: false));
        if (isClosed) return;

        _emitLists(entries, matched);
        await _writeSnapshot(entries, matched);
      } catch (error, stackTrace) {
        logger.handle(error, stackTrace);
        if (!isClosed) emit(state.copyWith(status: Status.success));
      }
    } finally {
      _discovering = false;
    }
  }

  /// Запускает discover только если он ещё ни разу не стартовал в этой сессии —
  /// вызывается при первом построении экрана, чтобы не дублировать фоновую дозагрузку.
  Future<void> discoverOnFirstView() => _discoverStarted ? Future.value() : discover();

  /// Повторный запуск поиска (pull-to-refresh / после выдачи разрешения).
  Future<void> refresh() => discover();

  void search(String query) => emit(state.copyWith(query: query));

  /// Выполняет двухраундовый OPRF-поиск по [allEntries] пачками и возвращает
  /// карту `e164 -> userID` для зарегистрированных.
  Future<Map<String, Uint8List>> _discoverOprf(List<_Entry> allEntries) async {
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

    _emitSorted(registered, invitable);
  }

  /// Показ полного снимка из БД (фаза A) — без нормализации, прямо из кэша.
  void _emitFromCache(List<ContactCacheEntry> cached) {
    final registered = <ContactItem>[];
    final invitable = <ContactItem>[];

    for (final entry in cached) {
      final userID = entry.userID;
      final item = ContactItem(
        displayName: entry.displayName,
        phone: entry.phone,
        phoneE164: entry.phoneE164,
        userID: userID == null ? null : Uint8List.fromList(userID),
      );
      (userID != null ? registered : invitable).add(item);
    }

    _emitSorted(registered, invitable);
  }

  void _emitSorted(List<ContactItem> registered, List<ContactItem> invitable) {
    registered.sort((a, b) => a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));
    invitable.sort((a, b) => a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));

    emit(state.copyWith(status: Status.success, permissionDenied: false, registered: registered, invitable: invitable));
  }

  /// Сохраняет полный снимок книги (registered + invitable) в БД для мгновенного
  /// показа при следующем запуске.
  Future<void> _writeSnapshot(Map<String, _Entry> entries, Map<String, Uint8List> userByE164) {
    return repositories.contacts.replaceAll([
      for (final entry in entries.values)
        ContactCacheEntry(
          phoneE164: entry.phoneE164,
          displayName: entry.displayName,
          phone: entry.phone,
          userID: userByE164[entry.phoneE164],
        ),
    ]);
  }
}
