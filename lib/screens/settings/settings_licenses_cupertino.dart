import 'package:cupertino_ui/cupertino_ui.dart';
import '../../split_layout.dart';
import '../../themes.dart';

import '../../components.dart';
import '../../i18n/translations.g.dart';
import 'settings_licenses_common.dart';

class SettingsLicensesCupertinoScreen extends StatefulWidget {
  const SettingsLicensesCupertinoScreen({super.key});

  @override
  State<SettingsLicensesCupertinoScreen> createState() => _SettingsLicensesCupertinoScreen();
}

class _SettingsLicensesCupertinoScreen extends State<SettingsLicensesCupertinoScreen> {
  Future<List<SettingsLicense>>? _licenses;

  @override
  void initState() {
    super.initState();
    _licenses = loadSettingsLicenses();
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
          middle: Text(context.t.screenSettings.licenses),
        ),
      ),
      child: SafeArea(
        child: FutureBuilder<List<SettingsLicense>>(
          future: _licenses,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CupertinoActivityIndicator());
            }
            final licenses = snapshot.data!;
            return ListView.builder(
              itemCount: licenses.length,
              itemBuilder: (context, index) {
                final license = licenses[index];
                return CupertinoListSection.insetGrouped(
                  backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                  decoration: BoxDecoration(
                    color: ThemesCupertino.groupedCard.resolveFrom(context),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            license.packages,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: CupertinoTheme.of(context).textTheme.textStyle.color,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(license.text, style: TextStyle(fontSize: 13, color: CupertinoTheme.of(context).textTheme.textStyle.color)),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
