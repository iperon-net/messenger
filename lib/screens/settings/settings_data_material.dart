import 'package:material_ui/material_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../split_layout.dart';
import '../../components.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';

/// «Данные и память»: «Использование памяти» и «Использование трафика».
class SettingsDataMaterial extends StatelessWidget {
  const SettingsDataMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenSettingsData;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: !context.isSplitPaneRoot, title: Text(t.dataAndStorage)),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Text(
                t.usage,
                style: TextStyle(fontSize: AppFontSizes.caption, color: muted),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  MaterialListTileIcon(
                    title: Text(t.storageUsage),
                    color: const Color(0xFF34C759),
                    icon: FontAwesomeIcons.chartPie,
                    onTab: () async => context.push('/settings/data/storage'),
                    isTrailing: true,
                  ),
                  MaterialListTileIcon(
                    title: Text(t.networkUsage),
                    color: const Color(0xFF007AFF),
                    icon: FontAwesomeIcons.chartSimple,
                    onTab: () async => context.push('/settings/data/network'),
                    isTrailing: true,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
              child: Text(
                t.storageNote,
                style: TextStyle(fontSize: AppFontSizes.caption, color: muted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
