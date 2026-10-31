import 'package:material_ui/material_ui.dart';

import '../../split_layout.dart';
import '../../i18n/translations.g.dart';
import 'settings_licenses_common.dart';

class SettingsLicensesMaterialScreen extends StatefulWidget {
  const SettingsLicensesMaterialScreen({super.key});

  @override
  State<SettingsLicensesMaterialScreen> createState() => _SettingsLicensesMaterialScreen();
}

class _SettingsLicensesMaterialScreen extends State<SettingsLicensesMaterialScreen> {
  Future<List<SettingsLicense>>? _licenses;

  @override
  void initState() {
    super.initState();
    _licenses = loadSettingsLicenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: !context.isSplitPaneRoot, title: Text(context.t.screenSettings.licenses)),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: SafeArea(
        child: FutureBuilder<List<SettingsLicense>>(
          future: _licenses,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final licenses = snapshot.data!;
            return ListView.builder(
              itemCount: licenses.length,
              itemBuilder: (context, index) {
                final license = licenses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(license.packages, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        SelectableText(license.text, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
