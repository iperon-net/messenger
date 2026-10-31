import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../split_layout.dart';
import '../../components.dart';
import '../../i18n/translations.g.dart';
import 'settings_about_common.dart';

/// «О приложении»: иконка приложения, версии (приложение, Flutter, Dart) и «Лицензии».
class SettingsAboutMaterial extends StatefulWidget {
  const SettingsAboutMaterial({super.key});

  @override
  State<SettingsAboutMaterial> createState() => _SettingsAboutMaterialState();
}

class _SettingsAboutMaterialState extends State<SettingsAboutMaterial> {
  final _versions = loadSettingsAboutVersions();

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenSettingsAboutApplication;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: !context.isSplitPaneRoot, title: Text(t.aboutApplication)),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Center(
                child: ClipRRect(
                  // Скругление как у иконки на домашнем экране iOS.
                  borderRadius: BorderRadius.circular(22),
                  child: Image.asset('assets/images/app_icon.png', width: 96, height: 96),
                ),
              ),
            ),
            FutureBuilder<SettingsAboutVersions>(
              future: _versions,
              builder: (context, snapshot) {
                final versions = snapshot.data;
                Widget row(String title, String? value) => ListTile(
                  title: Text(title),
                  trailing: Text(value ?? '', style: TextStyle(color: muted)),
                );
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      row(t.appVersion, versions?.app),
                      row(t.flutterVersion, versions?.flutter),
                      row(t.dartVersion, versions?.dart),
                    ],
                  ),
                );
              },
            ),
            Card(
              margin: const EdgeInsets.fromLTRB(12, 16, 12, 12),
              clipBehavior: Clip.antiAlias,
              child: MaterialListTileIcon(
                title: Text(t.licenses),
                color: const Color(0xFF8E8E93),
                icon: FontAwesomeIcons.fileLines,
                onTab: () async => context.push('/settings/about/licenses'),
                isTrailing: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
