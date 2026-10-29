import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;

import 'account_scope.dart';
import 'di.dart';
import 'logger.dart';
import 'push.dart';
import 'repositories.dart';
import 'routers.dart';
import 'api.dart';
import 'protobuf.dart';
import 'utils.dart';

/// Несколько аккаунтов на устройстве (docs/plans/multi-account.md, этап 3.2):
/// список вошедших, добавление, переключение и уход из аккаунта. Экраны
/// («Настройки», вход) берут всё отсюда.

/// Сколько аккаунтов можно держать на устройстве (как в Telegram).
const maxAccounts = 3;

/// Вошедший аккаунт для списка: userID (hex, для заглушки аватара), подпись
/// (имя или отформатированный номер), аватар (путь к файлу, пусто — нет),
/// активный ли и непрочитанные чаты (у неактивного — последнее известное
/// число из его пушей, у активного — 0: его счётчик на вкладке «Чаты»).
typedef AccountEntry = ({String accountID, String userHex, String title, String avatarPath, bool active, int unread});

DeviceRepositories get _device => getIt.get<DeviceRepositories>();

/// Вошедшие аккаунты по порядку слотов; [withUnread] — с непрочитанными
/// неактивных (спрашивает натив).
Future<List<AccountEntry>> signedInAccounts({bool withUnread = false}) async {
  final current = AccountScope.current.accountID;
  final slots = await _device.accounts.all();
  final others = slots.any((slot) => slot.userID.isNotEmpty && slot.accountID != current);
  final badges = withUnread && others ? await PushManager.accountBadges() : const <String, int>{};
  final utils = getIt.get<Utils>();
  String phone(String digits) {
    final formatted = utils.phoneNormalization(phoneNumber: digits).international;
    return formatted.isNotEmpty ? formatted : '+$digits';
  }

  return [
    for (final slot in slots)
      if (slot.userID.isNotEmpty)
        (
          accountID: slot.accountID,
          userHex: utils.bytesToHex(slot.userID),
          title: slot.name.isNotEmpty ? slot.name : phone(slot.phoneNumber),
          avatarPath: _avatarFile(slot.accountID, slot.avatarPath),
          active: slot.accountID == current,
          unread: slot.accountID == current ? 0 : badges[slot.accountID] ?? 0,
        ),
  ];
}

/// Аватар слота: в `device.db` — путь внутри папки данных аккаунта
/// ([AccountProfileSync]). Прежний абсолютный путь в кэше — как есть, а если
/// файла там нет (на iOS после обновления меняется контейнер) — тот же файл в
/// нынешней папке кэша аккаунта. Нет файла — пусто (заглушка, а не битая
/// картинка).
String _avatarFile(String accountID, String stored) {
  if (stored.isEmpty) return '';
  final files = AccountFiles(supportDir: _device.supportDir, cacheRoot: _device.cacheRoot, accountID: accountID);
  final candidates = p.isAbsolute(stored)
      ? [stored, p.join(files.mediaDir.path, p.basename(stored))]
      : [p.join(files.dataDir.path, stored)];
  return candidates.where((path) => File(path).existsSync()).firstOrNull ?? '';
}

/// userID других аккаунтов, уже вошедших на устройстве: сервер не даст войти
/// в них ещё раз (`AuthConfirmation.signedInUserIDs`).
Future<List<Uint8List>> signedInUserIDs() async => [
  for (final slot in await _device.accounts.all())
    if (slot.userID.isNotEmpty && !slot.active) slot.userID,
];

/// Уже вошёл ли на устройстве другой аккаунт с номером [phoneNumber] (сравнение
/// по цифрам): проверка до звонка-пароля, без похода на сервер.
Future<bool> isPhoneSignedIn(String phoneNumber) async {
  String digits(String value) => value.replaceAll(RegExp(r'\D'), '');
  final phone = digits(phoneNumber);
  if (phone.isEmpty) return false;
  return (await _device.accounts.all()).any((slot) => slot.userID.isNotEmpty && !slot.active && digits(slot.phoneNumber) == phone);
}

/// Изменения списка аккаунтов (вход, выход, имя, аватар).
Stream<void> accountsChanged() => _device.accounts.changes();

/// Можно ли добавить ещё один аккаунт ([maxAccounts]).
Future<bool> canAddAccount() async => (await signedInAccounts()).length < maxAccounts;

/// «Добавить аккаунт»: новый пустой слот и вход в нём. Отмена входа —
/// [cancelAddAccount].
Future<void> addAccount() async {
  _addedFrom = AccountScope.current.accountID;
  final slot = await _device.accounts.createSlot();
  await switchAccount(slot);
}

/// Откуда нажали «Добавить аккаунт» — туда и вернуться по «Отмене».
String? _addedFrom;

/// Вошедший аккаунт, куда вернуться с экрана входа (добавляли аккаунт, а
/// потом передумали; вышли из одного из нескольких): тот, откуда добавляли,
/// иначе первый другой; null — других нет.
Future<String?> returnAccount() async {
  final others = [
    for (final account in await signedInAccounts())
      if (!account.active) account.accountID,
  ];
  if (others.contains(_addedFrom)) return _addedFrom;

  return others.firstOrNull;
}

/// Уйти из активного аккаунта в [accountID] и удалить активный слот с
/// устройства (папку, базу, пароль): отмена добавления аккаунта и выход из
/// одного из нескольких.
Future<void> leaveAccount(String accountID) async {
  final leaving = AccountScope.current.accountID;
  await switchAccount(accountID);
  await _device.removeAccount(leaving);
  await PushManager.forgetAccount(leaving);
}

/// Отмена «Добавить аккаунт» с экрана входа: назад в вошедший аккаунт, пустой
/// слот — удалить.
Future<void> cancelAddAccount() async {
  final target = await returnAccount();
  if (target == null) return;
  Routers.nextLocation = '/settings';
  try {
    await leaveAccount(target);
  } finally {
    // Переключение сорвалось — следующий корень откроется как обычно.
    Routers.nextLocation = null;
  }
}

/// Выход из активного аккаунта уже прошёл (сессия удалена): если есть другие
/// вошедшие — перейти в первый и удалить этот слот; иначе остаёмся на входе в
/// нём (данные сохраняются, как и раньше с одним аккаунтом).
Future<void> afterLogout() async {
  final target = await returnAccount();
  if (target == null) return;
  try {
    await leaveAccount(target);
  } catch (error, stackTrace) {
    getIt.get<Logger>().handle(error, stackTrace);
  }
}

/// Отклонить входящий звонок неактивному аккаунту [accountID], не
/// переключаясь: `CALL_REJECT` от его сессии по общему каналу (сервер тот же).
/// [busy] — «занято» (идёт другой звонок): звонящий услышит короткие гудки.
/// Его сессии нет — ничего (звонящий дождётся отмены по таймауту).
Future<void> rejectCallAs(String accountID, {required String callId, required List<int> toUserID, bool busy = false}) async {
  if (toUserID.isEmpty) return;
  try {
    final session = await _device.sessionOf(accountID);
    if (session == null) return;
    final ring = CallRing(callId: callId, toUserID: Uint8List.fromList(toUserID), busy: busy);
    await getIt.get<API>().unaryEncodedAs(session, MessageType.CALL_REJECT, ring.writeToBuffer());
  } catch (error, stackTrace) {
    getIt.get<Logger>().handle(error, stackTrace);
  }
}

/// Имя и аватар активного аккаунта — в его слот `device.db`: список аккаунтов
/// показывает и неактивные, чьи базы закрыты. Аватар копируется в папку
/// данных аккаунта ([_avatarDir]), а в слот идёт путь относительно неё: файл
/// кэша система может удалить, а абсолютный путь на iOS ломается при смене
/// контейнера после обновления — неактивный аккаунт его не перепишет, пока в
/// него не переключиться. Сервис аккаунта
/// ([AccountScope]); запускается в `startAccountServices`.
class AccountProfileSync implements AccountService {
  AccountProfileSync._();

  static AccountProfileSync get instance => AccountScope.current.resolve(AccountProfileSync._);

  final AccountScope _scope = AccountScope.current;
  StreamSubscription<void>? _subscription;

  void start() {
    _subscription ??= _scope.repositories.db.onChange(const ['myProfile', 'downloads']).listen((_) => unawaited(_sync()));
    unawaited(_sync());
  }

  Future<void> _sync() async {
    try {
      final userID = _scope.auth.session.userID;
      if (userID.isEmpty) return;
      final profile = await _scope.repositories.myProfile.getByUserID(userID: userID);
      final name = [profile.fistName, profile.lastName].where((part) => part.trim().isNotEmpty).join(' ').trim();
      final cdnID = profile.avatarCdnID;
      final avatar = cdnID == null || cdnID.isEmpty ? null : await _scope.cdn.cachedFile(Uint8List.fromList(cdnID));
      final user = await _scope.repositories.users.getBySession(session: _scope.auth.session);
      await _device.accounts.setProfile(
        accountID: _scope.accountID,
        name: name,
        avatarPath: avatar == null ? '' : await _keepAvatar(avatar, getIt.get<Utils>().bytesToHex(Uint8List.fromList(cdnID!))),
        phoneNumber: user.phoneNumber,
      );
    } catch (error, stackTrace) {
      getIt.get<Logger>().handle(error, stackTrace);
    }
  }

  /// Папка копии аватара внутри данных аккаунта.
  static const _avatarDir = 'account_avatar';

  /// Копия [file] (аватар с cdnID [cdnHex]) в [_avatarDir]; прежние копии
  /// удаляются. Возвращает путь относительно папки данных аккаунта.
  Future<String> _keepAvatar(File file, String cdnHex) async {
    final dir = await _scope.dataSubdir(_avatarDir);
    final name = '$cdnHex${p.extension(file.path)}';
    final copy = File(p.join(dir.path, name));
    if (!await copy.exists()) {
      await file.copy('${copy.path}.tmp');
      await File('${copy.path}.tmp').rename(copy.path);
    }
    await for (final entry in dir.list()) {
      if (entry is File && p.basename(entry.path) != name) await entry.delete();
    }
    return p.join(_avatarDir, name);
  }

  @override
  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}
