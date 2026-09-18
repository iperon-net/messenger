import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';

import '../api.dart';
import '../cdn.dart';
import '../di.dart';
import '../logger.dart';
import '../models.dart' as models;
import '../protobuf.dart';
import '../repositories/repositories.dart';
import '../utils.dart';

/// Аватар пользователя для строк списка (контакты и т.п.): показывает реальную
/// картинку из контент-адресуемого кэша (по `avatarCdnID` локального профиля), а
/// пока её нет — генеративный BoringAvatar-плейсхолдер (по [placeholderName]).
///
/// Стоимость показа — не картинка (её `CDNManager` кэширует навсегда по `cdnID`),
/// а знание актуального `cdnID`. Поэтому:
///   • cache-hit ([CDNManager.cachedFile]) отдаёт аватар без сети;
///   • при промахе — **один** запрос `PROFILE` за сессию на пользователя
///     ([_requested]); ответ (скачивание + привязка `avatarCdnID`) обрабатывает
///     `API._handleMessage`, а мы подхватываем аватар из того же (дедуплицируемого)
///     `download`. Запрос уходит только для видимых строк с известным [userID],
///     поэтому список без аватарок не порождает пачку из сотен запросов.
///
/// Незарегистрированные контакты ([userID] == null) показывают только плейсхолдер.
class UserAvatar extends StatefulWidget {
  /// Сырые байты userID пользователя; `null` для незарегистрированных.
  final Uint8List? userID;

  /// Имя для генеративного плейсхолдера (hex userID или e164) — стабильный
  /// «отпечаток», чтобы у одного контакта всегда была одна и та же заглушка.
  final String placeholderName;

  final double size;

  const UserAvatar({super.key, required this.userID, required this.placeholderName, this.size = 40});

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  // userID (hex), по которым PROFILE уже запрашивался в этой сессии — прокрутка
  // списка туда-обратно (пересоздание строк) не должна слать повторные запросы.
  static final Set<String> _requested = {};

  final _cdn = getIt.get<CDNManager>();
  final _repositories = getIt.get<Repositories>();
  final _api = getIt.get<API>();
  final _utils = getIt.get<Utils>();
  final _logger = getIt.get<Logger>();

  Uint8List? _bytes;
  StreamSubscription<Uint8List>? _subscription;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(UserAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Элемент списка переиспользован под другой userID — перезагружаем.
    if (!_sameUser(oldWidget.userID, widget.userID)) {
      _subscription?.cancel();
      _subscription = null;
      setState(() => _bytes = null);
      _load();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  bool _sameUser(Uint8List? a, Uint8List? b) {
    if (a == null || b == null) return a == b;
    return listEquals(a, b);
  }

  Future<void> _load() async {
    final userID = widget.userID;
    if (userID == null || userID.isEmpty) return;

    // 1. Уже есть в кэше — показать без сети.
    try {
      final profile = await _repositories.profiles.getByUserID(userID: userID);
      final cdnID = profile.avatarCdnID;
      if (cdnID != null && cdnID.isNotEmpty) {
        final file = await _cdn.cachedFile(Uint8List.fromList(cdnID));
        if (!mounted) return;
        if (file != null) {
          final bytes = await file.readAsBytes();
          if (!mounted) return;
          setState(() => _bytes = bytes);
          return;
        }
      }
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
    }

    // 2. Промах кэша — один запрос PROFILE на пользователя за сессию.
    final hex = _utils.bytesToHex(userID);
    if (!_requested.add(hex)) return;
    _requestProfile(userID);
  }

  void _requestProfile(Uint8List userID) {
    // Слушаем ДО отправки, чтобы не пропустить ответ (broadcast-стрим).
    _subscription = _api.on(MessageType.PROFILE).listen((raw) async {
      final response = Profile_Response.fromBuffer(raw);
      if (!listEquals(response.userID, userID)) return;

      // Наш профиль пришёл — больше слушать нечего.
      _subscription?.cancel();
      _subscription = null;
      if (!response.hasAvatar()) return;

      try {
        final file = await _cdn.download(cdn: models.CDN.fromProto(response.avatar));
        final bytes = await file.readAsBytes();
        if (!mounted) return;
        setState(() => _bytes = bytes);
      } catch (error, stackTrace) {
        _logger.handle(error, stackTrace);
      }
    });

    unawaited(
      _api.sendEncoded(MessageType.PROFILE, Profile_Request(userID: userID).writeToBuffer()).catchError((
        Object error,
        StackTrace stackTrace,
      ) {
        _logger.handle(error, stackTrace);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bytes = _bytes;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: bytes != null
          ? ClipOval(
              child: Image.memory(
                bytes,
                width: widget.size,
                height: widget.size,
                fit: BoxFit.cover,
                gaplessPlayback: true,
                // Декодируем под размер слота, а не в полный битмап крупной
                // аватарки — критично для списка из сотен строк.
                cacheWidth: (widget.size * MediaQuery.devicePixelRatioOf(context)).round(),
                cacheHeight: (widget.size * MediaQuery.devicePixelRatioOf(context)).round(),
              ),
            )
          : AnimatedBoringAvatar(
              name: widget.placeholderName,
              type: BoringAvatarType.beam,
              shape: const CircleBorder(),
              duration: const Duration(milliseconds: 400),
            ),
    );
  }
}
