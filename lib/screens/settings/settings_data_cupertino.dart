import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../split_layout.dart';
import '../../components.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';

/// «Данные и память»: «Использование памяти» и «Использование трафика».
class SettingsDataCupertino extends StatelessWidget {
  const SettingsDataCupertino({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenSettingsData;
    return CupertinoPageScaffold(
      backgroundColor: ThemesCupertino.groupedBackground,
      navigationBar: AppCupertinoNavigationBar(
        child: CupertinoNavigationBar(
          // iPad: корень правой панели — без «назад», список слева.
          automaticallyImplyLeading: !context.isSplitPaneRoot,
          previousPageTitle: '',
          automaticBackgroundVisibility: false,
          backgroundColor: ThemesCupertino.groupedBackground,
          middle: Text(t.dataAndStorage),
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            CupertinoListSection.insetGrouped(
              header: Text(
                t.usage,
                style: TextStyle(fontSize: AppFontSizes.base, fontWeight: FontWeight.normal),
              ),
              footer: Padding(
                padding: const EdgeInsets.only(left: 13, right: 13),
                child: Text(t.storageNote, style: TextStyle(fontSize: AppFontSizes.caption)),
              ),
              backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
              decoration: BoxDecoration(
                color: ThemesCupertino.groupedCard.resolveFrom(context),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              children: [
                CupertinoListTileIcon(
                  title: Text(t.storageUsage),
                  color: const Color(0xFF34C759),
                  icon: FontAwesomeIcons.chartPie,
                  onTab: () async => context.push('/settings/data/storage'),
                  isTrailing: true,
                ),
                CupertinoListTileIcon(
                  title: Text(t.networkUsage),
                  color: const Color(0xFF007AFF),
                  icon: FontAwesomeIcons.chartSimple,
                  onTab: () async => context.push('/settings/data/network'),
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
