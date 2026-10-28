import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:livekit_client/livekit_client.dart';

import '../../api.dart';
import '../../auth.dart';
import '../../calls.dart';
import '../../cdn.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import '../../peer_names.dart';
import '../../models.dart' as models;
import '../../protobuf.dart';
import '../../protobuf/protos/chats_v1.pb.dart' as pb;
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

  /// Видео участника группового звонка (плитка сетки).
  VideoTrack? remoteVideoTrackOf(List<int> userID) => _calls.remoteVideoTrackOf(userID);

  /// Имена и аватары участников группового звонка (hex userID) — разрешаются
  /// один раз на участника.
  final _names = <String, String>{};
  final _avatars = <String, Uint8List>{};
  final _resolving = <String>{};

  void initialization() {
    emit(_fromSnapshot(_calls.snapshot, Status.success));
    _sub = _calls.snapshots.listen((snapshot) => emit(_fromSnapshot(snapshot, Status.success)));
    _resolveIdentity(_calls.snapshot.remoteUserID);
    unawaited(_resolveSelf());
  }

  /// Свой аватар из `myProfile` (без сети — из кэша) для своей плитки.
  Future<void> _resolveSelf() async {
    try {
      final profile = await repositories.myProfile.getByUserID(userID: getIt.get<Auth>().session.userID);
      Uint8List? avatar;
      final cdnID = profile.avatarCdnID;
      if (cdnID != null && cdnID.isNotEmpty) {
        avatar = await (await cdnManager.cachedFile(Uint8List.fromList(cdnID)))?.readAsBytes();
      }
      if (isClosed) return;
      if (avatar != null) emit(state.copyWith(selfAvatarBytes: avatar));
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
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
    remoteMicMuted: s.remoteMicMuted,
    remoteVideoOff: s.remoteVideoOff,
    remoteOnHold: s.remoteOnHold,
    reconnecting: s.reconnecting,
    remoteReconnecting: s.remoteReconnecting,
    endReason: s.endReason,
    debug: s.debug,
    connectedAt: s.connectedAt,
    quality: s.quality,
    mediaEpoch: s.mediaEpoch,
    encryption: s.encryption,
    sas: s.sas,
    participants: _participants(s.participants),
  );

  List<CallParticipantView> _participants(List<CallParticipant> participants) {
    final views = <CallParticipantView>[];
    for (final participant in participants) {
      final hex = utils.bytesToHex(Uint8List.fromList(participant.userID));
      if (!_names.containsKey(hex)) unawaited(_resolveParticipant(hex, participant.userID));
      views.add(
        CallParticipantView(
          userID: participant.userID,
          name: _names[hex] ?? '',
          avatarBytes: _avatars[hex],
          joined: participant.joined,
          micMuted: participant.micMuted,
          videoOff: participant.videoOff,
          speaking: participant.speaking,
        ),
      );
    }
    return views;
  }

  /// Имя (общее правило) и аватар из кэша — для плитки участника.
  Future<void> _resolveParticipant(String hex, List<int> userID) async {
    if (!_resolving.add(hex)) return;
    final name = await peerDisplayName(userID);
    Uint8List? avatar;
    try {
      final profile = await repositories.profiles.getByUserID(userID: userID);
      final avatarCdnID = profile.avatarCdnID;
      if (avatarCdnID != null && avatarCdnID.isNotEmpty) {
        avatar = await (await cdnManager.cachedFile(Uint8List.fromList(avatarCdnID)))?.readAsBytes();
      }
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
    if (isClosed) return;
    _names[hex] = name;
    if (avatar != null) _avatars[hex] = avatar;
    emit(_fromSnapshot(_calls.snapshot, state.status));
  }

  /// Позвать человека в звонок (см. [Calls.invite]).
  Future<CallInviteResult> invite(List<int> userID) => _calls.invite(userID);

  /// Кого можно позвать: [callCandidates] без тех, кто уже в звонке.
  Future<List<({Uint8List userID, String name})>> inviteCandidates() =>
      callCandidates(exclude: [state.remoteUserID, for (final participant in state.participants) participant.userID]);

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

      // Общее правило имени (контакт → профиль → @username → номер).
      final lines = await peerNameLines(userID, fresh: response);
      if (isClosed) return;
      emit(state.copyWith(displayName: lines.join(' '), nameLines: lines));
      _pushNowPlaying();

      if (response.hasAvatar()) {
        try {
          final file = await cdnManager.download(cdn: models.CDN.fromProto(response.avatar));
          if (isClosed) return;
          emit(state.copyWith(avatarBytes: await file.readAsBytes()));
          _pushNowPlaying();
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

    final lines = await peerNameLines(userID);
    if (isClosed) return;
    final name = lines.join(' ');
    var next = name.isNotEmpty ? state.copyWith(displayName: name, nameLines: lines) : state;
    // copyWith(avatarBytes: null) не отличает «не менять» от «обнулить», поэтому
    // подставляем аватар только когда он реально есть в кэше.
    if (avatarBytes != null) next = next.copyWith(avatarBytes: avatarBytes);
    emit(next);
    _pushNowPlaying();

    await sendFuture;
  }

  /// iOS: отдаёт имя/аватар собеседника в Now Playing, чтобы шапка системного
  /// пикера аудио-маршрутов показывала имя вместо «Нет аудио» (см.
  /// [Calls.setIosNowPlaying]). Зовётся после каждого разрешения имени/аватара;
  /// no-op при пустом имени и вне iOS (внутри [Calls.setIosNowPlaying]).
  void _pushNowPlaying() {
    if (state.displayName.isEmpty) return;
    unawaited(_calls.setIosNowPlaying(title: state.displayName, subtitle: t.screenCall.title, artwork: state.avatarBytes));
  }

  Future<void> accept() => _calls.accept();
  Future<void> reject() => _calls.reject();
  Future<void> hangup() => _calls.hangup();
  Future<void> toggleMic() => _calls.toggleMic();
  Future<void> toggleCamera() => _calls.toggleCamera();
  Future<void> enableVideo() => _calls.enableVideo();
  Future<void> pauseVideoForBackground() => _calls.pauseVideoForBackground();
  Future<void> resumeVideoAfterBackground() => _calls.resumeVideoAfterBackground();
  Future<void> toggleSpeaker() => _calls.toggleSpeaker();
  Future<void> switchCamera() => _calls.switchCamera();

  @override
  Future<void> close() {
    _sub?.cancel();
    _profileSub?.cancel();
    return super.close();
  }
}

/// Кому можно позвонить: собеседники личных чатов (свежие сверху) и контакты из
/// Iperon по алфавиту, кроме нас, «Iperon» и [exclude].
Future<List<({Uint8List userID, String name})>> callCandidates({Iterable<List<int>> exclude = const []}) async {
  final utils = getIt.get<Utils>();
  final repositories = getIt.get<Repositories>();
  final self = getIt.get<Auth>().session.userID;
  final skip = <String>{
    utils.bytesToHex(Uint8List.fromList(self)),
    models.systemUserID,
    for (final userID in exclude) utils.bytesToHex(Uint8List.fromList(userID)),
  };
  final result = <({Uint8List userID, String name})>[];
  final dialogs =
      (await repositories.chats.dialogs(userID: self)).where((dialog) => dialog.type == pb.ChatType.CHAT_TYPE_PRIVATE.value).toList()
        ..sort((a, b) => b.topMessageDate.compareTo(a.topMessageDate));
  for (final dialog in dialogs) {
    final peer = dialog.peerUserID;
    if (peer == null || !skip.add(utils.bytesToHex(peer))) continue;
    result.add((userID: peer, name: await peerDisplayName(peer)));
  }
  final contacts = <({Uint8List userID, String name})>[];
  for (final contact in await repositories.contacts.getAll()) {
    final userID = contact.userID;
    if (userID == null || userID.isEmpty || !skip.add(utils.bytesToHex(Uint8List.fromList(userID)))) continue;
    contacts.add((userID: Uint8List.fromList(userID), name: await peerDisplayName(userID)));
  }
  contacts.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  return [...result, ...contacts].where((user) => user.name.isNotEmpty).toList(growable: false);
}
