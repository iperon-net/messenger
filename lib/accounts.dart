import 'dart:async';
import 'dart:typed_data';

import 'account_scope.dart';
import 'di.dart';
import 'logger.dart';
import 'push.dart';
import 'repositories.dart';
import 'api.dart';
import 'protobuf.dart';

/// Несколько аккаунтов на устройстве (docs/plans/multi-account.md, этап 3.2):
/// список вошедших, добавление, переключение и уход из аккаунта. Экраны
/// («Настройки», вход) берут всё отсюда.

/// Сколько аккаунтов можно держать на устройстве (как в Telegram).
const maxAccounts = 3;

/// Вошедший аккаунт для списка: подпись (имя или номер), аватар (путь к
/// файлу, пусто — нет) и активный ли.
typedef AccountEntry = ({String accountID, String title, String avatarPath, bool active});

DeviceRepositories get _device => getIt.get<DeviceRepositories>();

/// Вошедшие аккаунты по порядку слотов.
Future<List<AccountEntry>> signedInAccounts() async {
  final current = AccountScope.current.accountID;
  return [
    for (final slot in await _device.accounts.all())
      if (slot.userID.isNotEmpty)
        (
          accountID: slot.accountID,
          title: slot.name.isNotEmpty ? slot.name : '+${slot.phoneNumber}',
          avatarPath: slot.avatarPath,
          active: slot.accountID == current,
        ),
  ];
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
  if (target != null) await leaveAccount(target);
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
/// Его сессии нет — ничего (звонящий дождётся отмены по таймауту).
Future<void> rejectCallAs(String accountID, {required String callId, required List<int> toUserID}) async {
  if (toUserID.isEmpty) return;
  try {
    final session = await _device.sessionOf(accountID);
    if (session == null) return;
    final ring = CallRing(callId: callId, toUserID: Uint8List.fromList(toUserID));
    await getIt.get<API>().unaryEncodedAs(session, MessageType.CALL_REJECT, ring.writeToBuffer());
  } catch (error, stackTrace) {
    getIt.get<Logger>().handle(error, stackTrace);
  }
}

/// Имя и аватар активного аккаунта — в его слот `device.db`: список аккаунтов
/// показывает и неактивные, чьи базы закрыты. Сервис аккаунта
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
        avatarPath: avatar?.path ?? '',
        phoneNumber: user.phoneNumber,
      );
    } catch (error, stackTrace) {
      getIt.get<Logger>().handle(error, stackTrace);
    }
  }

  @override
  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}
