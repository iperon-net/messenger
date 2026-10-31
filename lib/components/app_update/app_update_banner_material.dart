import 'package:hugeicons/hugeicons.dart';
import 'package:material_ui/material_ui.dart';

import '../../app_update.dart';
import '../../i18n/translations.g.dart';
import '../permission_banner/permission_banner_material.dart';

/// Баннер «Доступна версия» над списком чатов (Android, APK с сайта —
/// [AppUpdates]). «Обновить» качает APK в приложении с прогрессом в баннере и
/// показывает системное окно установки; без sha256 в манифесте и при ошибке —
/// ссылка в браузере.
class AppUpdateBannerMaterial extends StatelessWidget {
  const AppUpdateBannerMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    final updates = AppUpdates.instance;
    return ValueListenableBuilder<AppUpdateOffer?>(
      valueListenable: updates.available,
      builder: (context, offer, _) {
        if (offer == null) return const SizedBox.shrink();
        return ValueListenableBuilder<double?>(
          valueListenable: updates.download,
          builder: (context, progress, _) {
            final t = context.t.appUpdate;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: PermissionBannerMaterial(
                icon: HugeIcons.strokeRoundedDownload04,
                title: t.bannerTitle(version: offer.version),
                message: progress == null ? t.bannerText : t.downloading(percent: (progress * 100).round()),
                actionLabel: progress == null ? t.button : context.t.common.cancel,
                onAction: progress == null ? () => _update(context, offer) : updates.cancelDownload,
                onDismiss: updates.dismiss,
                dismissTooltip: context.t.common.notNow,
                progress: progress,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _update(BuildContext context, AppUpdateOffer offer) async {
    final updates = AppUpdates.instance;
    if (!updates.canInstallInApp(offer)) return updates.openInBrowser();
    final t = context.t.appUpdate;

    if (await updates.onMobileNetwork()) {
      if (!context.mounted) return;
      final size = offer.size == null ? '~70' : '${(offer.size! / (1024 * 1024)).round()}';
      final ok = await _confirm(context, t.mobileTitle, t.mobileText(size: size), t.mobileDownload);
      if (!ok) return;
    }

    if (!await updates.canInstallPackages()) {
      if (!context.mounted) return;
      final ok = await _confirm(context, t.permissionTitle, t.permissionText, context.t.componentsCamera.openSettings);
      if (!ok || !await updates.requestInstallPermission()) return;
    }

    final result = await updates.downloadAndInstall();
    if (result != AppUpdateInstallResult.failed || !context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.failed),
        action: SnackBarAction(label: t.openInBrowser, onPressed: updates.openInBrowser),
      ),
    );
  }

  Future<bool> _confirm(BuildContext context, String title, String text, String action) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(context.t.common.cancel)),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(action)),
        ],
      ),
    );
    return result ?? false;
  }
}
