import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../themes.dart';
import '../../cubit.dart';
import '../../desktop.dart';
import '../../i18n/translations.g.dart';
import '../../split_layout.dart';
import '../../utils.dart';
import '../../di.dart';

/// «Общие» (только десктоп): клавиша отправки сообщения, «Звонки» (микрофон и
/// камера — [SettingsCallsMaterial]), запуск при входе в систему, «Проверить
/// обновления» (версия приложения; есть новее — подпись под пунктом).
class SettingsGeneralMaterial extends StatelessWidget {
  const SettingsGeneralMaterial({super.key});

  /// Клавиша-модификатор отправки: ⌘ на Mac, Ctrl на Windows / Linux.
  static String get modifierKey => Platform.isMacOS ? '⌘' : 'Ctrl';

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenSettingsGeneral;
    final check = Icon(Icons.check, size: 22, color: Theme.of(context).colorScheme.primary);
    final modifier = context.select<CommonCubit, bool>((cubit) => cubit.state.settingsDevice.sendWithModifierEnter);

    Widget option(String title, bool value) => ListTile(
      title: Text(title),
      trailing: modifier == value ? check : null,
      onTap: () => context.read<CommonCubit>().setSendWithModifierEnter(value),
    );

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: !context.isSplitPaneRoot, title: Text(t.general)),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: SafeArea(
        child: ListView(
          children: [
            _header(context, t.sendMessage),
            Card(
              margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              child: Column(children: [option('Enter', false), option('$modifierKey + Enter', true)]),
            ),
            _hint(context, modifier ? t.newLineEnter : t.newLineShiftEnter),
            // Микрофон и камера — отдельным экраном.
            Card(
              margin: const EdgeInsets.fromLTRB(12, 16, 12, 4),
              child: ListTile(
                leading: const Icon(Icons.call_outlined),
                title: Text(t.calls),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/settings/general/calls'),
              ),
            ),
            const Card(margin: EdgeInsets.fromLTRB(12, 16, 12, 4), child: _LaunchAtLoginTile()),
            const Card(margin: EdgeInsets.fromLTRB(12, 16, 12, 16), child: _UpdatesTile()),
          ],
        ),
      ),
    );
  }
}

Widget _header(BuildContext context, String text) => Padding(
  padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
  child: Text(
    text.toUpperCase(),
    style: TextStyle(fontSize: AppFontSizes.caption, color: Theme.of(context).colorScheme.primary),
  ),
);

Widget _hint(BuildContext context, String text) => Padding(
  padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
  child: Text(
    text,
    style: TextStyle(fontSize: AppFontSizes.caption, color: Theme.of(context).colorScheme.onSurfaceVariant),
  ),
);

/// «Запускать при входе в систему» ([Desktop.setLaunchAtLogin]).
class _LaunchAtLoginTile extends StatefulWidget {
  const _LaunchAtLoginTile();

  @override
  State<_LaunchAtLoginTile> createState() => _LaunchAtLoginTileState();
}

class _LaunchAtLoginTileState extends State<_LaunchAtLoginTile> {
  bool? _enabled;

  @override
  void initState() {
    super.initState();
    Desktop.launchAtLogin().then((enabled) {
      if (mounted) setState(() => _enabled = enabled);
    });
  }

  Future<void> _set(bool value) async {
    try {
      final status = await Desktop.setLaunchAtLogin(value);
      if (!mounted) return;
      setState(() => _enabled = status == 'enabled');
      if (status == 'requiresApproval') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.t.screenSettings.launchAtLoginApproval)));
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.t.screenSettings.launchAtLoginFailed(error: error is PlatformException ? error.message ?? error.code : error),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => SwitchListTile(
    title: Text(context.t.screenSettings.launchAtLogin),
    value: _enabled ?? false,
    onChanged: _enabled == null ? null : _set,
  );
}

/// «Проверить обновления»: справа — версия приложения; при открытии экрана
/// тихо спрашивает Sparkle ([Desktop.latestVersion]), нашлась новее — подпись
/// «Доступна новая версия». Нажатие — окно Sparkle (скачать и поставить).
class _UpdatesTile extends StatefulWidget {
  const _UpdatesTile();

  @override
  State<_UpdatesTile> createState() => _UpdatesTileState();
}

class _UpdatesTileState extends State<_UpdatesTile> {
  String _version = '';

  /// null — ещё проверяем или обновления выключены ([_enabled]); '' — новее нет.
  String? _latest;
  bool _enabled = true;

  @override
  void initState() {
    super.initState();
    getIt.get<Utils>().packageInfo().then((info) {
      if (mounted) setState(() => _version = info.appVersion);
    });
    Desktop.latestVersion().then((latest) {
      if (!mounted) return;
      setState(() {
        _enabled = latest != null;
        _latest = latest;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenSettingsGeneral;
    final scheme = Theme.of(context).colorScheme;
    final latest = _latest;
    final available = latest != null && latest.isNotEmpty;
    return ListTile(
      leading: const Icon(Icons.system_update_alt),
      title: Text(t.checkUpdates),
      subtitle: switch ((enabled: _enabled, latest: latest)) {
        (enabled: false, latest: _) => Text(t.updatesOff),
        (enabled: true, latest: null) => null,
        _ when available => Text(
          t.updateAvailable(version: latest),
          style: TextStyle(color: scheme.primary),
        ),
        _ => Text(t.upToDate),
      },
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (available)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: scheme.primary, shape: BoxShape.circle),
              ),
            ),
          Text(_version, style: TextStyle(color: scheme.onSurfaceVariant)),
        ],
      ),
      onTap: _enabled ? Desktop.checkForUpdates : null,
    );
  }
}
