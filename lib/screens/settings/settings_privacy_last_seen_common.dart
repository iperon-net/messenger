import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';

import '../../auth.dart';
import '../../cdn.dart';
import '../../components.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../repositories/repositories.dart';
import '../../utils.dart';

/// Своё имя и аватар для превью — из локального профиля, без сети.
typedef _Self = ({String name, String placeholder, Uint8List? avatar});

/// Превью «Времени захода» (`settings_privacy_last_seen_{cupertino,material}.dart`):
/// шапка моего чата, как её видят другие, на текущих обоях. «Мои контакты» —
/// две шапки (контакты видят «в сети», остальные — «был(а) недавно»), «Все» и
/// «Никто» — одна. Исключения не показываем: они про отдельных людей.
class LastSeenPrivacyPreview extends StatefulWidget {
  final CallsPrivacyAudience audience;
  final bool dark;
  final Color card;
  final Color text;
  final Color secondary;
  final Color online;

  const LastSeenPrivacyPreview({
    super.key,
    required this.audience,
    required this.dark,
    required this.card,
    required this.text,
    required this.secondary,
    required this.online,
  });

  @override
  State<LastSeenPrivacyPreview> createState() => _LastSeenPrivacyPreviewState();
}

class _LastSeenPrivacyPreviewState extends State<LastSeenPrivacyPreview> {
  late final Future<_Self> _self = _load();

  static Future<_Self> _load() async {
    final repositories = getIt.get<Repositories>();
    final session = getIt.get<Auth>().session;
    var name = '';
    var placeholder = '';
    Uint8List? avatar;
    try {
      final profile = await repositories.myProfile.getByUserID(userID: session.userID);
      final user = await repositories.users.getBySession(session: session);
      // Плейсхолдер — тот же «отпечаток», что на экране «Мой профиль».
      placeholder = getIt.get<Utils>().phoneNormalization(phoneNumber: user.phoneNumber).international;
      name = '${profile.fistName} ${profile.lastName}'.trim();
      if (name.isEmpty) name = profile.username.isNotEmpty ? '@${profile.username}' : placeholder;
      final cdnID = profile.avatarCdnID;
      if (cdnID != null && cdnID.isNotEmpty) {
        final file = await getIt.get<CDNManager>().cachedFile(Uint8List.fromList(cdnID));
        avatar = await file?.readAsBytes();
      }
    } catch (_) {
      // Превью — только для вида: без профиля покажем заглушку.
    }
    return (name: name, placeholder: placeholder, avatar: avatar);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.sessionsPrivacyAndSecurity;
    final settings = context.select((CommonCubit cubit) => cubit.state.settingsDevice);
    final online = context.t.screenChat.online;
    final recently = context.t.screenChat.lastSeenRecently;
    final rows = switch (widget.audience) {
      CallsPrivacyAudience.everybody => [(t.lastSeenPreviewAll, online, true)],
      CallsPrivacyAudience.nobody => [(t.lastSeenPreviewAll, recently, false)],
      CallsPrivacyAudience.contacts => [(t.lastSeenPreviewContacts, online, true), (t.lastSeenPreviewOthers, recently, false)],
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
            child: FutureBuilder<_Self>(
              future: _self,
              builder: (context, snapshot) {
                final self = snapshot.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final (label, status, active) in rows) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 4, 4, 6),
                        child: _Caption(label: label, dark: widget.dark),
                      ),
                      _header(self, status, active),
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

  Widget _header(_Self? self, String status, bool active) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(color: widget.card, borderRadius: BorderRadius.circular(12)),
    child: Row(
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: widget.text),
              ),
              const SizedBox(height: 2),
              Text(status, style: TextStyle(fontSize: 14, color: active ? widget.online : widget.secondary)),
            ],
          ),
        ),
      ],
    ),
  );
}

/// Подпись над шапкой — плашкой, как даты в чате, чтобы читалась на обоях.
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
