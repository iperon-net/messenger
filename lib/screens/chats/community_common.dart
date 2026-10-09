import 'dart:ui' show ImageFilter;

import 'package:flutter/widgets.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../chats/coordinates.dart';
import '../../di.dart';
import '../../utils.dart';

import '../../components.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'chat_common.dart';

/// Общее для страницы сообщества (`community_{cupertino,material}.dart`), см.
/// «Сообщества» в docs/plans/chats-groups-channels.md.

/// Строка чата сообщества: название (канал объявлений — «Объявления») и
/// вторая строка — превью последнего сообщения, если мы участник, иначе число
/// участников (закрытая тема — «· По заявке»).
({String title, String subtitle}) communityChatRow(Translations t, models.Chat chat) {
  final title = chat.announcements ? t.screenChatInfo.announcements : chat.title;
  if (chat.isMember) {
    final preview = ChatTileContent.preview(t, chat);
    if (preview.text.isNotEmpty) {
      return (title: title, subtitle: preview.prefix.isEmpty ? preview.text : '${preview.prefix}: ${preview.text}');
    }
  }
  final count = chatSubtitle(t, chat).text;
  return (
    title: title,
    subtitle: switch (chat.joinMode) {
      models.ChatJoinMode.request => '$count · ${t.screenChatInfo.closedTopic}',
      models.ChatJoinMode.admins => '$count · ${t.screenChatInfo.hiddenTopic}',
      _ => count,
    },
  );
}

/// Шапка страницы сообщества: обложка ([models.Chat.coverPath], без неё —
/// генеративный фон по id) во всю ширину, уходит под панель навигации; внизу
/// на затемнении — аватар, название и число участников белым.
class CommunityCover extends StatelessWidget {
  final models.Chat chat;
  final String subtitle;
  final Color accentColor;
  final Color accentForeground;

  const CommunityCover({super.key, required this.chat, required this.subtitle, required this.accentColor, required this.accentForeground});

  /// Высота обложки без статус-бара (с ним — [heightOf]).
  static const height = 230.0;

  static double heightOf(BuildContext context) => height + MediaQuery.viewPaddingOf(context).top;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightOf(context),
      child: Stack(
        fit: StackFit.expand,
        children: [
          chat.coverPath.isNotEmpty
              ? chatImage(chat.coverPath, fit: BoxFit.cover)
              : ClipRect(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox.square(
                      dimension: 400,
                      child: BoringAvatar(name: '${chat.id}-cover', type: BoringAvatarType.marble, shape: const RoundedRectangleBorder()),
                    ),
                  ),
                ),
          // Только снизу — под текст; кнопки сверху на своих «стёклах»
          // ([CoverGlassButton]), верх обложки остаётся чистым.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x00000000), Color(0x99000000)],
                stops: [0.5, 1],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(64 * 0.28 + 2),
                    border: Border.all(color: const Color(0xFFFFFFFF), width: 2),
                  ),
                  child: ChatAvatar(chat: chat, size: 64, accentColor: accentColor, accentForeground: accentForeground),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFFFFFFFF), height: 1.2),
                      ),
                      if (subtitle.isNotEmpty) Text(subtitle, style: const TextStyle(fontSize: 15, color: Color(0xD9FFFFFF))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Кнопка поверх обложки («назад», «Изменить»): «стекло» — размытие и
/// полупрозрачный тёмный фон, содержимое белое; с иконкой — круг, с текстом —
/// пилюля ([padding]).
class CoverGlassButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final String? label;
  final EdgeInsetsGeometry padding;

  const CoverGlassButton({super.key, required this.child, required this.onTap, this.label, this.padding = EdgeInsets.zero});

  static const size = 36.0;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            height: size,
            constraints: const BoxConstraints(minWidth: size),
            padding: padding,
            alignment: Alignment.center,
            color: const Color(0x4D000000),
            child: IconTheme(
              data: const IconThemeData(color: Color(0xFFFFFFFF), size: 22),
              child: DefaultTextStyle(
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFFFFFFFF)),
                child: child,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Есть контакты заведения (телефон, адрес или координаты).
bool communityHasContacts(models.Chat chat) => chat.phone.isNotEmpty || chat.address.isNotEmpty || chat.latitude != null;

/// Телефон заведения для показа: «+7 926 090-69-96»; не разобрался — как ввели.
String communityPhoneLabel(String phone) {
  final formatted = getIt.get<Utils>().phoneNormalization(phoneNumber: phone).international;
  return formatted.isEmpty ? phone : formatted;
}

/// Позвонить в заведение.
Future<void> callCommunityPhone(String phone) => getIt.get<Utils>().makePhoneCall(phone);

/// Маршрут до заведения [chat] в картах [app]: приложение, а если его нет —
/// сайт карт.
Future<void> openCommunityRoute(models.Chat chat, MapsApp app) async {
  final latitude = chat.latitude;
  final longitude = chat.longitude;
  if (latitude == null || longitude == null) return;
  final uris = routeUris(app, latitude, longitude);
  try {
    if (await launchUrl(uris.app, mode: LaunchMode.externalApplication)) return;
  } catch (_) {
    // Схема не обработана (приложения нет) — дальше сайт.
  }
  await launchUrl(uris.web, mode: LaunchMode.externalApplication);
}

/// Иконка приложения карт (скруглённый квадрат, как на домашнем экране).
class MapsAppIcon extends StatelessWidget {
  final MapsApp app;
  final double size;

  const MapsAppIcon({super.key, required this.app, this.size = 30});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(size * 0.23);
    return Container(
      // Тонкая обводка: у Яндекс Карт иконка на белом и сливается со светлой
      // карточкой.
      foregroundDecoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: const Color(0x33000000), width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Image.asset(
          app == MapsApp.yandex ? 'assets/icons/maps/yandex_maps.png' : 'assets/icons/maps/2gis.png',
          width: size,
          height: size,
        ),
      ),
    );
  }
}

/// Иконки Яндекс Карт и 2ГИС справа у адреса: тап — маршрут до заведения.
class CommunityRouteButtons extends StatelessWidget {
  final models.Chat chat;

  const CommunityRouteButtons({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenChatInfo;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final app in MapsApp.values)
          Semantics(
            button: true,
            label: app == MapsApp.yandex ? t.routeYandex : t.route2gis,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => openCommunityRoute(chat, app),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: MapsAppIcon(app: app, size: 32),
              ),
            ),
          ),
      ],
    );
  }
}
