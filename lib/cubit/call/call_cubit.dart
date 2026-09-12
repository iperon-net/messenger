import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:livekit_client/livekit_client.dart';

import '../../api.dart';
import '../../calls.dart';
import '../../cdn.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../models.dart' as models;
import '../../protobuf.dart';
import '../../repositories/repositories.dart';
import '../../utils.dart';

import 'call_state.dart';

/// Кубит экрана звонка. Тонкая обёртка над синглтоном [Calls]: подписывается на
/// [Calls.snapshots], переводит снимок в [CallState] и проксирует действия
/// пользователя (принять/отклонить/завершить, mute и т.д.). Видео-дорожки
/// LiveKit берутся прямо из сервиса — они переживают навигацию между экранами.
///
/// Дополнительно подтягивает «личность» собеседника (имя + аватар): мгновенно из
/// локального кэша профилей и, для незнакомых (входящий от не-контакта), из
/// стрима `PROFILE` — тем же путём, что и [ProfileCubit].
class CallCubit extends Cubit<CallState> {
  CallCubit() : super(const CallState());

  final logger = getIt.get<Logger>();
  final api = getIt.get<API>();
  final utils = getIt.get<Utils>();
  final repositories = getIt.get<Repositories>();
  final cdnManager = getIt.get<CDNManager>();
  final _calls = getIt.get<Calls>();

  StreamSubscription<CallSnapshot>? _sub;
  StreamSubscription<Uint8List>? _profileSub;

  VideoTrack? get localVideoTrack => _calls.localVideoTrack;
  VideoTrack? get remoteVideoTrack => _calls.remoteVideoTrack;

  void initialization() {
    emit(_fromSnapshot(_calls.snapshot, Status.success));
    _sub = _calls.snapshots.listen((snapshot) => emit(_fromSnapshot(snapshot, Status.success)));
    _resolveIdentity(_calls.snapshot.remoteUserID);
  }

  CallState _fromSnapshot(CallSnapshot s, Status status) => state.copyWith(
    status: status,
    callStatus: s.status,
    callId: s.callId,
    remoteUserID: s.remoteUserID,
    video: s.video,
    micMuted: s.micMuted,
    cameraOff: s.cameraOff,
    speakerOn: s.speakerOn,
    endReason: s.endReason,
    debug: s.debug,
    mediaEpoch: s.mediaEpoch,
  );

  /// Разрешает имя/аватар собеседника по [userID]: сперва мгновенно из кэша БД
  /// (+ аватар из CDN-кэша без сети), затем шлёт запрос `PROFILE` и слушает
  /// ответ, чтобы дозаполнить незнакомца.
  Future<void> _resolveIdentity(List<int> userID) async {
    if (userID.isEmpty) return;

    emit(state.copyWith(boringAvatarHash: utils.bytesToHex(Uint8List.fromList(userID))));

    _profileSub = api.on(MessageType.PROFILE).listen((payload) async {
      if (isClosed) return;
      final response = Profile_Response.fromBuffer(payload);
      if (!listEquals(response.userID, userID)) return;

      emit(
        state.copyWith(
          displayName: utils.composeDisplayName(
            firstName: response.firstName,
            lastName: response.lastName,
            phoneNumber: response.phoneNumber,
            username: response.username,
          ),
        ),
      );

      if (response.hasAvatar()) {
        try {
          final file = await cdnManager.download(cdn: models.CDN.fromProto(response.avatar));
          if (isClosed) return;
          emit(state.copyWith(avatarBytes: await file.readAsBytes()));
        } catch (error, stackTrace) {
          logger.handle(error, stackTrace);
        }
      }
    });

    // Кэш из БД + запрос на сервер параллельно (как в ProfileCubit).
    final profileFuture = repositories.profiles.getByUserID(userID: userID);
    final sendFuture = api.sendEncoded(MessageType.PROFILE, Profile_Request(userID: userID).writeToBuffer());

    final profile = await profileFuture;
    if (isClosed) return;

    final phoneNormalization = utils.phoneNormalization(phoneNumber: profile.phoneNumber);
    Uint8List? avatarBytes;
    final avatarCdnID = profile.avatarCdnID;
    if (avatarCdnID != null && avatarCdnID.isNotEmpty) {
      try {
        final file = await cdnManager.cachedFile(Uint8List.fromList(avatarCdnID));
        if (isClosed) return;
        if (file != null) avatarBytes = await file.readAsBytes();
      } catch (error, stackTrace) {
        logger.handle(error, stackTrace);
      }
    }
    if (isClosed) return;

    final name = utils.composeDisplayName(
      firstName: profile.fistName,
      lastName: profile.lastName,
      phoneNumber: phoneNormalization.international,
      username: profile.username,
    );
    var next = name.isNotEmpty ? state.copyWith(displayName: name) : state;
    // copyWith(avatarBytes: null) не отличает «не менять» от «обнулить», поэтому
    // подставляем аватар только когда он реально есть в кэше.
    if (avatarBytes != null) next = next.copyWith(avatarBytes: avatarBytes);
    emit(next);

    await sendFuture;
  }

  Future<void> accept() => _calls.accept();
  Future<void> reject() => _calls.reject();
  Future<void> hangup() => _calls.hangup();
  Future<void> toggleMic() => _calls.toggleMic();
  Future<void> toggleCamera() => _calls.toggleCamera();
  Future<void> toggleSpeaker() => _calls.toggleSpeaker();
  Future<void> switchCamera() => _calls.switchCamera();

  @override
  Future<void> close() {
    _sub?.cancel();
    _profileSub?.cancel();
    return super.close();
  }
}
