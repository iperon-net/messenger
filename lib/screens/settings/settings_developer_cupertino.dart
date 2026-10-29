import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../split_layout.dart';
import '../../themes.dart';
import '../../i18n/translations.g.dart';
import '../../components.dart';
import '../../cubit.dart';
import '../../calls.dart';
import '../../di.dart';
import '../../logger.dart';
import 'developer_accounts.dart';
import 'developer_export_logs.dart';
import 'developer_remote_config.dart';
import 'developer_test_push.dart';

/// Скрытый экран «Разработчик». Открывается 5 быстрыми тапами по кнопке
/// «Настройки» в нижнем таб-баре (см. `HomeCupertino`), в обычном меню настроек
/// не показан. Разделы: «Логи», экспорт логов, тестовое уведомление (проверка
/// доставки APNs/FCM — нужна и в TestFlight-сборке, поэтому без kDebugMode).
class SettingsDeveloperCupertino extends StatelessWidget {
  const SettingsDeveloperCupertino({super.key});

  /// Слоты аккаунтов: переключиться или завести новый (вход откроется в нём).
  Future<void> _pickAccount(BuildContext context) async {
    final t = context.t.screenDeveloper;
    final slots = await developerAccountSlots(signedOut: t.accountsEmpty);
    if (!context.mounted) return;
    final picked = await showCupertinoDialog<({String? accountID})>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(t.accounts),
        actions: [
          for (final slot in slots)
            CupertinoDialogAction(
              isDefaultAction: slot.active,
              onPressed: () => Navigator.of(dialogContext).pop((accountID: slot.accountID)),
              child: Text(slot.active ? '${slot.title} · ${t.accountsActive}' : slot.title),
            ),
          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop((accountID: null)), child: Text(t.accountsNew)),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(context.t.common.cancel),
          ),
        ],
      ),
    );
    if (picked == null || !context.mounted) return;
    if (!developerCanSwitchAccount()) {
      await showCupertinoDialog<void>(
        context: context,
        builder: (dialogContext) => CupertinoAlertDialog(
          title: Text(t.accountsCallActive),
          actions: [CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(context.t.common.ok))],
        ),
      );
      return;
    }
    await developerSwitchAccount(picked.accountID);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: ThemesCupertino.groupedBackground,
      navigationBar: AppCupertinoNavigationBar(
        child: CupertinoNavigationBar(
          // iPad: корень правой панели — без «назад», список слева.
          automaticallyImplyLeading: !context.isSplitPaneRoot,
          previousPageTitle: '',
          automaticBackgroundVisibility: false,
          backgroundColor: ThemesCupertino.groupedBackground,
          middle: Text(context.t.screenDeveloper.developer),
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            CupertinoListSection.insetGrouped(
              backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
              decoration: BoxDecoration(
                color: ThemesCupertino.groupedCard.resolveFrom(context),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              children: [
                CupertinoListTileIcon(
                  title: Text(context.t.screenDeveloper.logs),
                  color: const Color(0xFF8E8E93),
                  icon: FontAwesomeIcons.fileLines,
                  onTab: () async => context.go("/settings/developer/logs"),
                  isTrailing: true,
                ),
                CupertinoListTileIcon(
                  title: Text(context.t.screenDeveloper.exportLogs),
                  color: const Color(0xFF34C759),
                  icon: FontAwesomeIcons.fileExport,
                  onTab: () async {
                    try {
                      await exportDeviceLogs();
                    } catch (error, stackTrace) {
                      getIt.get<Logger>().handle(error, stackTrace);
                    }
                  },
                  isTrailing: true,
                ),
                CupertinoListTileIcon(
                  title: Text(context.t.screenDeveloper.testPush),
                  color: const Color(0xFFFF3B30),
                  icon: FontAwesomeIcons.bell,
                  onTab: () async {
                    final message = await sendTestPush(context.t);
                    if (!context.mounted) return;
                    await showCupertinoDialog<void>(
                      context: context,
                      builder: (dialogContext) => CupertinoAlertDialog(
                        content: Text(message),
                        actions: [
                          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(context.t.common.ok)),
                        ],
                      ),
                    );
                  },
                  isTrailing: false,
                ),
                CupertinoListTileIcon(
                  title: Text(context.t.screenDeveloper.testPushEncrypted),
                  color: const Color(0xFFFF9500),
                  icon: FontAwesomeIcons.lock,
                  onTab: () async {
                    final message = await sendTestPush(context.t, encrypted: true);
                    if (!context.mounted) return;
                    await showCupertinoDialog<void>(
                      context: context,
                      builder: (dialogContext) => CupertinoAlertDialog(
                        content: Text(message),
                        actions: [
                          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(context.t.common.ok)),
                        ],
                      ),
                    );
                  },
                  isTrailing: false,
                ),
                // Настройки приложения с сервера (админка) — не дожидаясь
                // пуша или перезапуска.
                CupertinoListTileIcon(
                  title: Text(context.t.screenDeveloper.serverConfig),
                  subtitle: Text(context.t.screenDeveloper.serverConfigHint),
                  color: const Color(0xFF34C759),
                  icon: FontAwesomeIcons.arrowsRotate,
                  onTab: () async {
                    final message = await refreshServerConfig(context.t);
                    if (!context.mounted) return;
                    await showCupertinoDialog<void>(
                      context: context,
                      builder: (dialogContext) => CupertinoAlertDialog(
                        content: Text(message),
                        actions: [
                          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(context.t.common.ok)),
                        ],
                      ),
                    );
                  },
                  isTrailing: false,
                ),
                // Remote Config мимо интервала 24 ч — чтобы проверить флаг,
                // только что изменённый в консоли Firebase.
                StatefulBuilder(
                  builder: (context, setState) => CupertinoListTileIcon(
                    title: Text(context.t.screenDeveloper.remoteConfig),
                    subtitle: Text(remoteConfigFetchedText(context.t)),
                    color: const Color(0xFFFFCC00),
                    icon: FontAwesomeIcons.arrowsRotate,
                    onTab: () async {
                      final message = await refreshRemoteConfig(context.t);
                      if (!context.mounted) return;
                      setState(() {});
                      await showCupertinoDialog<void>(
                        context: context,
                        builder: (dialogContext) => CupertinoAlertDialog(
                          content: Text(message),
                          actions: [
                            CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(context.t.common.ok)),
                          ],
                        ),
                      );
                    },
                    isTrailing: false,
                  ),
                ),
                // UX-демо чатов: вкладка «Чаты» на фейковых данных (см.
                // docs/plans/chats-groups-channels.md, этап 0).
                BlocSelector<CommonCubit, CommonState, bool>(
                  selector: (state) => state.settingsDevice.chatsDemo,
                  builder: (context, chatsDemo) => CupertinoListTileIcon(
                    title: Text(context.t.screenDeveloper.chatsDemo),
                    color: const Color(0xFF5856D6),
                    icon: FontAwesomeIcons.comments,
                    trailing: CupertinoSwitch(
                      value: chatsDemo,
                      onChanged: (value) => context.read<CommonCubit>().setChatsDemo(value: value),
                    ),
                    onTab: () => context.read<CommonCubit>().setChatsDemo(value: !chatsDemo),
                  ),
                ),
                // Звонки только через TURN — проверка запасного пути на 443.
                ValueListenableBuilder<bool>(
                  valueListenable: Calls.forceRelay,
                  builder: (context, relay, _) => CupertinoListTileIcon(
                    title: Text(context.t.screenDeveloper.callsRelayOnly),
                    color: const Color(0xFF34C759),
                    icon: FontAwesomeIcons.towerBroadcast,
                    trailing: CupertinoSwitch(value: relay, onChanged: (value) => Calls.forceRelay.value = value),
                    onTab: () async => Calls.forceRelay.value = !relay,
                  ),
                ),
                CupertinoListTileIcon(
                  title: Text(context.t.screenDeveloper.accounts),
                  color: const Color(0xFF30B0C7),
                  icon: FontAwesomeIcons.users,
                  onTab: () => _pickAccount(context),
                  isTrailing: true,
                ),
                if (kDebugMode)
                  CupertinoListTileIcon(
                    title: Text(context.t.screenDeveloper.callPreview),
                    color: const Color(0xFF007AFF),
                    icon: FontAwesomeIcons.phone,
                    onTab: () async => context.go("/settings/developer/call_preview"),
                    isTrailing: true,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
