import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../split_layout.dart';
import '../../components.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';
import 'settings_about_common.dart';

/// «О приложении»: иконка приложения, версии (приложение, Flutter, Dart) и «Лицензии».
class SettingsAboutCupertino extends StatefulWidget {
  const SettingsAboutCupertino({super.key});

  @override
  State<SettingsAboutCupertino> createState() => _SettingsAboutCupertinoState();
}

class _SettingsAboutCupertinoState extends State<SettingsAboutCupertino> {
  final _versions = loadSettingsAboutVersions();

  Widget _section(BuildContext context, List<Widget> children) => CupertinoListSection.insetGrouped(
    backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
    decoration: BoxDecoration(
      color: ThemesCupertino.groupedCard.resolveFrom(context),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
    children: children,
  );

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenSettingsAboutApplication;
    return CupertinoPageScaffold(
      backgroundColor: ThemesCupertino.groupedBackground,
      navigationBar: AppCupertinoNavigationBar(
        child: CupertinoNavigationBar(
          // iPad: корень правой панели — без «назад», список слева.
          automaticallyImplyLeading: !context.isSplitPaneRoot,
          previousPageTitle: '',
          automaticBackgroundVisibility: false,
          backgroundColor: ThemesCupertino.groupedBackground,
          middle: Text(t.aboutApplication),
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
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
                return _section(context, [
                  CupertinoListTile(title: Text(t.appVersion), additionalInfo: Text(versions?.app ?? '')),
                  CupertinoListTile(title: Text(t.flutterVersion), additionalInfo: Text(versions?.flutter ?? '')),
                  CupertinoListTile(title: Text(t.dartVersion), additionalInfo: Text(versions?.dart ?? '')),
                ]);
              },
            ),
            _section(context, [
              CupertinoListTileIcon(
                title: Text(t.licenses),
                color: const Color(0xFF8E8E93),
                icon: FontAwesomeIcons.fileLines,
                onTab: () async => context.push('/settings/about/licenses'),
                isTrailing: true,
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
