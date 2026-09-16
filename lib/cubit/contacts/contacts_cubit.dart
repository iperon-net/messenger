import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

import '../../api.dart';
import '../../auth.dart';
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

/// Контакт, добавленный вручную по номеру (источник MANUAL). В отличие от записей
/// из телефонной книги его нет в устройстве, поэтому он хранится отдельно (в кэше)
/// и подмешивается в каждый discover — иначе replace-all снимка стёр бы его.
class _ManualContact {
  final String raw;
  final String phoneE164;
  final String phone;
  final String displayName;

  const _ManualContact({required this.raw, required this.phoneE164, required this.phone, required this.displayName});

  Map<String, dynamic> toJson() => {"raw": raw, "e164": phoneE164, "phone": phone, "name": displayName};

  factory _ManualContact.fromJson(Map<String, dynamic> json) => _ManualContact(
    raw: json["raw"] as String,
    phoneE164: json["e164"] as String,
    phone: json["phone"] as String,
    displayName: json["name"] as String,
  );
}

/// Итог ручного добавления контакта по номеру (для текста пользователю).
enum ContactAddResult { addedRegistered, addedPending, invalidNumber, failed }

/// Экран «Контакты»: находит, кто из телефонной книги зарегистрирован в Iperon,
/// не раскрывая серверу сырые номера. Раунд 1 — слепая OPRF-оценка, раунд 2 —
/// проверка членства по отпечаткам. См. docs/plans/functional-stirring-giraffe.md.
class ContactsCubit extends Cubit<ContactsState> with WidgetsBindingObserver {
  ContactsCubit() : super(const ContactsState()) {
    // Реагируем на изменения книги устройства (добавили/изменили/удалили
    // контакт), пока приложение открыто, и на возврат в foreground — иначе
    // discover() крутится лишь при старте shell, первом показе вкладки и
    // pull-to-refresh, и новый контакт не появляется до перезапуска вкладки.
    WidgetsBinding.instance.addObserver(this);
    _bookChangeSub = FlutterContacts.onDatabaseChange.listen((_) => _onBookChanged());
  }

  final logger = getIt.get<Logger>();
  final api = getIt.get<API>();
  final utils = getIt.get<Utils>();
  final crypto = getIt.get<Crypto>();
  final repositories = getIt.get<Repositories>();
  final auth = getIt.get<Auth>();

  // Батч discovery. Совпадает по духу с серверным contactsDiscoveryBatchLimit
  // (1024) — держим ниже лимита, чтобы большая книга уходила пачками.
  static const int _batchSize = 512;

  // Ключ кэша с отпечатком книги (набор номеров, по которому уже был OPRF) и
  // интервал, дольше которого не доверяем неизменной книге — пересинхронизируемся,
  // чтобы подхватить контакты, зарегистрировавшиеся в Iperon после прошлого поиска.
  static const String _fingerprintKey = "contacts_book_fingerprint";
  static const Duration _resyncInterval = Duration(hours: 24);

  // Локальный exclusion-set: e164 контактов, удалённых пользователем вручную
  // (`removeContact`). Номер ещё в телефонной книге, поэтому без этого набора
  // следующий discovery вернул бы его рёбром OPRF. Держим в памяти + в кэше.
  static const String _excludedKey = "contacts_excluded_e164";
  Set<String>? _excluded;

  // Локально добавленные вручную контакты (`addByNumber`), keyed by e164. Их нет
  // в телефонной книге, поэтому храним отдельно и подмешиваем в discover, чтобы
  // replace-all снимка их не стёр. В памяти + в кэше.
  static const String _manualKey = "contacts_manual";
  Map<String, _ManualContact>? _manual;

  // Один discover идёт за раз (guard от параллельных запусков), а _discoverStarted
  // помнит, был ли он вообще запущен в этой сессии — чтобы первый показ вкладки не
  // дублировал уже стартовавшую фоновую дозагрузку.
  bool _discovering = false;
  bool _discoverStarted = false;

  // Подписка на изменения телефонной книги + дебаунс: нативный слушатель при
  // массовой синхронизации сыпет событиями пачкой, гоняем discover один раз.
  StreamSubscription<void>? _bookChangeSub;
  Timer? _bookChangeDebounce;
  static const Duration _bookChangeDebounceDelay = Duration(milliseconds: 700);

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
    // Вручную удалённые (exclusion-set) тоже прячем — снимок мог быть записан до
    // удаления, а перезапишется он лишь на следующем discover.
    final excluded = await _loadExcluded();
    if (isClosed) return;
    final visible = cached.where((entry) => entry.displayName.isNotEmpty && !excluded.contains(entry.phoneE164)).toList(growable: false);
    if (visible.isEmpty) return;

    final manual = await _loadManual();
    if (isClosed) return;
    _emitFromCache(visible, manual.keys.toSet());
  }

  /// Фаза B без диалога: если доступ к контактам уже выдан, тихо запускаем полный
  /// discover в фоне (номера и так доступны — системного диалога не будет).
  /// Иначе ничего не делаем: запрос разрешения откладываем до открытия вкладки.
  Future<void> discoverIfAlreadyGranted() async {
    final status = await ph.Permission.contacts.status;
    if (isClosed) return;
    if (status.isGranted || status.isLimited) await discover();
  }

  /// Изменилась книга устройства: дебаунсим всплеск событий и тихо
  /// пересинхронизируемся (без диалога разрешений). Дешёвая перерисовка идёт
  /// всегда; OPRF — только если поменялся набор номеров (fingerprint).
  void _onBookChanged() {
    _bookChangeDebounce?.cancel();
    _bookChangeDebounce = Timer(_bookChangeDebounceDelay, () {
      if (isClosed) return;
      discoverIfAlreadyGranted();
    });
  }

  /// Подстраховка к нативному слушателю: если книгу изменили, пока приложение
  /// было свёрнуто (нотификация могла не долететь), подхватываем на возврате.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) discoverIfAlreadyGranted();
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    _bookChangeDebounce?.cancel();
    _bookChangeSub?.cancel();
    return super.close();
  }

  /// Фаза B — запрос разрешения, чтение книги и OPRF-поиск. Вызывается при первом
  /// показе вкладки (осознанный запрос разрешения) и из refresh().
  ///
  /// Дорогой OPRF-раунд пропускается, если набор номеров в книге не изменился с
  /// прошлого поиска и тот ещё не «протух» ([_resyncInterval]); [force] (ручной
  /// refresh) обходит эту проверку. Чтение книги и обновление снимка (в т.ч. имён)
  /// выполняются всегда — они дёшевы.
  Future<void> discover({bool force = false}) async {
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

      // Собственный номер (из сессии) — его не показываем среди контактов.
      final ownUser = await repositories.users.getBySession(session: auth.session);
      if (isClosed) return;
      final ownPhoneE164 = utils.phoneNormalization(phoneNumber: ownUser.phoneNumber).e164;

      // Уникальные записи по e164; первое встреченное имя выигрывает.
      final entries = <String, _Entry>{};
      for (final contact in deviceContacts) {
        for (final phone in contact.phones) {
          final normalization = utils.phoneNormalization(phoneNumber: phone.number);
          if (normalization.e164.isEmpty || normalization.raw.isEmpty) continue;
          // Пропускаем собственный номер — себя в контактах не показываем.
          if (ownPhoneE164.isNotEmpty && normalization.e164 == ownPhoneE164) continue;

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

      // Прячем вручную удалённые контакты: их не показываем и не отправляем в
      // граф (иначе OPRF-ребро вернулось бы, т.к. номер ещё в книге).
      final excluded = await _loadExcluded();
      if (isClosed) return;
      entries.removeWhere((e164, _) => excluded.contains(e164));

      // Подмешиваем добавленные вручную контакты (их нет в книге устройства).
      // Запись из книги имеет приоритет — putIfAbsent не перезапишет её именем/номером.
      final manual = await _loadManual();
      if (isClosed) return;
      final manualE164 = manual.keys.toSet();
      for (final contact in manual.values) {
        if (excluded.contains(contact.phoneE164)) continue;
        entries.putIfAbsent(
          contact.phoneE164,
          () => _Entry(raw: contact.raw, phoneE164: contact.phoneE164, phone: contact.phone, displayName: contact.displayName),
        );
      }

      // Книга пуста (или частичный доступ ничего не отдал) — не трогаем снимок,
      // чтобы не стереть прошлый кэш; просто показываем пусто.
      if (entries.isEmpty) {
        emit(state.copyWith(status: Status.success, registered: const [], invitable: const [], cloud: const []));
        return;
      }

      // Сразу перерисовываем списки по свежей книге, используя лучшие known-userID
      // (из уже показанного снимка, включая облачные), и записываем снимок в БД.
      final known = {
        for (final item in [...state.registered, ...state.cloud])
          if (item.userID != null) item.phoneE164: item.userID!,
      };
      _emitLists(entries, known, manualE164);
      await _writeSnapshot(entries, known);
      if (isClosed) return;

      // Книга не менялась и прошлый поиск ещё свежий (запись жива по TTL) —
      // пропускаем дорогой OPRF, registered уже корректны из снимка.
      final userID = Uint8List.fromList(auth.session.userID);
      final fingerprint = _bookFingerprint(entries.values);
      if (!force) {
        final saved = await repositories.cache.getString(userID: userID, key: _fingerprintKey);
        if (isClosed) return;
        if (saved == fingerprint) {
          emit(state.copyWith(status: Status.success));
          return;
        }
      }

      // OPRF-поиск. Ошибка сети не критична — остаёмся на данных из снимка.
      // fullAccess: при полном доступе к книге серверу разрешаем replace-all
      // (стереть OPRF-рёбра, которых больше нет в книге); при iOS limited —
      // только добавление, чтобы не потерять легитимные рёбра вне выборки.
      try {
        final fullAccess = permission == PermissionStatus.granted;
        final matched = await _discoverOprf(entries.values.toList(growable: false), fullAccess: fullAccess);
        if (isClosed) return;

        _emitLists(entries, matched, manualE164);
        await _writeSnapshot(entries, matched);
        // Запоминаем отпечаток успешно синхронизированной книги (с TTL-страховкой).
        await repositories.cache.setString(userID: userID, key: _fingerprintKey, value: fingerprint, ttl: _resyncInterval);
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

  /// Повторный запуск поиска (pull-to-refresh / после выдачи разрешения) —
  /// форсирует OPRF даже при неизменной книге.
  Future<void> refresh() => discover(force: true);

  /// Кнопка «Разрешить доступ» на экране-заглушке. Пробуем штатный системный
  /// диалог (тем же плагином, что и discover — иначе статусы двух плагинов
  /// расходятся). Если доступ выдан — сразу ищем; если система диалог уже не
  /// показывает (отклонён навсегда / разовое решение iOS), request просто вернёт
  /// не-granted — тогда единственный путь это системные настройки, туда и ведём.
  /// По возврату из настроек выданный доступ подхватит resumed-хук
  /// (didChangeAppLifecycleState → discoverIfAlreadyGranted).
  Future<void> requestAccess() async {
    final permission = await FlutterContacts.permissions.request(PermissionType.read);
    if (isClosed) return;
    if (permission == PermissionStatus.granted || permission == PermissionStatus.limited) {
      await discover(force: true);
      return;
    }
    await ph.openAppSettings();
  }

  /// Отпечаток книги для OPRF: отсортированный набор номеров (e164). Имена/номера
  /// показа в него не входят — они не влияют на результат поиска и обновляются в
  /// снимке отдельно.
  String _bookFingerprint(Iterable<_Entry> entries) {
    final keys = entries.map((entry) => entry.phoneE164).toList()..sort();
    return keys.join("|");
  }

  void search(String query) => emit(state.copyWith(query: query));

  /// Выполняет двухраундовый OPRF-поиск по [allEntries] пачками и возвращает
  /// карту `e164 -> userID` для зарегистрированных. Попутно (best-effort)
  /// синхронизирует серверный граф контактов (облачную адресную книгу) через
  /// `CONTACTS_UPSERT`: те же OPRF-отпечатки уходят рёбрами источника OPRF, что
  /// наполняет граф для гейта звонков. [fullAccess] → на первой пачке разрешаем
  /// серверу replace-all (снести устаревшие OPRF-рёбра).
  Future<Map<String, Uint8List>> _discoverOprf(List<_Entry> allEntries, {required bool fullAccess}) async {
    final result = <String, Uint8List>{};
    var firstBatch = true;

    for (var offset = 0; offset < allEntries.length; offset += _batchSize) {
      final chunk = allEntries.sublist(offset, (offset + _batchSize).clamp(0, allEntries.length));

      // Входы OPRF в порядке чанка — общий порядок для blind/evaluate/finalize.
      final inputs = [for (final entry in chunk) utf8.encode(entry.raw)];

      // Раунд 1 + финализация → OPRF-отпечатки (== user.oprf на сервере).
      final oprfOutputs = await _oprfOutputs(inputs);
      final entryByOprf = <String, _Entry>{for (var i = 0; i < chunk.length; i++) utils.bytesToHex(oprfOutputs[i]): chunk[i]};

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

      // Наполнение серверного графа контактов теми же отпечатками (best-effort:
      // сбой не должен ломать discovery). full — только на первой пачке, чтобы
      // replace-all не стёр ещё не отправленные пачки.
      await _upsertGraph(oprfOutputs, full: fullAccess && firstBatch);
      firstBatch = false;
    }

    return result;
  }

  /// Отправляет OPRF-отпечатки пачки в серверный граф контактов
  /// (`CONTACTS_UPSERT`, источник OPRF). Best-effort — ошибку только логируем.
  Future<void> _upsertGraph(List<Uint8List> oprfOutputs, {required bool full}) async {
    if (oprfOutputs.isEmpty) return;

    try {
      final request = ContactsUpsert_Request(
        full: full,
        items: [for (final oprf in oprfOutputs) ContactsUpsert_Item(oprf: oprf, source: ContactsUpsert_Source.OPRF)],
      );

      final status = await api.unaryEncoded(MessageType.CONTACTS_UPSERT, request.writeToBuffer());
      if (status.status != APIStatus.success) {
        logger.warning('contacts: graph upsert failed (${status.error})');
      }
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  /// Раунд 1 OPRF (blind → серверный evaluate → finalize) для [inputs] (≤ пачки).
  /// Возвращает финализированные OPRF-отпечатки в порядке входа. Кидает при
  /// сетевой/серверной ошибке. Общий примитив для discovery и ручного add/remove.
  Future<List<Uint8List>> _oprfOutputs(List<List<int>> inputs) async {
    final (blinds, blindedElements) = await crypto.oprf.blindBatch(inputs);

    final (evaluateStatus, evaluatePayload) = await api.unaryEncodedWithResponse(
      MessageType.CONTACTS_DISCOVERY_EVALUATE,
      ContactsDiscoveryEvaluate_Request(blindedElements: blindedElements).writeToBuffer(),
    );
    if (evaluateStatus.status != APIStatus.success || evaluatePayload == null) {
      throw Exception('contacts: evaluate failed (${evaluateStatus.error})');
    }
    final evaluateResponse = ContactsDiscoveryEvaluate_Response.fromBuffer(evaluatePayload);

    return crypto.oprf.finalizeBatch(
      inputs: inputs,
      blinds: blinds,
      evaluations: [for (final element in evaluateResponse.evaluatedElements) Uint8List.fromList(element)],
    );
  }

  /// Ручное добавление контакта по номеру (источник MANUAL). Прогоняет OPRF по
  /// одному номеру, кладёт ребро в облачную книгу (`CONTACTS_UPSERT`, full=false —
  /// добавление, не replace-all) и проверяет членство (`MATCH`), чтобы сообщить
  /// пользователю, зарегистрирован ли контакт. Имя/фамилия формируют отображаемое
  /// имя (при пустом — показываем сам номер). Контакт сразу появляется в списке:
  /// кладём его в локальный manual-set (переживает ре-синхронизацию, т.к. в книге
  /// устройства его нет), в снимок БД и в текущее состояние. Снимает номер из
  /// exclusion-set (если ранее удаляли). Возвращает [ContactAddResult].
  Future<ContactAddResult> addByNumber({required String firstName, required String lastName, required String rawNumber}) async {
    final normalization = utils.phoneNormalization(phoneNumber: rawNumber);
    if (normalization.e164.isEmpty || normalization.raw.isEmpty) {
      return ContactAddResult.invalidNumber;
    }

    final name = [firstName.trim(), lastName.trim()].where((part) => part.isNotEmpty).join(" ");
    final displayName = name.isNotEmpty ? name : normalization.international;

    try {
      final oprfOutputs = await _oprfOutputs([utf8.encode(normalization.raw)]);
      if (oprfOutputs.isEmpty) return ContactAddResult.failed;
      final oprf = oprfOutputs.first;

      final upsertStatus = await api.unaryEncoded(
        MessageType.CONTACTS_UPSERT,
        ContactsUpsert_Request(
          full: false,
          items: [ContactsUpsert_Item(oprf: oprf, source: ContactsUpsert_Source.MANUAL)],
        ).writeToBuffer(),
      );
      if (upsertStatus.status != APIStatus.success) {
        logger.warning('contacts: manual add failed (${upsertStatus.error})');
        return ContactAddResult.failed;
      }

      // Ранее удалённый номер снова разрешаем показывать/синхронизировать.
      await _unexclude(normalization.e164);

      // Членство: userID зарегистрированного контакта (или null — ещё не в Iperon).
      final userID = await _matchUserID(oprf);

      // Запоминаем как ручной контакт (переживёт replace-all снимка) и сразу
      // показываем: обновляем состояние и снимок БД.
      final contact = _ManualContact(
        raw: normalization.raw,
        phoneE164: normalization.e164,
        phone: normalization.international,
        displayName: displayName,
      );
      await _addManual(contact);
      await _insertContact(contact, userID);
      await repositories.contacts.upsertOne(
        ContactCacheEntry(phoneE164: contact.phoneE164, displayName: contact.displayName, phone: contact.phone, userID: userID),
      );

      return userID != null ? ContactAddResult.addedRegistered : ContactAddResult.addedPending;
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      return ContactAddResult.failed;
    }
  }

  /// Вставляет/обновляет один контакт в текущем состоянии по e164 и
  /// перераскладывает по группам — для мгновенного показа после ручного
  /// добавления (он попадёт в «Облачные контакты», т.к. уже в manual-set).
  Future<void> _insertContact(_ManualContact contact, Uint8List? userID) async {
    if (isClosed) return;

    final item = ContactItem(displayName: contact.displayName, phone: contact.phone, phoneE164: contact.phoneE164, userID: userID);
    final all = [
      for (final c in [...state.registered, ...state.cloud, ...state.invitable])
        if (c.phoneE164 != contact.phoneE164) c,
      item,
    ];

    final manual = await _loadManual();
    if (isClosed) return;
    _emitPartitioned(all, manual.keys.toSet());
  }

  /// Удаляет контакт из облачной книги (`CONTACTS_REMOVE` по OPRF-отпечатку его
  /// номера) и запоминает номер в локальном exclusion-set, чтобы следующий
  /// discovery не вернул его обратно рёбром OPRF (номер ещё в телефонной книге).
  Future<void> removeContact(ContactItem item) async {
    final normalization = utils.phoneNormalization(phoneNumber: item.phoneE164);
    if (normalization.raw.isEmpty) return;

    try {
      final oprfOutputs = await _oprfOutputs([utf8.encode(normalization.raw)]);
      if (oprfOutputs.isEmpty) return;

      final status = await api.unaryEncoded(MessageType.CONTACTS_REMOVE, ContactsRemove_Request(oprf: [oprfOutputs.first]).writeToBuffer());
      if (status.status != APIStatus.success) {
        logger.warning('contacts: remove failed (${status.error})');
        return;
      }

      await _exclude(item.phoneE164);
      // Если контакт был добавлен вручную — убираем и из manual-set.
      await _removeManual(item.phoneE164);

      // Убираем из показа сразу, не дожидаясь следующего discovery.
      if (!isClosed) {
        emit(
          state.copyWith(
            registered: state.registered.where((c) => c.phoneE164 != item.phoneE164).toList(growable: false),
            invitable: state.invitable.where((c) => c.phoneE164 != item.phoneE164).toList(growable: false),
            cloud: state.cloud.where((c) => c.phoneE164 != item.phoneE164).toList(growable: false),
          ),
        );
      }
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  /// Членство одного OPRF-отпечатка через `MATCH`: userID зарегистрированного
  /// пользователя или `null`, если он ещё не в Iperon.
  Future<Uint8List?> _matchUserID(Uint8List oprf) async {
    final (matchStatus, matchPayload) = await api.unaryEncodedWithResponse(
      MessageType.CONTACTS_DISCOVERY_MATCH,
      ContactsDiscoveryMatch_Request(oprfOutputs: [oprf]).writeToBuffer(),
    );
    if (matchStatus.status != APIStatus.success || matchPayload == null) return null;
    final matches = ContactsDiscoveryMatch_Response.fromBuffer(matchPayload).matches;
    if (matches.isEmpty) return null;
    return Uint8List.fromList(matches.first.userID);
  }

  /// Ленивая загрузка exclusion-set из кэша (один раз за сессию, затем из памяти).
  Future<Set<String>> _loadExcluded() async {
    final cached = _excluded;
    if (cached != null) return cached;

    final userID = Uint8List.fromList(auth.session.userID);
    final raw = await repositories.cache.getString(userID: userID, key: _excludedKey);
    final loaded = raw == null ? <String>{} : (jsonDecode(raw) as List).cast<String>().toSet();
    _excluded = loaded;
    return loaded;
  }

  Future<void> _saveExcluded(Set<String> excluded) async {
    final userID = Uint8List.fromList(auth.session.userID);
    await repositories.cache.setString(userID: userID, key: _excludedKey, value: jsonEncode(excluded.toList()));
  }

  Future<void> _exclude(String e164) async {
    final excluded = await _loadExcluded();
    if (excluded.add(e164)) await _saveExcluded(excluded);
  }

  Future<void> _unexclude(String e164) async {
    final excluded = await _loadExcluded();
    if (excluded.remove(e164)) await _saveExcluded(excluded);
  }

  /// Ленивая загрузка manual-set из кэша (один раз за сессию, затем из памяти).
  Future<Map<String, _ManualContact>> _loadManual() async {
    final cached = _manual;
    if (cached != null) return cached;

    final userID = Uint8List.fromList(auth.session.userID);
    final raw = await repositories.cache.getString(userID: userID, key: _manualKey);
    final loaded = <String, _ManualContact>{};
    if (raw != null) {
      for (final item in jsonDecode(raw) as List) {
        final contact = _ManualContact.fromJson(item as Map<String, dynamic>);
        loaded[contact.phoneE164] = contact;
      }
    }
    _manual = loaded;
    return loaded;
  }

  Future<void> _saveManual(Map<String, _ManualContact> manual) async {
    final userID = Uint8List.fromList(auth.session.userID);
    await repositories.cache.setString(userID: userID, key: _manualKey, value: jsonEncode([for (final c in manual.values) c.toJson()]));
  }

  Future<void> _addManual(_ManualContact contact) async {
    final manual = await _loadManual();
    manual[contact.phoneE164] = contact;
    await _saveManual(manual);
  }

  Future<void> _removeManual(String e164) async {
    final manual = await _loadManual();
    if (manual.remove(e164) != null) await _saveManual(manual);
  }

  void _emitLists(Map<String, _Entry> entries, Map<String, Uint8List> userByE164, Set<String> manualE164) {
    if (isClosed) return;

    final items = [
      for (final entry in entries.values)
        ContactItem(displayName: entry.displayName, phone: entry.phone, phoneE164: entry.phoneE164, userID: userByE164[entry.phoneE164]),
    ];
    _emitPartitioned(items, manualE164);
  }

  /// Показ полного снимка из БД (фаза A) — без нормализации, прямо из кэша.
  void _emitFromCache(List<ContactCacheEntry> cached, Set<String> manualE164) {
    final items = [
      for (final entry in cached)
        ContactItem(
          displayName: entry.displayName,
          phone: entry.phone,
          phoneE164: entry.phoneE164,
          userID: entry.userID == null ? null : Uint8List.fromList(entry.userID!),
        ),
    ];
    _emitPartitioned(items, manualE164);
  }

  /// Раскладывает контакты по трём группам и эмитит отсортированными: «облачные»
  /// (в [manualE164] — добавлены вручную, любого статуса), «в контактах»
  /// (из книги, зарегистрированы) и «пригласить» (из книги, не в Iperon).
  void _emitPartitioned(List<ContactItem> items, Set<String> manualE164) {
    if (isClosed) return;

    final registered = <ContactItem>[];
    final invitable = <ContactItem>[];
    final cloud = <ContactItem>[];

    for (final item in items) {
      if (manualE164.contains(item.phoneE164)) {
        cloud.add(item);
      } else if (item.userID != null) {
        registered.add(item);
      } else {
        invitable.add(item);
      }
    }

    int byName(ContactItem a, ContactItem b) => a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase());
    registered.sort(byName);
    invitable.sort(byName);
    cloud.sort(byName);

    emit(state.copyWith(status: Status.success, permissionDenied: false, registered: registered, invitable: invitable, cloud: cloud));
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
