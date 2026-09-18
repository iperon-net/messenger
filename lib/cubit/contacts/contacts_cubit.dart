import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:grpc/grpc.dart' show StatusCode;
import 'package:permission_handler/permission_handler.dart' as ph;

import '../../api.dart';
import '../../auth.dart';
import '../../constants.dart';
import '../../crypto.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../protobuf.dart';
import '../../protobuf.dart' as pb show Contact;
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

/// Облачный контакт (синхронизируемый между устройствами; источник истины —
/// сервер). [oprfHex] — отпечаток номера, по которому сопоставляется входящее
/// удаление (`CONTACTS_UPDATED.removedOprf`).
class _CloudContact {
  final String e164;
  final String displayName;
  final String phone;
  final Uint8List? userID;
  final String oprfHex;

  const _CloudContact({required this.e164, required this.displayName, required this.phone, this.userID, required this.oprfHex});
}

/// Итог ручного добавления контакта по номеру (для текста пользователю).
enum ContactAddResult { addedRegistered, addedPending, invalidNumber, limitReached, failed }

/// Данные формы добавления контакта — возвращаются экраном добавления в список
/// контактов, который затем вызывает [ContactsCubit.addByNumber].
class ContactAddInput {
  final String firstName;
  final String lastName;
  final String phone;

  const ContactAddInput({required this.firstName, required this.lastName, required this.phone});
}

/// Экран «Контакты». Держит две дорожки:
///   • книжные контакты — приватный поиск через OPRF (кто из телефонной книги
///     зарегистрирован в Iperon), сырые номера серверу не раскрываются; имена/
///     номера живут только локально;
///   • облачные контакты — добавленные вручную по номеру, синхронизируемые между
///     устройствами. Их PII (имя/номер) сервер хранит зашифрованными at-rest и
///     рассылает на устройства владельца (`CONTACTS_LIST` — pull, `CONTACTS_UPDATED`
///     — push). Источник истины по ним — сервер.
/// См. docs/plans/functional-stirring-giraffe.md и docs/plans/cloud-contacts-sync.md.
class ContactsCubit extends Cubit<ContactsState> with WidgetsBindingObserver {
  ContactsCubit() : super(const ContactsState()) {
    // Реагируем на изменения книги устройства (добавили/изменили/удалили
    // контакт), пока приложение открыто, и на возврат в foreground — иначе
    // discover() крутится лишь при старте shell, первом показе вкладки и
    // pull-to-refresh, и новый контакт не появляется до перезапуска вкладки.
    WidgetsBinding.instance.addObserver(this);
    _bookChangeSub = FlutterContacts.onDatabaseChange.listen((_) => _onBookChanged());
    // Дельты облачных контактов с сервера (add/update/remove/резолв) на все
    // устройства владельца — держим локальную книгу облачных в синхроне.
    _updatedSub = api.on(MessageType.CONTACTS_UPDATED).listen(_onCloudUpdated);
    // Присутствие (online/last-seen) видимых контактов приходит по стриму:
    //   • начальный снимок — сервер шлёт PRESENCE сразу при подписке (subscribe);
    //   • дальше — push на каждый переход online/offline контакта.
    // Отдельного поллинга нет; ручной pull-to-refresh делает refreshPresence().
    // Реконнект стрима присылает снимок заново — так освежается «залипший» онлайн
    // после жёсткого обрыва контакта (offline-push в этом случае не приходит).
    _presenceSub = api.on(MessageType.PRESENCE).listen(_onPresencePush);
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

  // Локальный exclusion-set: e164 книжных контактов, удалённых пользователем
  // вручную (`removeContact`). Номер ещё в телефонной книге, поэтому без этого
  // набора следующий discovery вернул бы его рёбром OPRF. Держим в памяти + в кэше.
  static const String _excludedKey = "contacts_excluded_e164";
  Set<String>? _excluded;

  // Legacy-ключ локальных ручных контактов (до облачной синхронизации). Разово
  // переносится в облако (_backfillLegacyManual) и очищается.
  static const String _legacyManualKey = "contacts_manual";

  // Текущий книжный список (до разбивки на группы) и облачные контакты (keyed by
  // e164). Из них [_emitAll] собирает три группы состояния.
  List<ContactItem> _book = const [];
  final Map<String, _CloudContact> _cloud = {};

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

  // Подписка на push-дельты облачных контактов.
  StreamSubscription<Uint8List>? _updatedSub;

  // Присутствие видимых контактов, keyed by userID (hex). Живёт только в памяти
  // (не персистим: online — эфемерно, после рестарта показал бы «залипший»
  // онлайн). Наполняется [refreshPresence], сливается в элементы в [_emitAll].
  final Map<String, ({bool online, DateTime? lastSeen})> _presence = {};
  StreamSubscription<Uint8List>? _presenceSub;

  /// Старт на уровне shell: мгновенный показ снимка из БД, затем облачная
  /// синхронизация с сервером, тихая фоновая книжная дозагрузка (если доступ уже
  /// выдан) и разовый перенос legacy-ручных контактов в облако.
  Future<void> bootstrap() async {
    await preload();
    await Future.wait([_fetchCloud(), discoverIfAlreadyGranted()]);
    await _backfillLegacyManual();
    // Присутствие не тянем здесь: начальный снимок придёт по стриму (subscribe).
  }

  /// Тянет присутствие (online/last-seen) всех зарегистрированных контактов
  /// (книжных + облачных) одним batch-запросом PRESENCE и обновляет списки.
  /// Используется под ручной pull-to-refresh (в т.ч. чтобы принудительно сбросить
  /// «залипший» онлайн). Обычные обновления приходят по стриму (снимок + push).
  /// Видимость гейтится на сервере звонковой приватностью цели. Ошибка сети не
  /// критична: остаёмся на прошлых данных.
  Future<void> refreshPresence() async {
    final ids = <Uint8List>[];
    final seen = <String>{};
    void add(Uint8List? userID) {
      if (userID == null) return;
      if (seen.add(utils.bytesToHex(userID))) ids.add(userID);
    }

    for (final item in _book) {
      add(item.userID);
    }
    for (final contact in _cloud.values) {
      add(contact.userID);
    }
    if (ids.isEmpty) return;

    final (status, payload) = await api.unaryEncodedWithResponse(MessageType.PRESENCE, Presence_Request(userIDs: ids).writeToBuffer());
    if (isClosed || status.status != APIStatus.success || payload == null) return;

    final response = Presence_Response.fromBuffer(payload);
    _applyPresenceItems(response.items);
    if (!isClosed) _emitAll();
  }

  /// Реактивный push: сервер прислал смену статуса контакта (PRESENCE с одним
  /// item при переходе online/offline). Сливаем и сразу перерисовываем.
  void _onPresencePush(Uint8List payload) {
    if (isClosed) return;
    final response = Presence_Response.fromBuffer(payload);
    if (response.items.isEmpty) return;
    _applyPresenceItems(response.items);
    _emitAll();
  }

  /// Кладёт присутствие из PRESENCE-items в [_presence] (общий код pull и push).
  void _applyPresenceItems(List<Presence_Item> items) {
    for (final item in items) {
      final seconds = item.lastSeen.toInt();
      _presence[utils.bytesToHex(Uint8List.fromList(item.userID))] = (
        online: item.online,
        // 0 — никогда не подключался: статус неизвестен, пусть UI покажет
        // «был(а) недавно», а не эпоху 1970.
        lastSeen: seconds > 0 ? DateTime.fromMillisecondsSinceEpoch(seconds * 1000) : null,
      );
    }
  }

  /// Дополняет контакт присутствием из [_presence] (если известно).
  ContactItem _withPresence(ContactItem item) {
    final userID = item.userID;
    if (userID == null) return item;
    final presence = _presence[utils.bytesToHex(userID)];
    if (presence == null) return item;
    return item.copyWith(online: presence.online, lastSeen: presence.lastSeen);
  }

  /// Фаза A — мгновенный показ полного снимка из БД, без разрешений и без сети.
  /// Вызывается на уровне shell при старте, ещё до открытия вкладки.
  Future<void> preload() async {
    final cached = await repositories.contacts.getAll();
    if (isClosed || cached.isEmpty) return;

    final excluded = await _loadExcluded();
    if (isClosed) return;

    final book = <ContactItem>[];
    _cloud.clear();
    for (final entry in cached) {
      if (entry.isCloud) {
        _cloud[entry.phoneE164] = _CloudContact(
          e164: entry.phoneE164,
          displayName: entry.displayName,
          phone: entry.phone,
          userID: entry.userID == null ? null : Uint8List.fromList(entry.userID!),
          oprfHex: entry.oprf == null ? "" : utils.bytesToHex(Uint8List.fromList(entry.oprf!)),
        );
        continue;
      }
      // Пустое имя = legacy-запись из миграции 2→3 (до неё имя/номер не хранились) —
      // её нечем показать. Вручную удалённые (exclusion-set) тоже прячем.
      if (entry.displayName.isEmpty || excluded.contains(entry.phoneE164)) continue;
      book.add(
        ContactItem(
          displayName: entry.displayName,
          phone: entry.phone,
          phoneE164: entry.phoneE164,
          userID: entry.userID == null ? null : Uint8List.fromList(entry.userID!),
        ),
      );
    }

    _book = book;
    if (_book.isEmpty && _cloud.isEmpty) return;
    _emitAll();
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
  /// пересинхронизируемся (без диалога разрешений).
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
    _updatedSub?.cancel();
    _presenceSub?.cancel();
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

      // Прячем вручную удалённые книжные контакты: их не показываем и не
      // отправляем в граф (иначе OPRF-ребро вернулось бы, т.к. номер ещё в книге).
      final excluded = await _loadExcluded();
      if (isClosed) return;
      entries.removeWhere((e164, _) => excluded.contains(e164));

      // Книга пуста (или частичный доступ ничего не отдал) — не трогаем книжный
      // снимок, чтобы не стереть прошлый кэш; просто показываем облачные.
      if (entries.isEmpty) {
        _book = const [];
        _emitAll();
        return;
      }

      // Сразу перерисовываем списки по свежей книге, используя лучшие known-userID
      // (из уже показанного снимка, включая облачные), и записываем снимок в БД.
      final known = <String, Uint8List>{
        for (final item in _book)
          if (item.userID != null) item.phoneE164: item.userID!,
        for (final contact in _cloud.values)
          if (contact.userID != null) contact.e164: contact.userID!,
      };
      _book = _bookItems(entries, known);
      _emitAll();
      await repositories.contacts.replaceBook(_bookSnapshot(entries, known));
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
      try {
        final fullAccess = permission == PermissionStatus.granted;
        final matched = await _discoverOprf(entries.values.toList(growable: false), fullAccess: fullAccess);
        if (isClosed) return;

        _book = _bookItems(entries, matched);
        _emitAll();
        await repositories.contacts.replaceBook(_bookSnapshot(entries, matched));
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
  /// форсирует OPRF даже при неизменной книге; заодно пересинхронизирует облачные
  /// и присутствие.
  Future<void> refresh() async {
    await Future.wait([discover(force: true), _fetchCloud(), refreshPresence()]);
  }

  /// Кнопка «Разрешить доступ» на экране-заглушке. Пробуем штатный системный
  /// диалог (тем же плагином, что и discover — иначе статусы двух плагинов
  /// расходятся). Если доступ выдан — сразу ищем; если система диалог уже не
  /// показывает (отклонён навсегда / разовое решение iOS), request просто вернёт
  /// не-granted — тогда единственный путь это системные настройки, туда и ведём.
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
  /// показа в него не входят — они не влияют на результат поиска.
  String _bookFingerprint(Iterable<_Entry> entries) {
    final keys = entries.map((entry) => entry.phoneE164).toList()..sort();
    return keys.join("|");
  }

  void search(String query) => emit(state.copyWith(query: query));

  /// Тянет полный список облачных контактов владельца (`CONTACTS_LIST`), заменяет
  /// локальную облачную книгу и снимок. Ошибка сети не критична — остаёмся на кэше.
  Future<void> _fetchCloud() async {
    final (status, payload) = await api.unaryEncodedWithResponse(MessageType.CONTACTS_LIST, ContactsList_Request().writeToBuffer());
    if (isClosed || status.status != APIStatus.success || payload == null) return;

    final response = ContactsList_Response.fromBuffer(payload);
    _cloud
      ..clear()
      ..addEntries(
        response.contacts.map((contact) {
          final cloud = _cloudFromProto(contact);
          return MapEntry(cloud.e164, cloud);
        }),
      );

    await repositories.contacts.replaceCloud([for (final contact in _cloud.values) _cacheEntry(contact)]);
    if (isClosed) return;
    _emitAll();
  }

  /// Push-дельта облачных контактов: применяем upsert/remove к локальной книге и
  /// снимку, затем перерисовываем.
  void _onCloudUpdated(Uint8List payload) {
    if (isClosed) return;

    final updated = ContactsUpdated.fromBuffer(payload);
    var changed = false;

    for (final contact in updated.upserted) {
      final cloud = _cloudFromProto(contact);
      _cloud[cloud.e164] = cloud;
      unawaited(repositories.contacts.upsertCloudOne(_cacheEntry(cloud)));
      changed = true;
    }

    for (final oprf in updated.removedOprf) {
      final hex = utils.bytesToHex(Uint8List.fromList(oprf));
      final e164 = _e164ByOprf(hex);
      if (e164 != null) {
        _cloud.remove(e164);
        unawaited(repositories.contacts.removeCloudOne(e164));
        changed = true;
      }
    }

    if (changed) _emitAll();
  }

  /// Ручное добавление контакта по номеру (облачный, источник MANUAL). Прогоняет
  /// OPRF по номеру, кладёт ребро с PII в облачную книгу (`CONTACTS_UPSERT`,
  /// full=false) и проверяет членство (`MATCH`), чтобы сообщить, зарегистрирован
  /// ли контакт. Контакт сразу появляется в списке (оптимистично; серверный
  /// `CONTACTS_UPDATED` затем согласует состояние на всех устройствах). Снимает
  /// номер из exclusion-set. Возвращает [ContactAddResult].
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

      // PII (имя/фамилия/номер) уходят открытым текстом в защищённом сессией
      // канале; сервер шифрует их at-rest. Номер — каноническим e164 (ключ книги).
      final upsertStatus = await api.unaryEncoded(
        MessageType.CONTACTS_UPSERT,
        ContactsUpsert_Request(
          full: false,
          items: [
            ContactsUpsert_Item(
              oprf: oprf,
              source: ContactsUpsert_Source.MANUAL,
              firstName: firstName.trim(),
              lastName: lastName.trim(),
              phoneNumber: normalization.e164,
            ),
          ],
        ).writeToBuffer(),
      );
      if (upsertStatus.status != APIStatus.success) {
        if (upsertStatus.statusCode == StatusCode.resourceExhausted) return ContactAddResult.limitReached;
        logger.warning('contacts: manual add failed (${upsertStatus.error})');
        return ContactAddResult.failed;
      }

      // Ранее удалённый номер снова разрешаем показывать/синхронизировать.
      await _unexclude(normalization.e164);

      // Членство: userID зарегистрированного контакта (или null — ещё не в Iperon).
      final userID = await _matchUserID(oprf);

      // Оптимистично показываем сразу (push согласует на всех устройствах).
      final cloud = _CloudContact(
        e164: normalization.e164,
        displayName: displayName,
        phone: normalization.international,
        userID: userID,
        oprfHex: utils.bytesToHex(oprf),
      );
      _cloud[cloud.e164] = cloud;
      await repositories.contacts.upsertCloudOne(_cacheEntry(cloud));
      if (!isClosed) _emitAll();

      return userID != null ? ContactAddResult.addedRegistered : ContactAddResult.addedPending;
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      return ContactAddResult.failed;
    }
  }

  /// Удаляет контакт из графа (`CONTACTS_REMOVE` по OPRF-отпечатку номера).
  /// Убирает из облачной книги (если был облачным) и заносит номер в exclusion-set,
  /// чтобы следующий discovery не вернул книжный контакт обратно рёбром OPRF.
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
      _cloud.remove(item.phoneE164);
      await repositories.contacts.removeCloudOne(item.phoneE164);
      _book = _book.where((c) => c.phoneE164 != item.phoneE164).toList(growable: false);

      if (!isClosed) _emitAll();
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  /// Разовый перенос legacy-ручных контактов (локальный ключ `contacts_manual`,
  /// до облачной синхронизации) в облако — иначе они «повиснут» лишь на старом
  /// устройстве. После переноса ключ очищаем, чтобы не повторять.
  Future<void> _backfillLegacyManual() async {
    final userID = Uint8List.fromList(auth.session.userID);
    final raw = await repositories.cache.getString(userID: userID, key: _legacyManualKey);
    if (isClosed || raw == null) return;

    try {
      final items = jsonDecode(raw) as List;
      for (final item in items) {
        final map = item as Map<String, dynamic>;
        final e164 = (map["e164"] as String?) ?? "";
        if (e164.isEmpty) continue;
        final name = ((map["name"] as String?) ?? "").trim();
        final space = name.indexOf(" ");
        final firstName = space < 0 ? name : name.substring(0, space);
        final lastName = space < 0 ? "" : name.substring(space + 1);
        await addByNumber(firstName: firstName, lastName: lastName, rawNumber: e164);
        if (isClosed) return;
      }
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }

    // Очищаем legacy-ключ, чтобы перенос не повторялся.
    await repositories.cache.setString(userID: userID, key: _legacyManualKey, value: jsonEncode(const []));
  }

  /// Выполняет двухраундовый OPRF-поиск по [allEntries] пачками и возвращает
  /// карту `e164 -> userID` для зарегистрированных. Попутно (best-effort)
  /// синхронизирует серверный граф контактов через `CONTACTS_UPSERT`: те же
  /// OPRF-отпечатки уходят рёбрами источника OPRF (без PII — приватные), что
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
  /// (`CONTACTS_UPSERT`, источник OPRF, без PII). Best-effort — ошибку логируем.
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

  /// Собирает книжные [ContactItem] из записей книги с известными userID.
  List<ContactItem> _bookItems(Map<String, _Entry> entries, Map<String, Uint8List> userByE164) {
    return [
      for (final entry in entries.values)
        ContactItem(displayName: entry.displayName, phone: entry.phone, phoneE164: entry.phoneE164, userID: userByE164[entry.phoneE164]),
    ];
  }

  /// Книжный снимок для БД (полный проход по книге).
  List<ContactCacheEntry> _bookSnapshot(Map<String, _Entry> entries, Map<String, Uint8List> userByE164) {
    return [
      for (final entry in entries.values)
        ContactCacheEntry(
          phoneE164: entry.phoneE164,
          displayName: entry.displayName,
          phone: entry.phone,
          userID: userByE164[entry.phoneE164],
        ),
    ];
  }

  _CloudContact _cloudFromProto(pb.Contact contact) {
    // Номер приходит каноническим e164 (клиент отправил его при добавлении).
    final e164 = contact.phoneNumber;
    final normalization = utils.phoneNormalization(phoneNumber: e164);
    final display = normalization.international.isNotEmpty ? normalization.international : e164;
    final name = [contact.firstName.trim(), contact.lastName.trim()].where((part) => part.isNotEmpty).join(" ");
    return _CloudContact(
      e164: e164,
      displayName: name.isNotEmpty ? name : display,
      phone: display,
      userID: contact.contactUserID.isEmpty ? null : Uint8List.fromList(contact.contactUserID),
      oprfHex: utils.bytesToHex(Uint8List.fromList(contact.oprf)),
    );
  }

  ContactCacheEntry _cacheEntry(_CloudContact contact) {
    return ContactCacheEntry(
      phoneE164: contact.e164,
      displayName: contact.displayName,
      phone: contact.phone,
      userID: contact.userID,
      isCloud: true,
      oprf: contact.oprfHex.isEmpty ? null : utils.hexToBytes(contact.oprfHex),
    );
  }

  String? _e164ByOprf(String oprfHex) {
    for (final entry in _cloud.entries) {
      if (entry.value.oprfHex == oprfHex) return entry.key;
    }
    return null;
  }

  /// Собирает три группы состояния из книжного списка [_book] и облачных [_cloud]:
  /// «облачные» (server-truth, любого статуса регистрации), «в контактах» (из
  /// книги, зарегистрированы) и «пригласить» (из книги, не в Iperon). Номер,
  /// присутствующий и в книге, и в облаке, показываем только как облачный.
  void _emitAll() {
    if (isClosed) return;

    final cloudKeys = _cloud.keys.toSet();
    final registered = <ContactItem>[];
    final invitable = <ContactItem>[];

    for (final item in _book) {
      if (cloudKeys.contains(item.phoneE164)) continue;
      // Присутствие только у зарегистрированных (есть userID); приглашаемым не нужно.
      if (item.userID != null) {
        registered.add(_withPresence(item));
      } else {
        invitable.add(item);
      }
    }

    final cloud = [
      for (final contact in _cloud.values)
        _withPresence(ContactItem(displayName: contact.displayName, phone: contact.phone, phoneE164: contact.e164, userID: contact.userID)),
    ];

    int byName(ContactItem a, ContactItem b) => a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase());
    registered.sort(byName);
    invitable.sort(byName);
    // В облачных сначала уже зарегистрированные в Iperon, затем ожидающие —
    // внутри каждой части по имени.
    cloud.sort((a, b) {
      if (a.isRegistered != b.isRegistered) return a.isRegistered ? -1 : 1;
      return byName(a, b);
    });

    emit(state.copyWith(status: Status.success, permissionDenied: false, registered: registered, invitable: invitable, cloud: cloud));
  }
}
