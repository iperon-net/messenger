import 'package:flutter/widgets.dart';

import '../../components.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;

/// Общее для «Тем для чатов» (`settings_chat_themes_{cupertino,material}.dart`):
/// превью с пузырями, лента узоров и палитра цветов.

String chatWallpaperPatternTitle(Translations t, String pattern) => switch (pattern) {
  'chat' => t.screenChatThemes.patternChat,
  'space' => t.screenChatThemes.patternSpace,
  'nature' => t.screenChatThemes.patternNature,
  'music' => t.screenChatThemes.patternMusic,
  'geometry' => t.screenChatThemes.patternGeometry,
  'food' => t.screenChatThemes.patternFood,
  _ => t.screenChatThemes.patternNone,
};

/// Превью: обои и пара пузырей в том же оформлении, что в окне чата.
class ChatThemePreview extends StatelessWidget {
  final String pattern;
  final int colorIndex;
  final bool dark;
  final MessageBubbleStyle style;

  const ChatThemePreview({super.key, required this.pattern, required this.colorIndex, required this.dark, required this.style});

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenChatThemes;
    final now = DateTime.now();
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 230,
        child: Stack(
          children: [
            Positioned.fill(
              child: ChatWallpaper(pattern: pattern, colorIndex: colorIndex, dark: dark),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 12,
              // Превью не реагирует на тапы — пузыри только для вида.
              child: IgnorePointer(
                child: Column(
                  children: [
                    MessageBubble(
                      message: models.Message(
                        id: 'preview-in',
                        chatID: 'preview',
                        text: t.previewIncoming,
                        date: now.subtract(const Duration(minutes: 2)),
                      ),
                      style: style,
                      tail: true,
                      showSender: false,
                      onLongPress: () {},
                    ),
                    const SizedBox(height: 8),
                    MessageBubble(
                      message: models.Message(
                        id: 'preview-out',
                        chatID: 'preview',
                        text: t.previewOutgoing,
                        outgoing: true,
                        status: models.MessageStatus.read,
                        date: now,
                        reply: models.MessageReply(messageID: 'preview-in', senderName: t.previewName, text: t.previewIncoming),
                      ),
                      style: style,
                      tail: true,
                      showSender: false,
                      onLongPress: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Лента узоров: миниатюры с текущим цветом, выбранная — в рамке.
class ChatPatternStrip extends StatelessWidget {
  final String selected;
  final int colorIndex;
  final bool dark;
  final Color accent;
  final TextStyle labelStyle;
  final ValueChanged<String> onSelected;

  const ChatPatternStrip({
    super.key,
    required this.selected,
    required this.colorIndex,
    required this.dark,
    required this.accent,
    required this.labelStyle,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: chatWallpaperPatterns.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final pattern = chatWallpaperPatterns[index];
          final isSelected = pattern == selected;
          return GestureDetector(
            onTap: () => onSelected(pattern),
            child: SizedBox(
              width: 84,
              child: Column(
                children: [
                  Container(
                    width: 84,
                    height: 120,
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: isSelected ? accent : const Color(0x00000000), width: 2.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: ChatWallpaper(pattern: pattern, colorIndex: colorIndex, dark: dark, tileScale: 0.5),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    chatWallpaperPatternTitle(t, pattern),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: isSelected ? labelStyle.copyWith(color: accent, fontWeight: FontWeight.w600) : labelStyle,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Палитра: кружки с градиентом обоев под текущую тему, выбранный — в кольце.
class ChatColorPalette extends StatelessWidget {
  final int selected;
  final bool dark;
  final Color accent;
  final ValueChanged<int> onSelected;

  const ChatColorPalette({super.key, required this.selected, required this.dark, required this.accent, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (var i = 0; i < chatWallpaperColorCount; i++)
            GestureDetector(
              onTap: () => onSelected(i),
              child: Container(
                width: 46,
                height: 46,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: i == selected ? accent : const Color(0x00000000), width: 2.5),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ChatWallpaperColors.of(i, dark: dark).top,
                        ChatWallpaperColors.of(i, dark: dark).bottom,
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
