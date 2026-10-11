import 'dart:async';
import 'dart:io';

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
///   • при промахе — **один** запрос `PROFILE` за сессию на пользователя,
///     общий для всех его строк ([_UserAvatarState._requests]); ответ
///     (скачивание + привязка `avatarCdnID`) обрабатывает и `API._handleMessage`,
///     а мы подхватываем аватар из того же (дедуплицируемого) `download`. Запрос уходит только для видимых строк с известным [userID],
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
  // Запрос PROFILE (и скачивание аватара) по userID (hex) — один на сессию и
  // общий для всех строк этого пользователя: в «Звонках» один человек занимает
  // много строк подряд, и каждая должна получить картинку, а не только первая.
  // Прокрутка туда-обратно (пересоздание строк) повторных запросов не шлёт.
  static final Map<String, Future<File?>> _requests = {};

  // Ответа нет (стрим не поднят / нет сети) — забываем запрос, чтобы строка,
  // построенная позже, спросила снова.
  static const _requestTimeout = Duration(seconds: 30);

  final _cdn = getIt.get<CDNManager>();
  final _repositories = getIt.get<Repositories>();
  final _logger = getIt.get<Logger>();

  Uint8List? _bytes;

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
      setState(() => _bytes = null);
      _load();
    }
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
        if (file != null) {
          await _show(userID, file);
          return;
        }
      }
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
    }

    // 2. Промах кэша — ждём общий на пользователя запрос PROFILE.
    final hex = getIt.get<Utils>().bytesToHex(userID);
    final file = await _requests.putIfAbsent(hex, () => _requestProfile(hex, userID));
    if (file != null) await _show(userID, file);
  }

  Future<void> _show(Uint8List userID, File file) async {
    if (!mounted || !_sameUser(widget.userID, userID)) return;
    try {
      final bytes = await file.readAsBytes();
      if (!mounted || !_sameUser(widget.userID, userID)) return;
      setState(() => _bytes = bytes);
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
    }
  }

  /// PROFILE-запрос по [userID]: файл аватара или `null` (аватара нет / не
  /// дождались ответа). Ответ (привязку `avatarCdnID`) пишет и
  /// `API._handleMessage`; `download` дедуплицируется, так что скачивание одно.
  static Future<File?> _requestProfile(String hex, Uint8List userID) async {
    final api = getIt.get<API>();
    // Слушаем ДО отправки, чтобы не пропустить ответ (broadcast-стрим).
    final response = api
        .on(MessageType.PROFILE)
        .map(Profile_Response.fromBuffer)
        .firstWhere((response) => listEquals(response.userID, userID))
        .timeout(_requestTimeout);

    unawaited(
      api.sendEncoded(MessageType.PROFILE, Profile_Request(userID: userID).writeToBuffer()).catchError((
        Object error,
        StackTrace stackTrace,
      ) {
        getIt.get<Logger>().handle(error, stackTrace);
      }),
    );

    try {
      final profile = await response;
      if (!profile.hasAvatar()) return null;
      return await getIt.get<CDNManager>().download(cdn: models.CDN.fromProto(profile.avatar));
    } on TimeoutException {
      _requests.remove(hex);
      return null;
    } catch (error, stackTrace) {
      getIt.get<Logger>().handle(error, stackTrace);
      _requests.remove(hex);
      return null;
    }
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
