import 'models.dart' as models;

/// Состояние одного аккаунта в памяти: синглтоны чатов (`ChatsSync`,
/// `ChatsRemoteDataSource`, `ChatsPresence`, …) и мелкие кэши, которые раньше
/// жили в статических полях классов.
///
/// Этап 2 мультиаккаунта (docs/plans/multi-account.md): аккаунт пока один, и
/// [current] не меняется, — поведение прежнее. Дальше (этап 3) у каждого
/// аккаунта будет свой scope, `X.instance` продолжит возвращать сервис
/// активного аккаунта, а фоновые действия (ответ из пуша, звонок) получат
/// scope своего аккаунта явно.
class AccountScope {
  AccountScope._();

  static final AccountScope _current = AccountScope._();

  /// Scope активного аккаунта.
  static AccountScope get current => _current;

  final _services = <Type, Object>{};

  /// Сервис [T] этого аккаунта: создаётся [create] при первом обращении и
  /// дальше один на scope. Классы чатов отдают его как `X.instance`, передавая
  /// свой приватный конструктор.
  T resolve<T extends Object>(T Function() create) => (_services[T] ??= create()) as T;

  /// Пересылка, выбранная в другом чате: окно чата-получателя заберёт её при
  /// открытии (`ChatCubit.forwardTo`).
  final pendingForwards = <String, List<models.Message>>{};

  /// Список заблокированных уже обновлён с сервера в этом запуске
  /// (`PrivacyBlocks.refresh`).
  bool privacyBlocksRefreshed = false;
}
