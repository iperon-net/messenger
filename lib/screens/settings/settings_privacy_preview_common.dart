import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';

import '../../api.dart';
import '../../auth.dart';
import '../../cdn.dart';
import '../../components.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../protobuf.dart';
import '../../repositories/repositories.dart';
import '../../utils.dart';
import '../profile/profile_common.dart';

/// Свой профиль для превью — из локальной БД и кэша аватаров, без сети.
typedef PrivacySelf = ({String name, String placeholder, Uint8List? avatar, String aboutMe, DateTime? birthDate});

/// Цвета карточки превью — платформа берёт их из своей темы.
class PrivacyPreviewColors {
  final Color card;
  final Color text;
  final Color secondary;
  final Color accent;

  const PrivacyPreviewColors({required this.card, required this.text, required this.secondary, required this.accent});
}

/// Превью приватности на экранах конфиденциальности: моя карточка, как её
/// видят другие, на текущих обоях. «Мои контакты» — две карточки (контакты
/// видят, остальные — нет), «Все» и «Никто» — одна. Исключения не показываем:
/// они про отдельных людей. Что именно видно — решает [details].
class PrivacyProfilePreview extends StatefulWidget {
  final CallsPrivacyAudience audience;
  final bool dark;
  final PrivacyPreviewColors colors;

  /// Содержимое под именем: [visible] — видно ли значение этой аудитории.
  final Widget Function(PrivacySelf? self, bool visible) details;

  const PrivacyProfilePreview({super.key, required this.audience, required this.dark, required this.colors, required this.details});

  @override
  State<PrivacyProfilePreview> createState() => _PrivacyProfilePreviewState();
}

class _PrivacyProfilePreviewState extends State<PrivacyProfilePreview> {
  Future<PrivacySelf> _self = _load();
  StreamSubscription<void>? _changes;

  @override
  void initState() {
    super.initState();
    // Аватар с другого устройства (или после переустановки) привязывается к
    // профилю, только когда приходит MY_PROFILE, — запрашиваем его и
    // перечитываем карточку при изменениях. Без сети — что есть в кэше.
    _changes = getIt
        .get<Repositories>()
        .db
        .onChange(const ['myProfile'], triggerImmediately: false)
        .listen((_) => setState(() => _self = _load()));
    unawaited(getIt.get<API>().sendEncoded(MessageType.MY_PROFILE, MyProfile_Request().writeToBuffer()).catchError((_) {}));
  }

  @override
  void dispose() {
    _changes?.cancel();
    super.dispose();
  }

  static Future<PrivacySelf> _load() async {
    final repositories = getIt.get<Repositories>();
    final session = getIt.get<Auth>().session;
    var name = '';
    var placeholder = '';
    var aboutMe = '';
    DateTime? birthDate;
    Uint8List? avatar;
    try {
      final profile = await repositories.myProfile.getByUserID(userID: session.userID);
      final user = await repositories.users.getBySession(session: session);
      // Плейсхолдер — тот же «отпечаток», что на экране «Мой профиль».
      placeholder = getIt.get<Utils>().phoneNormalization(phoneNumber: user.phoneNumber).international;
      name = '${profile.fistName} ${profile.lastName}'.trim();
      if (name.isEmpty) name = profile.username.isNotEmpty ? '@${profile.username}' : placeholder;
      aboutMe = profile.aboutMe.trim();
      birthDate = profile.birthDate;
      final cdnID = profile.avatarCdnID;
      if (cdnID != null && cdnID.isNotEmpty) {
        final file = await getIt.get<CDNManager>().cachedFile(Uint8List.fromList(cdnID));
        avatar = await file?.readAsBytes();
      }
    } catch (_) {
      // Превью — только для вида: без профиля покажем заглушку.
    }
    return (name: name, placeholder: placeholder, avatar: avatar, aboutMe: aboutMe, birthDate: birthDate);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.sessionsPrivacyAndSecurity;
    final settings = context.select((CommonCubit cubit) => cubit.state.settingsDevice);
    final rows = switch (widget.audience) {
      CallsPrivacyAudience.everybody => [(t.lastSeenPreviewAll, true)],
      CallsPrivacyAudience.nobody => [(t.lastSeenPreviewAll, false)],
      CallsPrivacyAudience.contacts => [(t.lastSeenPreviewContacts, true), (t.lastSeenPreviewOthers, false)],
    };
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
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: FutureBuilder<PrivacySelf>(
              future: _self,
              builder: (context, snapshot) {
                final self = snapshot.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final (label, visible) in rows) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 4, 4, 6),
                        child: _Caption(label: label, dark: widget.dark),
                      ),
                      _card(self, visible),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(PrivacySelf? self, bool visible) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(color: widget.colors.card, borderRadius: BorderRadius.circular(12)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: self?.avatar != null
              ? ClipOval(child: Image.memory(self!.avatar!, width: 40, height: 40, fit: BoxFit.cover, gaplessPlayback: true))
              : BoringAvatar(name: self?.placeholder ?? '', type: BoringAvatarType.ring, shape: const CircleBorder()),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                self?.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: widget.colors.text),
              ),
              const SizedBox(height: 2),
              widget.details(self, visible),
            ],
          ),
        ),
      ],
    ),
  );
}

/// «Время захода»: под именем — «в сети» или «был(а) недавно».
class LastSeenPrivacyPreview extends StatelessWidget {
  final CallsPrivacyAudience audience;
  final bool dark;
  final PrivacyPreviewColors colors;

  const LastSeenPrivacyPreview({super.key, required this.audience, required this.dark, required this.colors});

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenChat;
    return PrivacyProfilePreview(
      audience: audience,
      dark: dark,
      colors: colors,
      details: (self, visible) =>
          Text(visible ? t.online : t.lastSeenRecently, style: TextStyle(fontSize: 14, color: visible ? colors.accent : colors.secondary)),
    );
  }
}

/// «О себе»: под именем — мой текст (пустой — пример) или «не видно».
class AboutMePrivacyPreview extends StatelessWidget {
  final CallsPrivacyAudience audience;
  final bool dark;
  final PrivacyPreviewColors colors;

  const AboutMePrivacyPreview({super.key, required this.audience, required this.dark, required this.colors});

  @override
  Widget build(BuildContext context) {
    final t = context.t.sessionsPrivacyAndSecurity;
    return PrivacyProfilePreview(
      audience: audience,
      dark: dark,
      colors: colors,
      details: (self, visible) {
        if (!visible) {
          return Text(
            t.aboutMePreviewHidden,
            style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: colors.secondary),
          );
        }
        final aboutMe = self?.aboutMe ?? '';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.aboutMe, style: TextStyle(fontSize: 12, color: colors.secondary)),
            Text(
              aboutMe.isEmpty ? t.aboutMePreviewSample : aboutMe,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, color: colors.text),
            ),
          ],
        );
      },
    );
  }
}

/// «День рождения»: под именем — дата (с годом и возрастом или без года, см.
/// [hideYear]; не указана — пример) или «не виден».
class BirthdayPrivacyPreview extends StatelessWidget {
  final CallsPrivacyAudience audience;
  final bool hideYear;
  final bool dark;
  final PrivacyPreviewColors colors;

  const BirthdayPrivacyPreview({super.key, required this.audience, required this.hideYear, required this.dark, required this.colors});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return PrivacyProfilePreview(
      audience: audience,
      dark: dark,
      colors: colors,
      details: (self, visible) {
        if (!visible) {
          return Text(
            t.sessionsPrivacyAndSecurity.birthdayPreviewHidden,
            style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: colors.secondary),
          );
        }
        final birthDate = self?.birthDate ?? DateTime(1995, 5, 14);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.sessionsPrivacyAndSecurity.birthday, style: TextStyle(fontSize: 12, color: colors.secondary)),
            Text(
              profileBirthDateText(t, birthDate, hideYear: hideYear),
              style: TextStyle(fontSize: 14, color: colors.text),
            ),
          ],
        );
      },
    );
  }
}

/// Подпись над карточкой — плашкой, как даты в чате, чтобы читалась на обоях.
class _Caption extends StatelessWidget {
  final String label;
  final bool dark;

  const _Caption({required this.label, required this.dark});

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(color: dark ? const Color(0x66000000) : const Color(0x22000000), borderRadius: BorderRadius.circular(10)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Text(label, style: TextStyle(fontSize: 12, color: dark ? const Color(0xFFFFFFFF) : const Color(0xFF3C3C43))),
    ),
  );
}
