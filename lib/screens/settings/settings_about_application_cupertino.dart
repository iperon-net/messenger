import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/foundation.dart';

import '../../components.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart';
import '../../themes.dart';
import '../../utils.dart';

/// Экран «О приложении».
///
/// `LicensePage` из Material здесь не используется намеренно: приложение
/// построено на `CupertinoApp` из `cupertino_ui`, поэтому `MaterialLocalizations`
/// отсутствует и `LicensePage` падает. Вместо этого читаем лицензии напрямую из
/// `LicenseRegistry` и рисуем их в Cupertino-стиле.
class SettingsAboutApplicationCupertino extends StatefulWidget {
  const SettingsAboutApplicationCupertino({super.key});

  @override
  State<SettingsAboutApplicationCupertino> createState() => _SettingsAboutApplicationCupertino();
}

/// Сгруппированные лицензии одного пакета.
class _PackageLicenses {
  _PackageLicenses(this.packageName);

  final String packageName;
  final List<LicenseEntry> entries = [];
}

class _SettingsAboutApplicationCupertino extends State<SettingsAboutApplicationCupertino> {
  late final Future<List<_PackageLicenses>> _licensesFuture;
  PackageInfoModel? _packageInfo;

  @override
  void initState() {
    super.initState();
    _licensesFuture = _loadLicenses();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await getIt.get<Utils>().packageInfo();
    if (!mounted) return;
    setState(() => _packageInfo = info);
  }

  /// Собирает поток `LicenseRegistry.licenses` в список пакетов,
  /// отсортированный по имени; каждый пакет держит свои `LicenseEntry`.
  Future<List<_PackageLicenses>> _loadLicenses() async {
    final byPackage = <String, _PackageLicenses>{};
    await for (final license in LicenseRegistry.licenses) {
      for (final packageName in license.packages) {
        byPackage.putIfAbsent(packageName, () => _PackageLicenses(packageName)).entries.add(license);
      }
    }
    final result = byPackage.values.toList()..sort((a, b) => a.packageName.toLowerCase().compareTo(b.packageName.toLowerCase()));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenSettingsAboutApplication;
    return CupertinoPageScaffold(
      backgroundColor: ThemesCupertino.groupedBackground,
      navigationBar: AppCupertinoNavigationBar(
        child: CupertinoNavigationBar(
          automaticBackgroundVisibility: false,
          backgroundColor: ThemesCupertino.groupedBackground,
          middle: Text(t.aboutApplication),
        ),
      ),
      child: SafeArea(
        child: FutureBuilder<List<_PackageLicenses>>(
          future: _licensesFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CupertinoActivityIndicator());
            }
            final packages = snapshot.data!;
            return ListView(
              children: [
                _header(context),
                if (packages.isEmpty) _emptySection(context, t.noLicenses) else _licensesSection(context, packages),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final info = _packageInfo;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Text('Iperon', style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle),
          const SizedBox(height: 4),
          Text(
            info == null ? '' : context.t.screenSettingsAboutApplication.version(version: info.appVersion, build: info.appBuildNumber),
            style: CupertinoTheme.of(
              context,
            ).textTheme.tabLabelTextStyle.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context), fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _emptySection(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Center(
        child: Text(text, style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context))),
      ),
    );
  }

  Widget _licensesSection(BuildContext context, List<_PackageLicenses> packages) {
    final t = context.t.screenSettingsAboutApplication;
    return CupertinoListSection.insetGrouped(
      header: Text(t.licenses),
      backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
      decoration: BoxDecoration(
        color: ThemesCupertino.groupedCard.resolveFrom(context),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      children: [
        for (final package in packages)
          CupertinoListTile.notched(
            title: Text(package.packageName),
            additionalInfo: Text(t.licensesCount(n: package.entries.length)),
            trailing: const CupertinoListTileChevron(),
            onTap: () => _openLicenseDetail(context, package),
          ),
      ],
    );
  }

  void _openLicenseDetail(BuildContext context, _PackageLicenses package) {
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute<void>(
        title: package.packageName,
        builder: (_) => _LicenseDetailScreen(package: package),
      ),
    );
  }
}

/// Детальный экран с текстом лицензий одного пакета.
class _LicenseDetailScreen extends StatelessWidget {
  const _LicenseDetailScreen({required this.package});

  final _PackageLicenses package;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: ThemesCupertino.groupedBackground,
      navigationBar: AppCupertinoNavigationBar(
        child: CupertinoNavigationBar(
          automaticBackgroundVisibility: false,
          backgroundColor: ThemesCupertino.groupedBackground,
          middle: Text(package.packageName),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final entry in package.entries) ...[
              for (final paragraph in entry.paragraphs)
                Padding(
                  padding: EdgeInsets.only(
                    left: paragraph.indent == LicenseParagraph.centeredIndent ? 0 : paragraph.indent * 12.0,
                    bottom: 12,
                  ),
                  child: Text(
                    paragraph.text,
                    textAlign: paragraph.indent == LicenseParagraph.centeredIndent ? TextAlign.center : TextAlign.start,
                    style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: 13, height: 1.35),
                  ),
                ),
              Container(height: 1, margin: const EdgeInsets.symmetric(vertical: 16), color: CupertinoColors.separator.resolveFrom(context)),
            ],
          ],
        ),
      ),
    );
  }
}
