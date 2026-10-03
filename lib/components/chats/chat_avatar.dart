import 'package:flutter/widgets.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models.dart' as models;

/// Аватар строки списка чатов. Пока только генеративный плейсхолдер по id чата
/// (реальные аватарки чатов появятся вместе с серверной частью); «Избранное» —
/// закладка на цвете темы, сообщество — скруглённый квадрат (отличает его от
/// групп и каналов, как форумы в Telegram).
class ChatAvatar extends StatelessWidget {
  final models.Chat chat;
  final double size;

  /// Цвет фона «Избранного» (primary темы — свой у Cupertino и Material).
  final Color accentColor;

  const ChatAvatar({super.key, required this.chat, required this.accentColor, this.size = 56});

  @override
  Widget build(BuildContext context) {
    if (chat.isSelf) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: FaIcon(FontAwesomeIcons.solidBookmark, size: size * 0.4, color: const Color(0xFFFFFFFF)),
      );
    }

    final shape = chat.type == models.ChatType.community
        ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(size * 0.28))
        : const CircleBorder();

    return SizedBox(
      width: size,
      height: size,
      child: BoringAvatar(
        name: chat.id,
        type: chat.type == models.ChatType.private ? BoringAvatarType.beam : BoringAvatarType.marble,
        shape: shape,
      ),
    );
  }
}
