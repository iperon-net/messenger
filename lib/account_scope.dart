import 'dart:io';

import 'package:flutter/foundation.dart';

import 'api.dart';
import 'auth.dart';
import 'cdn.dart';
import 'di.dart';
import 'models.dart' as models;
import 'repositories.dart';

/// Сервис аккаунта, которому есть что освободить при переключении аккаунта
/// (таймеры, подписки): [AccountScope.dispose] вызывает [dispose].
abstract interface class AccountService {
  Future<void> dispose();
}

/// Состояние одного аккаунта в памяти: синглтоны чатов (`ChatsSync`,
/// `ChatsRemoteDataSource`, `ChatsPresence`, …), мелкие кэши и ссылки на
/// сервисы аккаунта из его scope get_it (docs/plans/multi-account.md, этап 3).
///
/// [current] — активный аккаунт; `X.instance` возвращает сервис активного
/// аккаунта. Сервис, созданный в scope, держит его у себя: после переключения
/// его незавершённые операции остаются со своим аккаунтом.
class AccountScope {
  AccountScope(this.accountID);

  /// Локальный id слота аккаунта (`accounts` в `device.db`).
  final String accountID;

  static AccountScope _current = AccountScope('');

  /// Scope активного аккаунта.
  static AccountScope get current => _current;

  /// Растёт при каждом переключении аккаунта: корень приложения
  /// пересобирается с новым ключом — кубиты и подписки UI заново, уже на новом
  /// аккаунте.
  static final generation = ValueNotifier<int>(0);

  /// Сделать [scope] активным (до регистрации его сервисов в get_it).
  static void activate(AccountScope scope) => _current = scope;

  final _services = <Type, Object>{};

  API? _api;
  Auth? _auth;
  Repositories? _repositories;
  CDNManager? _cdn;

  // Сервисы аккаунта. Пока scope не привязан ([bind]) — из get_it: это время
  // регистрации его же scope, другого там нет.
  API get api => _api ?? getIt.get<API>();
  Auth get auth => _auth ?? getIt.get<Auth>();
  Repositories get repositories => _repositories ?? getIt.get<Repositories>();
  CDNManager get cdn => _cdn ?? getIt.get<CDNManager>();

  /// Запомнить сервисы аккаунта из его scope get_it (после `allReady`).
  void bind() {
    _api = getIt.get<API>();
    _auth = getIt.get<Auth>();
    _repositories = getIt.get<Repositories>();
    _cdn = getIt.get<CDNManager>();
  }

  /// Освободить синглтоны аккаунта ([AccountService]) — при переключении на
  /// другой аккаунт, до закрытия его scope get_it.
  Future<void> dispose() async {
    for (final service in _services.values) {
      if (service is AccountService) await service.dispose();
    }
  }

  /// Сервис [T] этого аккаунта: создаётся [create] при первом обращении и
  /// дальше один на scope. Классы чатов отдают его как `X.instance`, передавая
  /// свой приватный конструктор.
  T resolve<T extends Object>(T Function() create) => (_services[T] ??= create()) as T;

  /// Пересылка, выбранная в другом чате: окно чата-получателя заберёт её при
  /// открытии (`ChatCubit.forwardTo`).
  final pendingForwards = <String, List<models.Message>>{};

  /// Папки аккаунта: `data` — база и неотправленное (`chat_outbox`,
  /// `secret_media`), `cache` — кэш скачанного (`media`). Ставит
  /// `Repositories` при старте.
  ({Directory data, Directory cache})? files;

  /// Каталог [name] в папке данных аккаунта (создаётся).
  Future<Directory> dataSubdir(String name) => _subdir(files?.data, name);

  /// Каталог [name] в кэше аккаунта (создаётся).
  Future<Directory> cacheSubdir(String name) => _subdir(files?.cache, name);

  static Future<Directory> _subdir(Directory? root, String name) async {
    if (root == null) throw StateError('AccountScope: account files are not set yet (Repositories is not ready)');
    final dir = Directory('${root.path}${Platform.pathSeparator}$name');
    await dir.create(recursive: true);
    return dir;
  }

  /// Список заблокированных уже обновлён с сервера в этом запуске
  /// (`PrivacyBlocks.refresh`).
  bool privacyBlocksRefreshed = false;
}
