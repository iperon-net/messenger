import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../themes.dart';
import '../../cubit.dart';
import '../../desktop.dart';
import '../../i18n/translations.g.dart';
import '../../split_layout.dart';

/// «Общие» (только десктоп): клавиша отправки сообщения и запуск при входе в
/// систему.
class SettingsGeneralMaterial extends StatelessWidget {
  const SettingsGeneralMaterial({super.key});

  /// Клавиша-модификатор отправки: ⌘ на Mac, Ctrl на Windows / Linux.
  static String get modifierKey => Platform.isMacOS ? '⌘' : 'Ctrl';

  Widget _sectionHeader(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
    child: Text(
      text.toUpperCase(),
      style: TextStyle(fontSize: AppFontSizes.caption, color: Theme.of(context).colorScheme.primary),
    ),
  );

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
            _sectionHeader(context, t.sendMessage),
            Card(
              margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              child: Column(children: [option('Enter', false), option('$modifierKey + Enter', true)]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Text(
                modifier ? t.newLineEnter : t.newLineShiftEnter,
                style: TextStyle(fontSize: AppFontSizes.caption, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ),
            const Card(margin: EdgeInsets.fromLTRB(12, 8, 12, 16), child: _LaunchAtLoginTile()),
          ],
        ),
      ),
    );
  }
}

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
