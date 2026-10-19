import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth.dart';
import '../../components.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../repositories/repositories.dart';

/// Превью «Пересылки сообщений» (`settings_privacy_forwards_{cupertino,material}.dart`):
/// моё сообщение, пересланное кому-то, — как его увидит получатель, на текущих
/// обоях чата. При «Никто» под пузырём — «Аккаунт скрыт пользователем», как
/// при тапе по «Переслано от …».
class ForwardsPrivacyPreview extends StatefulWidget {
  final bool hidden;
  final bool dark;
  final MessageBubbleStyle style;

  const ForwardsPrivacyPreview({super.key, required this.hidden, required this.dark, required this.style});

  @override
  State<ForwardsPrivacyPreview> createState() => _ForwardsPrivacyPreviewState();
}

class _ForwardsPrivacyPreviewState extends State<ForwardsPrivacyPreview> {
  /// Своё имя из локального профиля (пусто — пример из «Тем для чатов»).
  late final Future<String> _name = _selfName();

  static Future<String> _selfName() async {
    try {
      final profile = await getIt.get<Repositories>().myProfile.getByUserID(userID: getIt.get<Auth>().session.userID);
      return '${profile.fistName} ${profile.lastName}'.trim();
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final settings = context.select((CommonCubit cubit) => cubit.state.settingsDevice);
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        children: [
          Positioned.fill(
            child: ChatWallpaper(
              pattern: chatWallpaperPatternOf(settings.chatWallpaper),
              colorIndex: settings.chatWallpaperColor,
              intensity: settings.chatWallpaperIntensity,
              dark: widget.dark,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            // Превью не реагирует на тапы — пузырь только для вида.
            child: IgnorePointer(
              child: FutureBuilder<String>(
                future: _name,
                builder: (context, snapshot) {
                  final name = snapshot.data ?? '';
                  return Column(
                    children: [
                      MessageBubble(
                        message: models.Message(
                          id: 'preview-forward',
                          chatID: 'preview',
                          text: t.sessionsPrivacyAndSecurity.forwardsPreviewText,
                          date: DateTime.now().subtract(const Duration(minutes: 5)),
                          forward: models.MessageForward(name: name.isEmpty ? t.screenChatThemes.previewName : name, hidden: widget.hidden),
                        ),
                        style: widget.style,
                        tail: true,
                        showSender: false,
                        onLongPress: () {},
                      ),
                      if (widget.hidden)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: DecoratedBox(
                            decoration: BoxDecoration(color: widget.style.pill, borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              child: Text(t.screenChat.forwardHidden, style: TextStyle(fontSize: 13, color: widget.style.pillText)),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
