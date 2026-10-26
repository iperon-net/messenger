import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoPage;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'components.dart';
import 'cubit.dart';
import 'di.dart';
import 'logger.dart';
import 'models.dart' as models;
import 'repositories.dart';
import 'screens.dart';
import 'split_layout.dart';
import 'screens/chats/chat_folders_cupertino.dart' show ChatFoldersCupertino;
import 'screens/chats/chat_folders_material.dart' show ChatFoldersMaterial;
import 'themes.dart' show ThemesCupertino;
import 'auth.dart';
import 'deep_links.dart';
import 'utils.dart';

class Routers {
  final logger = getIt.get<Logger>();
  final repositories = getIt.get<Repositories>();
  final auth = getIt.get<Auth>();

  /// Куда откроется корень следующего аккаунта вместо «Чатов» — один раз
  /// (отмена «Добавить аккаунт» возвращает в «Настройки», откуда добавляли).
  static String? nextLocation;

  final String initialLocation = _takeNextLocation();

  static String _takeNextLocation() {
    final location = nextLocation ?? '/chats';
    nextLocation = null;
    return location;
  }

  // go_router определяет тип Page по типу App-виджета через
  // findAncestorWidgetOfExactType<CupertinoApp>() (из package:flutter).
  // Приложение обёрнуто в CupertinoApp из cupertino_ui — это другой тип,
  // поэтому автоопределение проваливается в NoTransitionPage (без свайпа
  // назад). Поэтому Page отдаём явно: FullSwipeBackPage — iOS-переход, и
  // экран закрывается свайпом вправо с любого места (как в Telegram), а не
  // только от края. [fullSwipe] = false — штатная CupertinoPage (жест только
  // от края): для экранов, где случайный свайп вредит (звонок).
  //
  // [pane] — экран правой панели iPad (см. _chatsCupertino). Ключ страницы — с
  // учётом параметров пути: go_router ключует декларативные страницы по шаблону
  // (`/chats/chat/:id`), и `go` на другой чат переиспользовал бы страницу
  // открытого вместе с его ChatCubit. Чат, выбранный в списке (`go`, см.
  // openFromList), на широком окне встаёт без анимации и без свайпа «назад»:
  // под ним только «Выберите чат».
  Page<void> _page(GoRouterState state, Widget child, {bool fullSwipe = true, bool pane = false, BuildContext? context}) {
    // Ключи `push` уникальны и без того, у `go` — шаблон пути (начинается с «/»).
    final declarative = state.pageKey.value.startsWith('/');
    final key = pane && declarative ? ValueKey<String>('${state.pageKey.value}|${state.uri}') : state.pageKey;
    if (pane && declarative && context != null && SplitLayout.isWide(context)) {
      return NoTransitionPage<void>(key: key, name: state.name ?? state.path, child: child);
    }
    return fullSwipe
        ? FullSwipeBackPage<void>(key: key, name: state.name ?? state.path, child: child)
        : CupertinoPage<void>(key: key, name: state.name ?? state.path, child: child);
  }

  // «Новое» на iPad ([split]) — лист по центру (FormSheetPage): [first] — первый
  // экран (затемняет фон), шаги «участники → название» ложатся поверх такой же
  // карточкой. Иначе — обычный экран.
  Page<void> _sheetOrPage(GoRouterState state, Widget child, {required bool split, bool first = false}) =>
      split ? FormSheetPage<void>(key: state.pageKey, name: state.name ?? state.path, dim: first, child: child) : _page(state, child);

  // Тот же нюанс, что и с _page, но для Material: приложение обёрнуто в
  // MaterialApp из material_ui (не из package:flutter/material). Переход и
  // свайп — как на iOS (так выглядит и Telegram на Android), только короче.
  // [fullSwipe] = false — штатная MaterialPage (системный Android-переход).
  // [pane] — как у _page: экран правой панели планшета.
  Page<void> _pageMaterial(GoRouterState state, Widget child, {bool fullSwipe = true, bool pane = false, BuildContext? context}) {
    final declarative = state.pageKey.value.startsWith('/');
    final key = pane && declarative ? ValueKey<String>('${state.pageKey.value}|${state.uri}') : state.pageKey;
    if (pane && declarative && context != null && SplitLayout.isWide(context)) {
      return NoTransitionPage<void>(key: key, name: state.name ?? state.path, child: child);
    }
    return fullSwipe
        ? FullSwipeBackPage<void>(
            key: key,
            name: state.name ?? state.path,
            transitionDuration: const Duration(milliseconds: 300),
            child: child,
          )
        : MaterialPage<void>(key: key, name: state.name ?? state.path, child: child);
  }

  // «Новое» на планшете — лист по центру, как _sheetOrPage.
  Page<void> _sheetOrPageMaterial(GoRouterState state, Widget child, {required bool split, bool first = false}) => split
      ? FormSheetPage<void>(key: state.pageKey, name: state.name ?? state.path, dim: first, material: true, child: child)
      : _pageMaterial(state, child);

  /// Тип чатов из пути `/settings/notifications/:scope` (имя [NotifyScope]);
  /// неизвестное — личные чаты.
  NotifyScope _notifyScope(String? name) =>
      NotifyScope.values.firstWhere((scope) => scope.name == name, orElse: () => NotifyScope.privateChats);

  String? _redirect(BuildContext context, GoRouterState state) {
    // Ссылка iperon.net/<имя> снаружи — не маршрут: запоминаем, откроет
    // DeepLinkGate (после входа, если ещё не вошли).
    if (DeepLinks.instance.capture(state.uri)) {
      return auth.isAuthorized ? "/chats" : "/auth";
    }

    final isAuthRoute = state.matchedLocation.startsWith("/auth");

    if (!auth.isAuthorized) {
      return isAuthRoute ? null : "/auth";
    }

    return isAuthRoute ? "/chats" : null;
  }

  List<RouteBase> _common(GlobalKey<NavigatorState> rootNavigatorKey, {bool split = false}) => <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>(create: (_) => HomeCubit()..initialization()),
          // Статус соединения общий для всех вкладок — провайдим на уровне
          // shell, чтобы навбары любой вкладки могли его показать.
          BlocProvider<ConnectionCubit>(create: (_) => ConnectionCubit()..initialization()),
          // Контакты живут на уровне shell, чтобы к моменту открытия вкладки
          // список уже был показан из кэша и (при выданном доступе) освежён.
          BlocProvider<ContactsCubit>(create: (_) => ContactsCubit()..bootstrap()),
        ],
        child: CallGate(
          child: DeepLinkGate(child: HomeCupertino(navigationShell: navigationShell)),
        ),
      ),
      branches: [
        StatefulShellBranch(routes: [_contactsCupertino(rootNavigatorKey, split: split)]),
        StatefulShellBranch(routes: [_callsCupertino(split: split)]),
        StatefulShellBranch(routes: [_chatsCupertino(rootNavigatorKey, split: split)]),
        StatefulShellBranch(routes: [_settingsCupertino(rootNavigatorKey, split: split)]),
      ],
    ),
    GoRoute(
      path: "/call",
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => _page(
        state,
        BlocProvider<CallCubit>(create: (_) => CallCubit()..initialization(), child: const CallCupertino()),
        fullSwipe: false,
      ),
    ),
    _profileCupertino("/profile/:userID", rootNavigatorKey),
    GoRoute(
      path: "/auth",
      builder: (_, _) => BlocProvider<AuthCubit>(create: (_) => AuthCubit()..initialization(), child: AuthCupertinoScreen()),
      routes: [
        GoRoute(
          path: "/call_password_confirmation",
          pageBuilder: (context, state) {
            final callPasswordSession = state.uri.queryParameters["callPasswordSession"] ?? "";
            final confirmationPhoneNumber = state.uri.queryParameters["confirmationPhoneNumber"] ?? "";
            final timeout = state.uri.queryParameters["timeout"] ?? "";

            if (callPasswordSession.isEmpty || confirmationPhoneNumber.isEmpty || timeout.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) context.go("/auth");
              });
              return _page(state, Container());
            }

            return _page(
              state,
              BlocProvider<AuthCallpasswordConfirmationCubit>(
                create: (_) => AuthCallpasswordConfirmationCubit()
                  ..initialization(
                    callPasswordSession: callPasswordSession,
                    confirmationPhoneNumber: confirmationPhoneNumber,
                    timeout: timeout,
                  ),
                child: AuthCallpasswordConfirmationCupertino(),
              ),
            );
          },
        ),
        GoRoute(
          path: "/moderation_application_store",
          pageBuilder: (context, state) {
            final moderationApplicationStoreSession = state.uri.queryParameters["moderationApplicationStoreSession"] ?? "";
            final phoneNumber = state.uri.queryParameters["phoneNumber"] ?? "";

            if (moderationApplicationStoreSession.isEmpty || phoneNumber.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) context.go("/auth");
              });
              return _page(state, Container());
            }

            return _page(
              state,
              BlocProvider<AuthModerationApplicationStoreCubit>(
                create: (_) =>
                    AuthModerationApplicationStoreCubit()
                      ..initialization(phoneNumber: phoneNumber, moderationApplicationStoreSession: moderationApplicationStoreSession),
                child: AuthModerationApplicationStoreCupertino(),
              ),
            );
          },
        ),
        GoRoute(
          path: "/cloud_password",
          pageBuilder: (context, state) {
            final confirmationSession = state.uri.queryParameters["confirmationSession"] ?? "";

            if (confirmationSession.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) context.go("/auth");
              });
              return _page(state, Container());
            }

            return _page(
              state,
              BlocProvider<AuthCloudPasswordCubit>(
                create: (_) => AuthCloudPasswordCubit()..initialization(confirmationSession: confirmationSession),
                child: AuthCloudPasswordCupertino(),
              ),
            );
          },
        ),
      ],
    ),
  ];

  // Профиль человека (ProfileCupertino) и его «Скрыть профиль». Корневой
  // маршрут `/profile/:userID` — на корневом навигаторе; на iPad ещё и
  // `/<вкладка>/user/:userID` — в правой панели своей вкладки ([parent] = null;
  // [pane] — корень панели: из списка контактов / звонков), см. profileRoute.
  GoRoute _profileCupertino(String path, GlobalKey<NavigatorState>? parent, {bool pane = false}) => GoRoute(
    path: path,
    parentNavigatorKey: parent,
    pageBuilder: (context, state) => _page(
      state,
      BlocProvider<ProfileCubit>(
        create: (_) => ProfileCubit()
          ..initialization(
            userID: getIt.get<Utils>().hexToBytes(state.pathParameters['userID'] ?? ''),
            locale: context.read<CommonCubit>().state.settingsDevice.locale ?? AppLocale.en,
            demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo,
          ),
        child: const ProfileCupertino(),
      ),
      pane: pane,
      context: context,
    ),
    routes: [
      GoRoute(
        path: "hide",
        parentNavigatorKey: parent,
        pageBuilder: (context, state) => _page(
          state,
          BlocProvider<ProfileHideCubit>(
            create: (_) => ProfileHideCubit(userID: getIt.get<Utils>().hexToBytes(state.pathParameters['userID'] ?? ''))..initialization(),
            child: const ProfileHideCupertino(),
          ),
        ),
      ),
    ],
  );

  /// Что подсветить в списке вкладки [tab] на iPad по пути панели: userID после
  /// `user/` (контакты, звонки) или раздел (`/settings/<раздел>`).
  static String _splitSelected(String location, String tab) {
    final segments = Uri.parse(location).pathSegments;
    if (segments.length < 2 || segments[0] != tab) return '';
    if (segments[1] == 'user' && tab != 'settings') return segments.length > 2 ? segments[2] : '';
    return tab == 'settings' ? segments[1] : '';
  }

  // Вкладка «Контакты» (iOS). [split] (iPad): список слева, профиль контакта и
  // «Добавить» — в правой панели, см. _chatsCupertino.
  RouteBase _contactsCupertino(GlobalKey<NavigatorState> rootNavigatorKey, {required bool split}) {
    final contacts = GoRoute(
      path: "/contacts",
      builder: (context, _) =>
          split && SplitLayout.isWide(context) ? SplitEmptyCupertino(text: context.t.split.selectContact) : const ContactsCupertino(),
      routes: [
        GoRoute(
          path: "add",
          parentNavigatorKey: split ? null : rootNavigatorKey,
          pageBuilder: (context, state) => _page(state, const ContactsAddCupertino(), pane: split, context: context),
        ),
        if (split) _profileCupertino("user/:userID", null, pane: true),
      ],
    );
    if (!split) return contacts;
    return ShellRoute(
      builder: (context, state, child) =>
          SplitViewCupertino(list: const ContactsCupertino(), selected: _splitSelected(state.uri.path, 'contacts'), child: child),
      routes: [contacts],
    );
  }

  // Вкладка «Звонки» (iOS). [split] (iPad): журнал слева, профиль собеседника
  // справа, см. _chatsCupertino.
  RouteBase _callsCupertino({required bool split}) {
    final calls = GoRoute(
      path: "/calls",
      builder: (context, _) => split
          ? (SplitLayout.isWide(context) ? SplitEmptyCupertino(text: context.t.split.selectCall) : const CallsCupertino())
          : BlocProvider<CallsCubit>(create: (_) => CallsCubit()..initialization(), child: const CallsCupertino()),
      routes: [if (split) _profileCupertino("user/:userID", null, pane: true)],
    );
    if (!split) return calls;
    return ShellRoute(
      builder: (context, state, child) => BlocProvider<CallsCubit>(
        create: (_) => CallsCubit()..initialization(),
        child: SplitViewCupertino(list: const CallsCupertino(), selected: _splitSelected(state.uri.path, 'calls'), child: child),
      ),
      routes: [calls],
    );
  }

  // Вкладка «Настройки» (iOS). [split] (iPad): список разделов слева, раздел —
  // в правой панели (навигатор ShellRoute), см. _chatsCupertino.
  RouteBase _settingsCupertino(GlobalKey<NavigatorState> rootNavigatorKey, {required bool split}) {
    final pane = split ? null : rootNavigatorKey;
    final settings = GoRoute(
      path: "/settings",
      // Сплит: SettingsCubit выше, у списка слева; корень панели — заглушка.
      builder: (context, _) => split
          ? (SplitLayout.isWide(context)
                ? SplitEmptyCupertino(text: context.t.split.selectSection, background: ThemesCupertino.groupedBackground)
                : const SettingsCupertino())
          : BlocProvider<SettingsCubit>(create: (_) => SettingsCubit()..initialization(), child: const SettingsCupertino()),
      routes: [
        // Вложенные пути (/settings/language, /settings/appearance),
        // но parentNavigatorKey отправляет их на корневой навигатор —
        // экран открывается на весь экран, без нижнего таб-бара. На iPad
        // (split) — в правую панель.
        // iPad: профиль из «Заблокированных» — в правой панели.
        if (split) _profileCupertino("user/:userID", null),
        if (split)
          GoRoute(
            path: "folders",
            pageBuilder: (context, state) => _page(
              state,
              BlocProvider(
                create: (_) => ChatFoldersCubit()..initialization(demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo),
                child: const ChatFoldersCupertino(),
              ),
              pane: split,
              context: context,
            ),
          ),

        GoRoute(
          path: "profile",
          parentNavigatorKey: pane,
          pageBuilder: (context, state) => _page(
            state,
            BlocProvider<SettingsMyProfileCubit>(
              create: (_) =>
                  SettingsMyProfileCubit()..initialization(locale: context.read<CommonCubit>().state.settingsDevice.locale ?? AppLocale.en),
              child: SettingsMyProfileCupertino(),
            ),
            pane: split,
            context: context,
          ),
          routes: [
            GoRoute(
              path: "edit",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _page(
                state,
                BlocProvider<SettingsMyProfileEditCubit>(
                  create: (_) =>
                      SettingsMyProfileEditCubit()
                        ..initialization(locale: context.read<CommonCubit>().state.settingsDevice.locale ?? AppLocale.en),
                  child: SettingsMyProfileEditCupertino(),
                ),
              ),
            ),
            GoRoute(
              path: "username",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _page(
                state,
                BlocProvider<SettingsMyProfileUsernameCubit>(
                  create: (_) =>
                      SettingsMyProfileUsernameCubit()
                        ..initialization(locale: context.read<CommonCubit>().state.settingsDevice.locale ?? AppLocale.en),
                  child: SettingsMyProfileUsernameCupertino(),
                ),
              ),
            ),
          ],
        ),
        GoRoute(
          path: "notifications",
          parentNavigatorKey: pane,
          pageBuilder: (context, state) => _page(
            state,
            BlocProvider<SettingsNotificationsCubit>(
              create: (_) => SettingsNotificationsCubit()..initialization(),
              child: const SettingsNotificationsCupertino(),
            ),
            pane: split,
            context: context,
          ),
          routes: [
            GoRoute(
              path: ":scope",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _page(
                state,
                BlocProvider<SettingsNotificationsCubit>(
                  create: (_) => SettingsNotificationsCubit()..initialization(),
                  child: SettingsNotificationsScopeCupertino(scope: _notifyScope(state.pathParameters["scope"])),
                ),
              ),
            ),
          ],
        ),
        GoRoute(
          path: "privacy_and_security",
          parentNavigatorKey: pane,
          pageBuilder: (context, state) => _page(
            state,
            BlocProvider<SettingsPrivacyAndSecurityCubit>(
              create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
              child: SettingsPrivacyAndSecurityCupertino(),
            ),
            pane: split,
            context: context,
          ),
          routes: [
            // «Заблокированные»: блокируют из профиля, здесь — список и «Разблокировать».
            GoRoute(
              path: "blocked",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _page(
                state,
                BlocProvider<SettingsBlockedCubit>(
                  create: (_) => SettingsBlockedCubit()..initialization(),
                  child: const SettingsBlockedCupertino(),
                ),
              ),
            ),
            GoRoute(
              path: "calls",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _page(
                state,
                BlocProvider<SettingsPrivacyAndSecurityCubit>(
                  create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
                  child: const SettingsPrivacyCallsCupertino(),
                ),
              ),
              routes: [
                GoRoute(
                  path: "allow",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowCupertino(
                        kind: CallsListKind.allow,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
                GoRoute(
                  path: "deny",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowCupertino(
                        kind: CallsListKind.deny,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: "birthday",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _page(
                state,
                BlocProvider<SettingsPrivacyAndSecurityCubit>(
                  create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
                  child: const SettingsPrivacyBirthdayCupertino(),
                ),
              ),
              routes: [
                GoRoute(
                  path: "allow",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowCupertino(
                        kind: CallsListKind.allow,
                        channel: PrivacyChannel.birthday,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
                GoRoute(
                  path: "deny",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowCupertino(
                        kind: CallsListKind.deny,
                        channel: PrivacyChannel.birthday,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: "about_me",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _page(
                state,
                BlocProvider<SettingsPrivacyAndSecurityCubit>(
                  create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
                  child: const SettingsPrivacyAboutMeCupertino(),
                ),
              ),
              routes: [
                GoRoute(
                  path: "allow",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowCupertino(
                        kind: CallsListKind.allow,
                        channel: PrivacyChannel.aboutMe,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
                GoRoute(
                  path: "deny",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowCupertino(
                        kind: CallsListKind.deny,
                        channel: PrivacyChannel.aboutMe,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: "last_seen",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _page(
                state,
                BlocProvider<SettingsPrivacyAndSecurityCubit>(
                  create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
                  child: const SettingsPrivacyLastSeenCupertino(),
                ),
              ),
              routes: [
                GoRoute(
                  path: "allow",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowCupertino(
                        kind: CallsListKind.allow,
                        channel: PrivacyChannel.lastSeen,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
                GoRoute(
                  path: "deny",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowCupertino(
                        kind: CallsListKind.deny,
                        channel: PrivacyChannel.lastSeen,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: "messages",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _page(
                state,
                BlocProvider<SettingsPrivacyAndSecurityCubit>(
                  create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
                  child: const SettingsPrivacyMessagesCupertino(),
                ),
              ),
              routes: [
                GoRoute(
                  path: "allow",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowCupertino(
                        kind: CallsListKind.allow,
                        channel: PrivacyChannel.messages,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
                GoRoute(
                  path: "deny",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowCupertino(
                        kind: CallsListKind.deny,
                        channel: PrivacyChannel.messages,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: "forwards",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _page(
                state,
                BlocProvider<SettingsPrivacyAndSecurityCubit>(
                  create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
                  child: const SettingsPrivacyForwardsCupertino(),
                ),
              ),
              routes: [
                GoRoute(
                  path: "allow",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowCupertino(
                        kind: CallsListKind.allow,
                        channel: PrivacyChannel.forwards,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
                GoRoute(
                  path: "deny",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowCupertino(
                        kind: CallsListKind.deny,
                        channel: PrivacyChannel.forwards,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: "group_invites",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _page(
                state,
                BlocProvider<SettingsPrivacyAndSecurityCubit>(
                  create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
                  child: const SettingsPrivacyGroupInvitesCupertino(),
                ),
              ),
              routes: [
                GoRoute(
                  path: "allow",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowCupertino(
                        kind: CallsListKind.allow,
                        channel: PrivacyChannel.groupInvites,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
                GoRoute(
                  path: "deny",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowCupertino(
                        kind: CallsListKind.deny,
                        channel: PrivacyChannel.groupInvites,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: "phone_number",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _page(
                state,
                BlocProvider<SettingsPrivacyAndSecurityCubit>(
                  create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
                  child: const SettingsPrivacyPhoneNumberCupertino(),
                ),
              ),
              routes: [
                GoRoute(
                  path: "allow",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowCupertino(
                        kind: CallsListKind.allow,
                        channel: PrivacyChannel.phoneNumber,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
                GoRoute(
                  path: "deny",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowCupertino(
                        kind: CallsListKind.deny,
                        channel: PrivacyChannel.phoneNumber,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: "passcode",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _page(
                state,
                BlocProvider<SettingsPasscodeCubit>(
                  create: (_) => SettingsPasscodeCubit()..initialization(),
                  child: SettingsPasscodeCupertino(),
                ),
              ),
              routes: [
                GoRoute(
                  path: "create",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<SettingsPasscodeCreateCubit>(
                      create: (_) => SettingsPasscodeCreateCubit()..initialization(),
                      child: SettingsPasscodeCreateCupertino(),
                    ),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: "cloud_password",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _page(
                state,
                BlocProvider<SettingsCloudPasswordCubit>(
                  create: (_) => SettingsCloudPasswordCubit()..initialization(),
                  child: SettingsCloudPasswordCupertino(),
                ),
              ),
            ),
            GoRoute(
              path: "passkeys",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _page(
                state,
                BlocProvider<SettingsPasskeysCubit>(
                  create: (_) => SettingsPasskeysCubit()..initialization(),
                  child: SettingsPasskeysCupertino(),
                ),
              ),
            ),
          ],
        ),
        GoRoute(
          // Скрытый раздел «Разработчик» (открывается 5 тапами по вкладке
          // «Настройки», см. HomeCupertino). Логи теперь живут здесь.
          path: "developer",
          parentNavigatorKey: pane,
          pageBuilder: (context, state) => _page(state, const SettingsDeveloperCupertino(), pane: split, context: context),
          routes: [
            GoRoute(
              path: "logs",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _page(state, TalkerScreen(talker: logger.talker)),
            ),
            // DEBUG-only превью экрана звонка без реального звонка.
            if (kDebugMode)
              GoRoute(path: "call_preview", parentNavigatorKey: pane, pageBuilder: (context, state) => _page(state, const CallPreview())),
          ],
        ),
        // «Данные и память»: использование памяти и трафика.
        GoRoute(
          path: "data",
          parentNavigatorKey: pane,
          pageBuilder: (context, state) => _page(state, const SettingsDataCupertino(), pane: split, context: context),
          routes: [
            GoRoute(
              path: "storage",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _page(
                state,
                BlocProvider<SettingsStorageCubit>(
                  create: (_) => SettingsStorageCubit()..initialization(),
                  child: const SettingsStorageCupertino(),
                ),
              ),
            ),
            GoRoute(
              path: "network",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _page(
                state,
                BlocProvider<SettingsNetworkCubit>(
                  create: (_) => SettingsNetworkCubit()..initialization(),
                  child: const SettingsNetworkCupertino(),
                ),
              ),
            ),
          ],
        ),
        GoRoute(
          path: "language",
          parentNavigatorKey: pane,
          pageBuilder: (context, state) => _page(
            state,
            BlocProvider<SettingsLanguageCubit>(
              create: (_) => SettingsLanguageCubit()..initialization(locale: context.read<CommonCubit>().state.settingsDevice.locale),
              child: SettingsLanguageCupertinoScreen(),
            ),
            pane: split,
            context: context,
          ),
        ),
        GoRoute(
          path: "appearance",
          parentNavigatorKey: pane,
          pageBuilder: (context, state) => _page(
            state,
            BlocProvider<SettingsAppearanceCubit>(
              create: (_) => SettingsAppearanceCubit()
                ..initialization(
                  colorTheme: context.read<CommonCubit>().state.settingsDevice.colorTheme,
                  darkMode: context.read<CommonCubit>().state.settingsDevice.darkMode,
                  isBlurOnInactive: context.read<CommonCubit>().state.settingsDevice.isBlurOnInactive,
                ),
              child: SettingsAppearanceCupertino(),
            ),
            pane: split,
            context: context,
          ),
          routes: [
            // Темы для чатов — обои окна чата.
            GoRoute(
              path: "chat_themes",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _page(state, const SettingsChatThemesCupertino()),
            ),
          ],
        ),
        GoRoute(
          path: "device_sessions",
          parentNavigatorKey: pane,
          pageBuilder: (context, state) => _page(
            state,
            BlocProvider<SettingsDeviceSessionsCubit>(
              create: (_) => SettingsDeviceSessionsCubit()..initialization(),
              child: SettingsDeviceSessionsCupertino(),
            ),
            pane: split,
            context: context,
          ),
        ),
      ],
    );
    if (!split) return settings;
    return ShellRoute(
      builder: (context, state, child) => BlocProvider<SettingsCubit>(
        create: (_) => SettingsCubit()..initialization(),
        child: SplitViewCupertino(list: const SettingsCupertino(), selected: _splitSelected(state.uri.path, 'settings'), child: child),
      ),
      routes: [settings],
    );
  }

  // Вкладка «Чаты» (iOS). [split] (iPad, см. SplitLayout): список и окно чата
  // рядом — экраны чата открываются не на корневом навигаторе, а в правой
  // панели (навигатор ShellRoute у ChatsSplitCupertino); на узком окне
  // (Slide Over, Split View) панель одна, как на iPhone, но с таб-баром.
  RouteBase _chatsCupertino(GlobalKey<NavigatorState> rootNavigatorKey, {required bool split}) {
    final pane = split ? null : rootNavigatorKey;
    // «Новое». На iPad — листом по центру (FormSheetPage), шаги — листом поверх.
    final newChat = GoRoute(
      path: "new",
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => _sheetOrPage(
        state,
        BlocProvider<ChatCreateCubit>(
          create: (context) => ChatCreateCubit()..initialization(demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo),
          child: const ChatsNewCupertino(),
        ),
        split: split,
        first: true,
      ),
      routes: [
        GoRoute(
          path: "group",
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) => _sheetOrPage(
            state,
            BlocProvider<ChatCreateCubit>(
              create: (context) =>
                  ChatCreateCubit()
                    ..initialization(demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo, type: models.ChatType.group),
              child: const ChatCreateMembersCupertino(),
            ),
            split: split,
          ),
          routes: [
            GoRoute(
              path: "info",
              parentNavigatorKey: rootNavigatorKey,
              pageBuilder: (context, state) => _sheetOrPage(
                state,
                BlocProvider<ChatCreateCubit>(
                  create: (context) => ChatCreateCubit()
                    ..initialization(
                      demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo,
                      type: models.ChatType.group,
                      selected: state.extra is List<models.ChatMember> ? state.extra! as List<models.ChatMember> : const [],
                      // Группа внутри сообщества — сразу сюда, без выбора участников.
                      communityID: state.uri.queryParameters['community'] ?? '',
                    ),
                  child: const ChatCreateFormCupertino(),
                ),
                split: split,
              ),
            ),
          ],
        ),
        // Канал (срез 4.1): «Добавить подписчиков» → форма
        // (`info`); канал внутри сообщества — сразу форма.
        GoRoute(
          path: "channel",
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) {
            final communityID = state.uri.queryParameters['community'] ?? '';
            return _sheetOrPage(
              state,
              BlocProvider<ChatCreateCubit>(
                create: (context) => ChatCreateCubit()
                  ..initialization(
                    demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo,
                    type: models.ChatType.channel,
                    communityID: communityID,
                  ),
                child: communityID.isEmpty ? const ChatCreateMembersCupertino() : const ChatCreateFormCupertino(),
              ),
              split: split,
            );
          },
          routes: [
            GoRoute(
              path: "info",
              parentNavigatorKey: rootNavigatorKey,
              pageBuilder: (context, state) => _sheetOrPage(
                state,
                BlocProvider<ChatCreateCubit>(
                  create: (context) => ChatCreateCubit()
                    ..initialization(
                      demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo,
                      type: models.ChatType.channel,
                      selected: state.extra is List<models.ChatMember> ? state.extra! as List<models.ChatMember> : const [],
                    ),
                  child: const ChatCreateFormCupertino(),
                ),
                split: split,
              ),
            ),
          ],
        ),
        GoRoute(
          path: "community",
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) => _sheetOrPage(
            state,
            BlocProvider<ChatCreateCubit>(
              create: (context) =>
                  ChatCreateCubit()
                    ..initialization(demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo, type: models.ChatType.community),
              child: const ChatCreateFormCupertino(),
            ),
            split: split,
          ),
        ),
      ],
    );
    final chats = GoRoute(
      path: "/chats",
      // Сплит: ChatsCubit выше, у ChatsSplitCupertino; на широком окне слева уже
      // есть список, а корень правой панели — заглушка «Выберите чат».
      builder: (context, _) => split
          ? (SplitLayout.isWide(context) ? SplitEmptyCupertino(text: context.t.split.selectChat) : const ChatsCupertino())
          : BlocProvider<ChatsCubit>(
              create: (context) => ChatsCubit()..initialization(demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo),
              child: const ChatsCupertino(),
            ),
      routes: [
        // iPad: профиль человека (участник, упоминание) — в правой панели.
        if (split) _profileCupertino("user/:userID", null),
        // «Архив» — полноэкранно поверх таб-бара. Свой ChatsCubit: данные
        // общие через источник (демо / ChatsRemoteDataSource — один на приложение).
        GoRoute(
          path: "archive",
          parentNavigatorKey: pane,
          pageBuilder: (context, state) => _page(
            state,
            BlocProvider<ChatsCubit>(
              create: (context) =>
                  ChatsCubit()..initialization(demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo, archive: true),
              child: const ChatsArchiveCupertino(),
            ),
            pane: split,
            context: context,
          ),
        ),
        // Окно чата — полноэкранно поверх таб-бара (и из списка, и из «Архива»).
        GoRoute(
          path: "chat/:id",
          parentNavigatorKey: pane,
          pageBuilder: (context, state) => _page(
            state,
            BlocProvider<ChatCubit>(
              create: (context) => ChatCubit()
                ..initialization(
                  chatID: state.pathParameters['id']!,
                  demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo,
                  // ?message=<id> — прокрутить к сообщению (пост из «Переслано из»).
                  focusMessageID: state.uri.queryParameters['message'] ?? '',
                ),
              child: const ChatScreenCupertino(),
            ),
            pane: split,
            context: context,
          ),
        ),
        // Комментарии к посту канала по ссылке (тап по пушу ответа в ветке):
        // открывает ветку и заменяется её окном чата.
        GoRoute(
          path: "comments/:channelID/:postID",
          parentNavigatorKey: pane,
          pageBuilder: (context, state) => _page(
            state,
            ChatCommentsOpenCupertino(
              channelID: state.pathParameters['channelID']!,
              postID: state.pathParameters['postID']!,
              // ?message=<id> — прокрутить к комментарию (из «Ответов»).
              messageID: state.uri.queryParameters['message'] ?? '',
            ),
            pane: split,
            context: context,
          ),
        ),
        // «Ответы» (4.6): ответы на мои комментарии и упоминания меня
        // в ветках комментариев — только чтение.
        GoRoute(
          path: "replies",
          parentNavigatorKey: pane,
          pageBuilder: (context, state) => _page(
            state,
            BlocProvider<RepliesCubit>(create: (context) => RepliesCubit()..initialization(), child: const RepliesCupertino()),
            pane: split,
            context: context,
          ),
        ),
        // Секретный чат (E2EE, только на этом устройстве) и его «Ключ
        // шифрования» — у каждого экрана свой SecretChatCubit.
        GoRoute(
          path: "secret/:id",
          parentNavigatorKey: pane,
          pageBuilder: (context, state) => _page(
            state,
            BlocProvider<SecretChatCubit>(
              create: (context) => SecretChatCubit()..initialization(chatID: state.pathParameters['id']!),
              child: const SecretChatCupertino(),
            ),
            pane: split,
            context: context,
          ),
          routes: [
            GoRoute(
              path: "info",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _page(
                state,
                BlocProvider<SecretChatCubit>(
                  create: (context) => SecretChatCubit()..initialization(chatID: state.pathParameters['id']!, markRead: false),
                  child: const SecretChatInfoCupertino(),
                ),
              ),
            ),
          ],
        ),
        // «Новое»: «Новое сообщение» (контакты) → личный чат, или
        // группа (участники → название), канал, сообщество. Свой
        // ChatCreateCubit на каждом экране: участники группы
        // передаются на шаг названия через `extra`.
        newChat,
      ],
    );
    if (!split) return chats;
    return ShellRoute(
      builder: (context, state, child) => BlocProvider<ChatsCubit>(
        create: (context) => ChatsCubit()..initialization(demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo),
        child: ChatsSplitCupertino(location: state.uri.path, child: child),
      ),
      routes: [chats],
    );
  }

  List<RouteBase> get _cupertino => <RouteBase>[];

  // Material-аналог _common: тот же StatefulShellRoute с нижней навигацией, но
  // рендерит Material-экраны. Портированы все вкладки и вся ветка /auth.
  // Профиль человека (Android), как _profileCupertino.
  GoRoute _profileMaterial(String path, GlobalKey<NavigatorState>? parent, {bool pane = false}) => GoRoute(
    path: path,
    parentNavigatorKey: parent,
    pageBuilder: (context, state) => _pageMaterial(
      state,
      BlocProvider<ProfileCubit>(
        create: (_) => ProfileCubit()
          ..initialization(
            userID: getIt.get<Utils>().hexToBytes(state.pathParameters['userID'] ?? ''),
            locale: context.read<CommonCubit>().state.settingsDevice.locale ?? AppLocale.en,
            demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo,
          ),
        child: const ProfileMaterial(),
      ),
      pane: pane,
      context: context,
    ),
    routes: [
      GoRoute(
        path: "hide",
        parentNavigatorKey: parent,
        pageBuilder: (context, state) => _pageMaterial(
          state,
          BlocProvider<ProfileHideCubit>(
            create: (_) => ProfileHideCubit(userID: getIt.get<Utils>().hexToBytes(state.pathParameters['userID'] ?? ''))..initialization(),
            child: const ProfileHideMaterial(),
          ),
        ),
      ),
    ],
  );

  // Вкладка «Контакты» (Android), как _contactsCupertino.
  RouteBase _contactsMaterial(GlobalKey<NavigatorState> rootNavigatorKey, {required bool split}) {
    final contacts = GoRoute(
      path: "/contacts",
      builder: (context, _) =>
          split && SplitLayout.isWide(context) ? SplitEmptyMaterial(text: context.t.split.selectContact) : const ContactsMaterial(),
      routes: [
        GoRoute(
          path: "add",
          parentNavigatorKey: split ? null : rootNavigatorKey,
          pageBuilder: (context, state) => _pageMaterial(state, const ContactsAddMaterial(), pane: split, context: context),
        ),
        if (split) _profileMaterial("user/:userID", null, pane: true),
      ],
    );
    if (!split) return contacts;
    return ShellRoute(
      builder: (context, state, child) =>
          SplitViewMaterial(list: const ContactsMaterial(), selected: _splitSelected(state.uri.path, 'contacts'), child: child),
      routes: [contacts],
    );
  }

  // Вкладка «Звонки» (Android), как _callsCupertino.
  RouteBase _callsMaterial({required bool split}) {
    final calls = GoRoute(
      path: "/calls",
      builder: (context, _) => split
          ? (SplitLayout.isWide(context) ? SplitEmptyMaterial(text: context.t.split.selectCall) : const CallsMaterial())
          : BlocProvider<CallsCubit>(create: (_) => CallsCubit()..initialization(), child: const CallsMaterial()),
      routes: [if (split) _profileMaterial("user/:userID", null, pane: true)],
    );
    if (!split) return calls;
    return ShellRoute(
      builder: (context, state, child) => BlocProvider<CallsCubit>(
        create: (_) => CallsCubit()..initialization(),
        child: SplitViewMaterial(list: const CallsMaterial(), selected: _splitSelected(state.uri.path, 'calls'), child: child),
      ),
      routes: [calls],
    );
  }

  // Вкладка «Чаты» (Android). [split] (планшет, см. SplitLayout) — как у
  // _chatsCupertino: список слева, экраны чата в правой панели.
  RouteBase _chatsMaterial(GlobalKey<NavigatorState> rootNavigatorKey, {required bool split}) {
    final pane = split ? null : rootNavigatorKey;
    final chats = GoRoute(
      path: "/chats",
      // Сплит: ChatsCubit выше, у ChatsSplitMaterial; на широком окне корень
      // правой панели — заглушка «Выберите чат».
      builder: (context, _) => split
          ? (SplitLayout.isWide(context) ? SplitEmptyMaterial(text: context.t.split.selectChat) : const ChatsMaterial())
          : BlocProvider<ChatsCubit>(
              create: (context) => ChatsCubit()..initialization(demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo),
              child: const ChatsMaterial(),
            ),
      routes: [
        // Планшет: профиль человека (участник, упоминание) — в правой панели.
        if (split) _profileMaterial("user/:userID", null),
        // «Архив» — полноэкранно поверх таб-бара. Свой ChatsCubit: данные
        // общие через источник (демо / ChatsRemoteDataSource — один на приложение).
        GoRoute(
          path: "archive",
          parentNavigatorKey: pane,
          pageBuilder: (context, state) => _pageMaterial(
            state,
            BlocProvider<ChatsCubit>(
              create: (context) =>
                  ChatsCubit()..initialization(demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo, archive: true),
              child: const ChatsArchiveMaterial(),
            ),
            pane: split,
            context: context,
          ),
        ),
        // Окно чата — полноэкранно поверх таб-бара (и из списка, и из «Архива»).
        GoRoute(
          path: "chat/:id",
          parentNavigatorKey: pane,
          pageBuilder: (context, state) => _pageMaterial(
            state,
            BlocProvider<ChatCubit>(
              create: (context) => ChatCubit()
                ..initialization(
                  chatID: state.pathParameters['id']!,
                  demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo,
                  // ?message=<id> — прокрутить к сообщению (пост из «Переслано из»).
                  focusMessageID: state.uri.queryParameters['message'] ?? '',
                ),
              child: const ChatScreenMaterial(),
            ),
            pane: split,
            context: context,
          ),
        ),
        // Комментарии к посту канала по ссылке (тап по пушу ответа в ветке):
        // открывает ветку и заменяется её окном чата.
        GoRoute(
          path: "comments/:channelID/:postID",
          parentNavigatorKey: pane,
          pageBuilder: (context, state) => _pageMaterial(
            state,
            ChatCommentsOpenMaterial(
              channelID: state.pathParameters['channelID']!,
              postID: state.pathParameters['postID']!,
              // ?message=<id> — прокрутить к комментарию (из «Ответов»).
              messageID: state.uri.queryParameters['message'] ?? '',
            ),
            pane: split,
            context: context,
          ),
        ),
        // «Ответы» (4.6): ответы на мои комментарии и упоминания меня
        // в ветках комментариев — только чтение.
        GoRoute(
          path: "replies",
          parentNavigatorKey: pane,
          pageBuilder: (context, state) => _pageMaterial(
            state,
            BlocProvider<RepliesCubit>(create: (context) => RepliesCubit()..initialization(), child: const RepliesMaterial()),
            pane: split,
            context: context,
          ),
        ),
        // Секретный чат (E2EE, только на этом устройстве) и его «Ключ
        // шифрования» — у каждого экрана свой SecretChatCubit.
        GoRoute(
          path: "secret/:id",
          parentNavigatorKey: pane,
          pageBuilder: (context, state) => _pageMaterial(
            state,
            BlocProvider<SecretChatCubit>(
              create: (context) => SecretChatCubit()..initialization(chatID: state.pathParameters['id']!),
              child: const SecretChatMaterial(),
            ),
            pane: split,
            context: context,
          ),
          routes: [
            GoRoute(
              path: "info",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _pageMaterial(
                state,
                BlocProvider<SecretChatCubit>(
                  create: (context) => SecretChatCubit()..initialization(chatID: state.pathParameters['id']!, markRead: false),
                  child: const SecretChatInfoMaterial(),
                ),
              ),
            ),
          ],
        ),
        // «Новое»: «Новое сообщение» (контакты) → личный чат, или
        // группа (участники → название), канал, сообщество. Свой
        // ChatCreateCubit на каждом экране: участники группы
        // передаются на шаг названия через `extra`.
        GoRoute(
          path: "new",
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) => _sheetOrPageMaterial(
            state,
            BlocProvider<ChatCreateCubit>(
              create: (context) => ChatCreateCubit()..initialization(demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo),
              child: const ChatsNewMaterial(),
            ),
            split: split,
            first: true,
          ),
          routes: [
            GoRoute(
              path: "group",
              parentNavigatorKey: rootNavigatorKey,
              pageBuilder: (context, state) => _sheetOrPageMaterial(
                state,
                BlocProvider<ChatCreateCubit>(
                  create: (context) =>
                      ChatCreateCubit()
                        ..initialization(demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo, type: models.ChatType.group),
                  child: const ChatCreateMembersMaterial(),
                ),
                split: split,
              ),
              routes: [
                GoRoute(
                  path: "info",
                  parentNavigatorKey: rootNavigatorKey,
                  pageBuilder: (context, state) => _sheetOrPageMaterial(
                    state,
                    BlocProvider<ChatCreateCubit>(
                      create: (context) => ChatCreateCubit()
                        ..initialization(
                          demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo,
                          type: models.ChatType.group,
                          selected: state.extra is List<models.ChatMember> ? state.extra! as List<models.ChatMember> : const [],
                          // Группа внутри сообщества — сразу сюда, без выбора участников.
                          communityID: state.uri.queryParameters['community'] ?? '',
                        ),
                      child: const ChatCreateFormMaterial(),
                    ),
                    split: split,
                  ),
                ),
              ],
            ),
            // Канал (срез 4.1): «Добавить подписчиков» → форма
            // (`info`); канал внутри сообщества — сразу форма.
            GoRoute(
              path: "channel",
              parentNavigatorKey: rootNavigatorKey,
              pageBuilder: (context, state) {
                final communityID = state.uri.queryParameters['community'] ?? '';
                return _sheetOrPageMaterial(
                  state,
                  BlocProvider<ChatCreateCubit>(
                    create: (context) => ChatCreateCubit()
                      ..initialization(
                        demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo,
                        type: models.ChatType.channel,
                        communityID: communityID,
                      ),
                    child: communityID.isEmpty ? const ChatCreateMembersMaterial() : const ChatCreateFormMaterial(),
                  ),
                  split: split,
                );
              },
              routes: [
                GoRoute(
                  path: "info",
                  parentNavigatorKey: rootNavigatorKey,
                  pageBuilder: (context, state) => _sheetOrPageMaterial(
                    state,
                    BlocProvider<ChatCreateCubit>(
                      create: (context) => ChatCreateCubit()
                        ..initialization(
                          demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo,
                          type: models.ChatType.channel,
                          selected: state.extra is List<models.ChatMember> ? state.extra! as List<models.ChatMember> : const [],
                        ),
                      child: const ChatCreateFormMaterial(),
                    ),
                    split: split,
                  ),
                ),
              ],
            ),
            GoRoute(
              path: "community",
              parentNavigatorKey: rootNavigatorKey,
              pageBuilder: (context, state) => _sheetOrPageMaterial(
                state,
                BlocProvider<ChatCreateCubit>(
                  create: (context) =>
                      ChatCreateCubit()
                        ..initialization(demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo, type: models.ChatType.community),
                  child: const ChatCreateFormMaterial(),
                ),
                split: split,
              ),
            ),
          ],
        ),
      ],
    );
    if (!split) return chats;
    return ShellRoute(
      builder: (context, state, child) => BlocProvider<ChatsCubit>(
        create: (context) => ChatsCubit()..initialization(demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo),
        child: ChatsSplitMaterial(location: state.uri.path, child: child),
      ),
      routes: [chats],
    );
  }

  // Вкладка «Настройки» (Android). [split] (планшет): разделы слева, раздел —
  // в правой панели, как _settingsCupertino.
  RouteBase _settingsMaterial(GlobalKey<NavigatorState> rootNavigatorKey, {required bool split}) {
    final pane = split ? null : rootNavigatorKey;
    final settings = GoRoute(
      path: "/settings",
      // Сплит: SettingsCubit выше, у списка слева; корень панели — заглушка.
      builder: (context, _) => split
          ? (SplitLayout.isWide(context) ? SplitEmptyMaterial(text: context.t.split.selectSection) : const SettingsMaterial())
          : BlocProvider<SettingsCubit>(create: (_) => SettingsCubit()..initialization(), child: const SettingsMaterial()),
      routes: [
        // Планшет: профиль из «Заблокированных» и «Папки» — в правой панели.
        if (split) _profileMaterial("user/:userID", null),
        if (split)
          GoRoute(
            path: "folders",
            pageBuilder: (context, state) => _pageMaterial(
              state,
              BlocProvider(
                create: (_) => ChatFoldersCubit()..initialization(demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo),
                child: const ChatFoldersMaterial(),
              ),
              pane: split,
              context: context,
            ),
          ),
        GoRoute(
          path: "profile",
          parentNavigatorKey: pane,
          pageBuilder: (context, state) => _pageMaterial(
            state,
            BlocProvider<SettingsMyProfileCubit>(
              create: (_) =>
                  SettingsMyProfileCubit()..initialization(locale: context.read<CommonCubit>().state.settingsDevice.locale ?? AppLocale.en),
              child: const SettingsMyProfileMaterial(),
            ),
            pane: split,
            context: context,
          ),
          routes: [
            GoRoute(
              path: "edit",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _pageMaterial(
                state,
                BlocProvider<SettingsMyProfileEditCubit>(
                  create: (_) =>
                      SettingsMyProfileEditCubit()
                        ..initialization(locale: context.read<CommonCubit>().state.settingsDevice.locale ?? AppLocale.en),
                  child: const SettingsMyProfileEditMaterial(),
                ),
              ),
            ),
            GoRoute(
              path: "username",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _pageMaterial(
                state,
                BlocProvider<SettingsMyProfileUsernameCubit>(
                  create: (_) =>
                      SettingsMyProfileUsernameCubit()
                        ..initialization(locale: context.read<CommonCubit>().state.settingsDevice.locale ?? AppLocale.en),
                  child: const SettingsMyProfileUsernameMaterial(),
                ),
              ),
            ),
          ],
        ),
        GoRoute(
          path: "notifications",
          parentNavigatorKey: pane,
          pageBuilder: (context, state) => _pageMaterial(
            state,
            BlocProvider<SettingsNotificationsCubit>(
              create: (_) => SettingsNotificationsCubit()..initialization(),
              child: const SettingsNotificationsMaterial(),
            ),
            pane: split,
            context: context,
          ),
          routes: [
            GoRoute(
              path: ":scope",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _pageMaterial(
                state,
                BlocProvider<SettingsNotificationsCubit>(
                  create: (_) => SettingsNotificationsCubit()..initialization(),
                  child: SettingsNotificationsScopeMaterial(scope: _notifyScope(state.pathParameters["scope"])),
                ),
              ),
            ),
          ],
        ),
        GoRoute(
          path: "privacy_and_security",
          parentNavigatorKey: pane,
          pageBuilder: (context, state) => _pageMaterial(
            state,
            BlocProvider<SettingsPrivacyAndSecurityCubit>(
              create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
              child: const SettingsPrivacyAndSecurityMaterial(),
            ),
            pane: split,
            context: context,
          ),
          routes: [
            // «Заблокированные»: блокируют из профиля, здесь — список и «Разблокировать».
            GoRoute(
              path: "blocked",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _pageMaterial(
                state,
                BlocProvider<SettingsBlockedCubit>(
                  create: (_) => SettingsBlockedCubit()..initialization(),
                  child: const SettingsBlockedMaterial(),
                ),
              ),
            ),
            GoRoute(
              path: "calls",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _pageMaterial(
                state,
                BlocProvider<SettingsPrivacyAndSecurityCubit>(
                  create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
                  child: const SettingsPrivacyCallsMaterial(),
                ),
              ),
              routes: [
                GoRoute(
                  path: "allow",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _pageMaterial(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowMaterial(
                        kind: CallsListKind.allow,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
                GoRoute(
                  path: "deny",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _pageMaterial(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowMaterial(
                        kind: CallsListKind.deny,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: "birthday",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _pageMaterial(
                state,
                BlocProvider<SettingsPrivacyAndSecurityCubit>(
                  create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
                  child: const SettingsPrivacyBirthdayMaterial(),
                ),
              ),
              routes: [
                GoRoute(
                  path: "allow",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _pageMaterial(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowMaterial(
                        kind: CallsListKind.allow,
                        channel: PrivacyChannel.birthday,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
                GoRoute(
                  path: "deny",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _pageMaterial(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowMaterial(
                        kind: CallsListKind.deny,
                        channel: PrivacyChannel.birthday,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: "about_me",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _pageMaterial(
                state,
                BlocProvider<SettingsPrivacyAndSecurityCubit>(
                  create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
                  child: const SettingsPrivacyAboutMeMaterial(),
                ),
              ),
              routes: [
                GoRoute(
                  path: "allow",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _pageMaterial(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowMaterial(
                        kind: CallsListKind.allow,
                        channel: PrivacyChannel.aboutMe,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
                GoRoute(
                  path: "deny",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _pageMaterial(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowMaterial(
                        kind: CallsListKind.deny,
                        channel: PrivacyChannel.aboutMe,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: "last_seen",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _pageMaterial(
                state,
                BlocProvider<SettingsPrivacyAndSecurityCubit>(
                  create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
                  child: const SettingsPrivacyLastSeenMaterial(),
                ),
              ),
              routes: [
                GoRoute(
                  path: "allow",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _pageMaterial(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowMaterial(
                        kind: CallsListKind.allow,
                        channel: PrivacyChannel.lastSeen,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
                GoRoute(
                  path: "deny",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _pageMaterial(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowMaterial(
                        kind: CallsListKind.deny,
                        channel: PrivacyChannel.lastSeen,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: "messages",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _pageMaterial(
                state,
                BlocProvider<SettingsPrivacyAndSecurityCubit>(
                  create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
                  child: const SettingsPrivacyMessagesMaterial(),
                ),
              ),
              routes: [
                GoRoute(
                  path: "allow",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _pageMaterial(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowMaterial(
                        kind: CallsListKind.allow,
                        channel: PrivacyChannel.messages,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
                GoRoute(
                  path: "deny",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _pageMaterial(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowMaterial(
                        kind: CallsListKind.deny,
                        channel: PrivacyChannel.messages,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: "forwards",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _pageMaterial(
                state,
                BlocProvider<SettingsPrivacyAndSecurityCubit>(
                  create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
                  child: const SettingsPrivacyForwardsMaterial(),
                ),
              ),
              routes: [
                GoRoute(
                  path: "allow",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _pageMaterial(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowMaterial(
                        kind: CallsListKind.allow,
                        channel: PrivacyChannel.forwards,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
                GoRoute(
                  path: "deny",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _pageMaterial(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowMaterial(
                        kind: CallsListKind.deny,
                        channel: PrivacyChannel.forwards,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: "group_invites",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _pageMaterial(
                state,
                BlocProvider<SettingsPrivacyAndSecurityCubit>(
                  create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
                  child: const SettingsPrivacyGroupInvitesMaterial(),
                ),
              ),
              routes: [
                GoRoute(
                  path: "allow",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _pageMaterial(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowMaterial(
                        kind: CallsListKind.allow,
                        channel: PrivacyChannel.groupInvites,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
                GoRoute(
                  path: "deny",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _pageMaterial(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowMaterial(
                        kind: CallsListKind.deny,
                        channel: PrivacyChannel.groupInvites,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: "phone_number",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _pageMaterial(
                state,
                BlocProvider<SettingsPrivacyAndSecurityCubit>(
                  create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
                  child: const SettingsPrivacyPhoneNumberMaterial(),
                ),
              ),
              routes: [
                GoRoute(
                  path: "allow",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _pageMaterial(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowMaterial(
                        kind: CallsListKind.allow,
                        channel: PrivacyChannel.phoneNumber,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
                GoRoute(
                  path: "deny",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _pageMaterial(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit(),
                      child: SettingsPrivacyCallsAllowMaterial(
                        kind: CallsListKind.deny,
                        channel: PrivacyChannel.phoneNumber,
                        initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: "passcode",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _pageMaterial(
                state,
                BlocProvider<SettingsPasscodeCubit>(
                  create: (_) => SettingsPasscodeCubit()..initialization(),
                  child: const SettingsPasscodeMaterial(),
                ),
              ),
              routes: [
                GoRoute(
                  path: "create",
                  parentNavigatorKey: pane,
                  pageBuilder: (context, state) => _pageMaterial(
                    state,
                    BlocProvider<SettingsPasscodeCreateCubit>(
                      create: (_) => SettingsPasscodeCreateCubit()..initialization(),
                      child: const SettingsPasscodeCreateMaterial(),
                    ),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: "cloud_password",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _pageMaterial(
                state,
                BlocProvider<SettingsCloudPasswordCubit>(
                  create: (_) => SettingsCloudPasswordCubit()..initialization(),
                  child: const SettingsCloudPasswordMaterial(),
                ),
              ),
            ),
            GoRoute(
              path: "passkeys",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _pageMaterial(
                state,
                BlocProvider<SettingsPasskeysCubit>(
                  create: (_) => SettingsPasskeysCubit()..initialization(),
                  child: const SettingsPasskeysMaterial(),
                ),
              ),
            ),
          ],
        ),
        GoRoute(
          // Скрытый раздел «Разработчик» (открывается 5 тапами по вкладке
          // «Настройки», см. HomeMaterial). Логи теперь живут здесь.
          path: "developer",
          parentNavigatorKey: pane,
          pageBuilder: (context, state) => _pageMaterial(state, const SettingsDeveloperMaterial(), pane: split, context: context),
          routes: [
            GoRoute(
              path: "logs",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _pageMaterial(state, TalkerScreen(talker: logger.talker)),
            ),
            // DEBUG-only превью экрана звонка без реального звонка.
            if (kDebugMode)
              GoRoute(
                path: "call_preview",
                parentNavigatorKey: pane,
                pageBuilder: (context, state) => _pageMaterial(state, const CallPreview()),
              ),
          ],
        ),
        // «Данные и память»: использование памяти и трафика.
        GoRoute(
          path: "data",
          parentNavigatorKey: pane,
          pageBuilder: (context, state) => _pageMaterial(state, const SettingsDataMaterial(), pane: split, context: context),
          routes: [
            GoRoute(
              path: "storage",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _pageMaterial(
                state,
                BlocProvider<SettingsStorageCubit>(
                  create: (_) => SettingsStorageCubit()..initialization(),
                  child: const SettingsStorageMaterial(),
                ),
              ),
            ),
            GoRoute(
              path: "network",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _pageMaterial(
                state,
                BlocProvider<SettingsNetworkCubit>(
                  create: (_) => SettingsNetworkCubit()..initialization(),
                  child: const SettingsNetworkMaterial(),
                ),
              ),
            ),
          ],
        ),
        GoRoute(
          path: "language",
          parentNavigatorKey: pane,
          pageBuilder: (context, state) => _pageMaterial(
            state,
            BlocProvider<SettingsLanguageCubit>(
              create: (_) => SettingsLanguageCubit()..initialization(locale: context.read<CommonCubit>().state.settingsDevice.locale),
              child: const SettingsLanguageMaterialScreen(),
            ),
            pane: split,
            context: context,
          ),
        ),
        GoRoute(
          path: "appearance",
          parentNavigatorKey: pane,
          pageBuilder: (context, state) => _pageMaterial(
            state,
            BlocProvider<SettingsAppearanceCubit>(
              create: (_) => SettingsAppearanceCubit()
                ..initialization(
                  colorTheme: context.read<CommonCubit>().state.settingsDevice.colorTheme,
                  darkMode: context.read<CommonCubit>().state.settingsDevice.darkMode,
                  isBlurOnInactive: context.read<CommonCubit>().state.settingsDevice.isBlurOnInactive,
                ),
              child: const SettingsAppearanceMaterial(),
            ),
            pane: split,
            context: context,
          ),
          routes: [
            // Темы для чатов — обои окна чата.
            GoRoute(
              path: "chat_themes",
              parentNavigatorKey: pane,
              pageBuilder: (context, state) => _pageMaterial(state, const SettingsChatThemesMaterial()),
            ),
          ],
        ),
        GoRoute(
          path: "device_sessions",
          parentNavigatorKey: pane,
          pageBuilder: (context, state) => _pageMaterial(
            state,
            BlocProvider<SettingsDeviceSessionsCubit>(
              create: (_) => SettingsDeviceSessionsCubit()..initialization(),
              child: const SettingsDeviceSessionsMaterial(),
            ),
            pane: split,
            context: context,
          ),
        ),
      ],
    );
    if (!split) return settings;
    return ShellRoute(
      builder: (context, state, child) => BlocProvider<SettingsCubit>(
        create: (_) => SettingsCubit()..initialization(),
        child: SplitViewMaterial(list: const SettingsMaterial(), selected: _splitSelected(state.uri.path, 'settings'), child: child),
      ),
      routes: [settings],
    );
  }

  List<RouteBase> _commonMaterial(GlobalKey<NavigatorState> rootNavigatorKey, {bool split = false}) => <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>(create: (_) => HomeCubit()..initialization()),
          BlocProvider<ConnectionCubit>(create: (_) => ConnectionCubit()..initialization()),
          // Контакты живут на уровне shell, чтобы к моменту открытия вкладки
          // список уже был показан из кэша и (при выданном доступе) освежён.
          BlocProvider<ContactsCubit>(create: (_) => ContactsCubit()..bootstrap()),
        ],
        child: CallGate(
          child: DeepLinkGate(child: HomeMaterial(navigationShell: navigationShell)),
        ),
      ),
      branches: [
        StatefulShellBranch(routes: [_contactsMaterial(rootNavigatorKey, split: split)]),
        StatefulShellBranch(routes: [_callsMaterial(split: split)]),
        StatefulShellBranch(routes: [_chatsMaterial(rootNavigatorKey, split: split)]),
        StatefulShellBranch(routes: [_settingsMaterial(rootNavigatorKey, split: split)]),
      ],
    ),
    GoRoute(
      path: "/call",
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => _pageMaterial(
        state,
        BlocProvider<CallCubit>(create: (_) => CallCubit()..initialization(), child: const CallMaterial()),
        fullSwipe: false,
      ),
    ),
    _profileMaterial("/profile/:userID", rootNavigatorKey),
    GoRoute(
      path: "/auth",
      builder: (_, _) => BlocProvider<AuthCubit>(create: (_) => AuthCubit()..initialization(), child: const AuthMaterialScreen()),
      routes: [
        GoRoute(
          path: "/call_password_confirmation",
          pageBuilder: (context, state) {
            final callPasswordSession = state.uri.queryParameters["callPasswordSession"] ?? "";
            final confirmationPhoneNumber = state.uri.queryParameters["confirmationPhoneNumber"] ?? "";
            final timeout = state.uri.queryParameters["timeout"] ?? "";

            if (callPasswordSession.isEmpty || confirmationPhoneNumber.isEmpty || timeout.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) context.go("/auth");
              });
              return _pageMaterial(state, const SizedBox.shrink());
            }

            return _pageMaterial(
              state,
              BlocProvider<AuthCallpasswordConfirmationCubit>(
                create: (_) => AuthCallpasswordConfirmationCubit()
                  ..initialization(
                    callPasswordSession: callPasswordSession,
                    confirmationPhoneNumber: confirmationPhoneNumber,
                    timeout: timeout,
                  ),
                child: const AuthCallpasswordConfirmationMaterial(),
              ),
            );
          },
        ),
        GoRoute(
          path: "/moderation_application_store",
          pageBuilder: (context, state) {
            final moderationApplicationStoreSession = state.uri.queryParameters["moderationApplicationStoreSession"] ?? "";
            final phoneNumber = state.uri.queryParameters["phoneNumber"] ?? "";

            if (moderationApplicationStoreSession.isEmpty || phoneNumber.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) context.go("/auth");
              });
              return _pageMaterial(state, const SizedBox.shrink());
            }

            return _pageMaterial(
              state,
              BlocProvider<AuthModerationApplicationStoreCubit>(
                create: (_) =>
                    AuthModerationApplicationStoreCubit()
                      ..initialization(phoneNumber: phoneNumber, moderationApplicationStoreSession: moderationApplicationStoreSession),
                child: const AuthModerationApplicationStoreMaterial(),
              ),
            );
          },
        ),
        GoRoute(
          path: "/cloud_password",
          pageBuilder: (context, state) {
            final confirmationSession = state.uri.queryParameters["confirmationSession"] ?? "";

            if (confirmationSession.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) context.go("/auth");
              });
              return _pageMaterial(state, const SizedBox.shrink());
            }

            return _pageMaterial(
              state,
              BlocProvider<AuthCloudPasswordCubit>(
                create: (_) => AuthCloudPasswordCubit()..initialization(confirmationSession: confirmationSession),
                child: const AuthCloudPasswordMaterial(),
              ),
            );
          },
        ),
      ],
    ),
  ];

  GoRouter cupertino(GlobalKey<NavigatorState> navigatorGoRouterKey) {
    return GoRouter(
      debugLogDiagnostics: kDebugMode,
      observers: [TalkerRouteObserver(logger.talker)],
      navigatorKey: navigatorGoRouterKey,
      initialLocation: initialLocation,
      redirect: _redirect,
      refreshListenable: auth,
      routes: [
        ..._common(navigatorGoRouterKey, split: SplitLayout.enabled),
        ..._cupertino,
      ],
    );
  }

  GoRouter material(GlobalKey<NavigatorState> navigatorGoRouterKey) {
    return GoRouter(
      debugLogDiagnostics: kDebugMode,
      navigatorKey: navigatorGoRouterKey,
      initialLocation: initialLocation,
      redirect: _redirect,
      refreshListenable: auth,
      routes: [..._commonMaterial(navigatorGoRouterKey, split: SplitLayout.enabled)],
    );
  }
}
