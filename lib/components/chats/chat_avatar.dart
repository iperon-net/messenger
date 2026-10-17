import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models.dart' as models;

/// Аватар строки списка чатов: фото чата ([models.Chat.avatarPath]) или
/// генеративный плейсхолдер по id чата (реальные аватарки чатов появятся вместе
/// с серверной частью); «Избранное» —
/// закладка на цвете темы, сообщество — скруглённый квадрат (отличает его от
/// групп и каналов, как форумы в Telegram).
class ChatAvatar extends StatelessWidget {
  final models.Chat chat;
  final double size;

  /// Цвет фона «Избранного» (primary темы — свой у Cupertino и Material).
  final Color accentColor;

  /// Закладка «Избранного» поверх [accentColor] (тёмная на светлом акценте
  /// тёмной темы).
  final Color accentForeground;

  /// Цвет фона под аватаром: задан — у собеседника «в сети» рисуем зелёную
  /// точку справа внизу с обводкой этим цветом (строки списка чатов).
  final Color? onlineRingColor;

  /// Задан — при автоудалении в чате ([models.Chat.ttlPeriod]) значок таймера
  /// справа внизу на этом цвете (аватар в шапке чата, как в Telegram).
  final Color? ttlBadgeColor;

  const ChatAvatar({
    super.key,
    required this.chat,
    required this.accentColor,
    this.accentForeground = const Color(0xFFFFFFFF),
    this.size = 56,
    this.onlineRingColor,
    this.ttlBadgeColor,
  });

  /// Зелёный «в сети» (systemGreen iOS).
  static const onlineColor = Color(0xFF34C759);

  @override
  Widget build(BuildContext context) {
    final badge = ttlBadgeColor;
    if (badge != null && chat.ttlPeriod > 0) {
      final dot = size * 0.46;
      return SizedBox(
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _avatar(),
            Positioned(
              right: -dot * 0.15,
              bottom: -dot * 0.15,
              child: Container(
                width: dot,
                height: dot,
                decoration: BoxDecoration(color: badge, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: FaIcon(FontAwesomeIcons.stopwatch, size: dot * 0.58, color: const Color(0xFFFFFFFF)),
              ),
            ),
          ],
        ),
      );
    }
    final ring = onlineRingColor;
    final avatar = _avatar();
    if (ring == null || !chat.online || chat.isSelf || chat.type != models.ChatType.private) return avatar;

    final dot = size * 0.28;
    final border = (size * 0.05).clamp(1.5, 3.0);
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: dot,
              height: dot,
              decoration: BoxDecoration(
                color: onlineColor,
                shape: BoxShape.circle,
                border: Border.all(color: ring, width: border),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar() {
    if (chat.isSelf) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: FaIcon(FontAwesomeIcons.solidBookmark, size: size * 0.4, color: accentForeground),
      );
    }

    final shape = chat.type == models.ChatType.community
        ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(size * 0.28))
        : const CircleBorder();

    // Своё фото (созданный в демо чат) — в той же форме, что и плейсхолдер.
    if (chat.avatarPath.isNotEmpty) {
      return ClipPath(
        clipper: ShapeBorderClipper(shape: shape),
        child: chatImage(chat.avatarPath, width: size, height: size, fit: BoxFit.cover, cacheWidth: (size * 3).round()),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: BoringAvatar(
        // Комментарии к посту — аватар канала. Личный — по userID
        // собеседника, как UserAvatar в «Контактах» и «Звонках»: заглушка у
        // человека везде одна.
        name: chat.isThread ? chat.threadOf : (chat.peerUserID.isNotEmpty ? chat.peerUserID : chat.id),
        type: chat.type == models.ChatType.private ? BoringAvatarType.beam : BoringAvatarType.marble,
        shape: shape,
      ),
    );
  }
}

/// Картинка чата (аватар, обложка) по пути: файл с устройства или ассет
/// демо-данных (`assets/…`).
Image chatImage(String path, {double? width, double? height, BoxFit? fit, int? cacheWidth}) => path.startsWith('assets/')
    ? Image.asset(path, width: width, height: height, fit: fit, cacheWidth: cacheWidth)
    : Image.file(File(path), width: width, height: height, fit: fit, cacheWidth: cacheWidth);
