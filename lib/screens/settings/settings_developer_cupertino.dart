import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../themes.dart';
import '../../i18n/translations.g.dart';
import '../../components.dart';
import '../../di.dart';
import '../../logger.dart';
import 'developer_export_logs.dart';

/// Скрытый экран «Разработчик». Открывается 5 быстрыми тапами по кнопке
/// «Настройки» в нижнем таб-баре (см. `HomeCupertino`), в обычном меню настроек
/// не показан. Пока один раздел — «Логи»; в будущем добавятся другие
/// диагностические разделы.
class SettingsDeveloperCupertino extends StatelessWidget {
  const SettingsDeveloperCupertino({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: ThemesCupertino.groupedBackground,
      navigationBar: AppCupertinoNavigationBar(
        child: CupertinoNavigationBar(
          automaticBackgroundVisibility: false,
          backgroundColor: ThemesCupertino.groupedBackground,
          middle: Text(context.t.screenDeveloper.developer),
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            CupertinoListSection.insetGrouped(
              backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
              decoration: BoxDecoration(
                color: ThemesCupertino.groupedCard.resolveFrom(context),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              children: [
                CupertinoListTileIcon(
                  title: Text(context.t.screenDeveloper.logs),
                  color: const Color(0xFF8E8E93),
                  icon: FontAwesomeIcons.fileLines,
                  onTab: () async => context.go("/settings/developer/logs"),
                  isTrailing: true,
                ),
                CupertinoListTileIcon(
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
                if (kDebugMode)
                  CupertinoListTileIcon(
                    title: Text(context.t.screenDeveloper.callPreview),
                    color: const Color(0xFF007AFF),
                    icon: FontAwesomeIcons.phone,
                    onTab: () async => context.go("/settings/developer/call_preview"),
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
