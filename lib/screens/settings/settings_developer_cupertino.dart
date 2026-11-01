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
import 'developer_config.dart';
import 'developer_test_push.dart';

/// Скрытый экран «Разработчик». Открывается 5 быстрыми тапами по кнопке
/// «Настройки» в нижнем таб-баре (см. `HomeCupertino`), в обычном меню настроек
/// не показан. Разделы: «Логи», экспорт логов, тестовое уведомление (проверка
/// доставки APNs/FCM — нужна и в TestFlight-сборке, поэтому без kDebugMode).
class SettingsDeveloperCupertino extends StatelessWidget {
  const SettingsDeveloperCupertino({super.key});

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
                // Bootstrap-файл (адреса серверов) мимо интервала — чтобы
                // проверить только что подписанный config.json.
                StatefulBuilder(
                  builder: (context, setState) => CupertinoListTileIcon(
                    title: Text(context.t.screenDeveloper.bootstrapConfig),
                    subtitle: Text(bootstrapConfigInfo(context.t)),
                    color: const Color(0xFFFFCC00),
                    icon: FontAwesomeIcons.server,
                    onTab: () async {
                      final message = await refreshBootstrapConfig(context.t);
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
                const _DeveloperAccountsCupertino(),
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

/// «Аккаунты (разработка)»: выпадающее меню слотов — номер, под ним окружение
/// и начало accountID, у активного галочка; ниже «Добавить аккаунт» в каждом
/// окружении (вход откроется на его сервере).
class _DeveloperAccountsCupertino extends StatefulWidget {
  const _DeveloperAccountsCupertino();

  @override
  State<_DeveloperAccountsCupertino> createState() => _DeveloperAccountsCupertinoState();
}

class _DeveloperAccountsCupertinoState extends State<_DeveloperAccountsCupertino> {
  List<DeveloperAccountSlot> _slots = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final slots = await developerAccountSlots(signedOut: context.t.screenDeveloper.accountsEmpty);
    if (mounted) setState(() => _slots = slots);
  }

  Future<void> _switch({String? accountID, String? environment}) async {
    if (!developerCanSwitchAccount()) {
      await showCupertinoDialog<void>(
        context: context,
        builder: (dialogContext) => CupertinoAlertDialog(
          title: Text(context.t.screenDeveloper.accountsCallActive),
          actions: [CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(context.t.common.ok))],
        ),
      );
      return;
    }
    await developerSwitchAccount(accountID: accountID, environment: environment);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenDeveloper;
    return CupertinoMenuAnchor(
      consumeOutsideTaps: true,
      onOpen: _load,
      menuChildren: [
        for (final slot in _slots)
          CupertinoMenuItem(
            // Как в системных меню выбора: галочка слева, иконка справа.
            leading: slot.active ? const Icon(CupertinoIcons.check_mark) : null,
            trailing: Icon(slot.signedIn ? CupertinoIcons.person_crop_circle : CupertinoIcons.person_crop_circle_badge_xmark),
            subtitle: Text(slot.active ? '${slot.detail} · ${t.accountsActive}' : slot.detail),
            onPressed: slot.active ? () {} : () => _switch(accountID: slot.accountID),
            child: Text(slot.phone, style: slot.signedIn ? null : TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context))),
          ),
        if (_slots.isNotEmpty) const CupertinoMenuDivider(),
        for (final environment in developerEnvironments())
          CupertinoMenuItem(
            trailing: const Icon(CupertinoIcons.add_circled),
            subtitle: Text(environment),
            onPressed: () => _switch(environment: environment),
            child: Text(t.accountsNew),
          ),
      ],
      builder: (context, controller, child) => CupertinoListTileIcon(
        title: Text(t.accounts),
        additionalInfo: Text('${_slots.length}'),
        color: const Color(0xFF30B0C7),
        icon: FontAwesomeIcons.users,
        trailing: Icon(CupertinoIcons.chevron_up_chevron_down, size: 16, color: CupertinoColors.tertiaryLabel.resolveFrom(context)),
        onTab: () async => controller.isOpen ? controller.close() : controller.open(),
      ),
    );
  }
}
