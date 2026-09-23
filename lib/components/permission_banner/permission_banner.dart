import 'dart:io';

import 'package:flutter/widgets.dart';

import 'permission_banner_cupertino.dart';
import 'permission_banner_material.dart';

export 'permission_banner_cupertino.dart';
export 'permission_banner_material.dart';

/// Мягкий, закрываемый баннер-объяснение перед выдачей системного разрешения
/// (контакты, микрофон, уведомления и т.п.). Не блокирует экран: под ним
/// остаётся остальной контент, а сам баннер показывается лишь пока разрешение не
/// выдано и пользователь его не закрыл (условие показа — на стороне вызывающего).
///
/// Нативный вид на каждой платформе: Cupertino — закруглённая цветная подложка
/// тоном акцентного `primaryColor`; Material — `Card` в тонах
/// `secondaryContainer`. Ветвление по [Platform.isIOS] — как у остальных парных
/// компонентов (см. `toolbar_attachments`).
///
/// Использовать в контактах, звонках и чатах для единого объяснения доступа.
class PermissionBanner extends StatelessWidget {
  /// Иконка HugeIcons (`HugeIcons.strokeRounded*`) — сырые данные пути.
  final List<List<dynamic>> icon;
  final String title;
  final String message;

  /// Подпись основной кнопки («Разрешить доступ») и её обработчик — обычно
  /// системный запрос или переход в настройки.
  final String actionLabel;
  final VoidCallback onAction;

  /// Закрытие баннера (крестик).
  final VoidCallback onDismiss;

  /// Подпись крестика (тултип/accessibility) — используется только на Material.
  final String? dismissTooltip;

  const PermissionBanner({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    required this.onDismiss,
    this.dismissTooltip,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? PermissionBannerCupertino(
            icon: icon,
            title: title,
            message: message,
            actionLabel: actionLabel,
            onAction: onAction,
            onDismiss: onDismiss,
          )
        : PermissionBannerMaterial(
            icon: icon,
            title: title,
            message: message,
            actionLabel: actionLabel,
            onAction: onAction,
            onDismiss: onDismiss,
            dismissTooltip: dismissTooltip,
          );
  }
}
