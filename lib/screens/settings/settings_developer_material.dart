import 'package:material_ui/material_ui.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../split_layout.dart';
import '../../i18n/translations.g.dart';
import '../../components.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../logger.dart';
import 'developer_accounts.dart';
import 'developer_export_logs.dart';
import 'developer_remote_config.dart';
import 'developer_test_push.dart';

/// Скрытый экран «Разработчик». Открывается 5 быстрыми тапами по кнопке
/// «Настройки» в нижнем таб-баре (см. `HomeMaterial`), в обычном меню настроек
/// не показан. Разделы: «Логи», экспорт логов, тестовое уведомление (проверка
/// доставки APNs/FCM — нужна и в TestFlight-сборке, поэтому без kDebugMode).
class SettingsDeveloperMaterial extends StatelessWidget {
  const SettingsDeveloperMaterial({super.key});

  /// Слоты аккаунтов: переключиться или завести новый (вход откроется в нём).
  Future<void> _pickAccount(BuildContext context) async {
    final t = context.t.screenDeveloper;
    final slots = await developerAccountSlots(signedOut: t.accountsEmpty);
    if (!context.mounted) return;
    final picked = await showModalBottomSheet<({String? accountID})>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final slot in slots)
              ListTile(
                leading: Icon(slot.active ? Icons.radio_button_checked : Icons.radio_button_unchecked),
                title: Text(slot.title),
                subtitle: slot.active ? Text(t.accountsActive) : null,
                onTap: () => Navigator.of(sheetContext).pop((accountID: slot.accountID)),
              ),
            ListTile(
              leading: const Icon(Icons.add),
              title: Text(t.accountsNew),
              onTap: () => Navigator.of(sheetContext).pop((accountID: null)),
            ),
          ],
        ),
      ),
    );
    if (picked == null || !context.mounted) return;
    if (!developerCanSwitchAccount()) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(t.accountsCallActive)));
      return;
    }
    await developerSwitchAccount(picked.accountID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: AppBar(
        automaticallyImplyLeading: !context.isSplitPaneRoot,
        centerTitle: true,
        title: Text(context.t.screenDeveloper.developer),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 6),
            Card(
              child: Column(
                children: [
                  MaterialListTileIcon(
                    title: Text(context.t.screenDeveloper.logs),
                    color: const Color(0xFF8E8E93),
                    icon: FontAwesomeIcons.fileLines,
                    onTab: () async => context.go("/settings/developer/logs"),
                    isTrailing: true,
                  ),
                  MaterialListTileIcon(
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
                  MaterialListTileIcon(
                    title: Text(context.t.screenDeveloper.testPush),
                    color: const Color(0xFFFF3B30),
                    icon: FontAwesomeIcons.bell,
                    onTab: () async {
                      final message = await sendTestPush(context.t);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(SnackBar(content: Text(message)));
                    },
                    isTrailing: false,
                  ),
                  MaterialListTileIcon(
                    title: Text(context.t.screenDeveloper.testPushEncrypted),
                    color: const Color(0xFFFF9500),
                    icon: FontAwesomeIcons.lock,
                    onTab: () async {
                      final message = await sendTestPush(context.t, encrypted: true);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(SnackBar(content: Text(message)));
                    },
                    isTrailing: false,
                  ),
                  // Remote Config мимо интервала 24 ч — чтобы проверить флаг,
                  // только что изменённый в консоли Firebase.
                  StatefulBuilder(
                    builder: (context, setState) => MaterialListTileIcon(
                      title: Text(context.t.screenDeveloper.remoteConfig),
                      subtitle: Text(remoteConfigFetchedText(context.t)),
                      color: const Color(0xFFFFCC00),
                      icon: FontAwesomeIcons.arrowsRotate,
                      onTab: () async {
                        final message = await refreshRemoteConfig(context.t);
                        if (!context.mounted) return;
                        setState(() {});
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(SnackBar(content: Text(message)));
                      },
                      isTrailing: false,
                    ),
                  ),
                  // UX-демо чатов: вкладка «Чаты» на фейковых данных (см.
                  // docs/plans/chats-groups-channels.md, этап 0).
                  BlocSelector<CommonCubit, CommonState, bool>(
                    selector: (state) => state.settingsDevice.chatsDemo,
                    builder: (context, chatsDemo) => MaterialListTileIcon(
                      title: Text(context.t.screenDeveloper.chatsDemo),
                      color: const Color(0xFF5856D6),
                      icon: FontAwesomeIcons.comments,
                      trailing: Switch(
                        value: chatsDemo,
                        onChanged: (value) => context.read<CommonCubit>().setChatsDemo(value: value),
                      ),
                      onTab: () => context.read<CommonCubit>().setChatsDemo(value: !chatsDemo),
                    ),
                  ),
                  MaterialListTileIcon(
                    title: Text(context.t.screenDeveloper.accounts),
                    color: const Color(0xFF30B0C7),
                    icon: FontAwesomeIcons.users,
                    onTab: () => _pickAccount(context),
                    isTrailing: true,
                  ),
                  if (kDebugMode)
                    MaterialListTileIcon(
                      title: Text(context.t.screenDeveloper.callPreview),
                      color: const Color(0xFF007AFF),
                      icon: FontAwesomeIcons.phone,
                      onTab: () async => context.go("/settings/developer/call_preview"),
                      isTrailing: true,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
