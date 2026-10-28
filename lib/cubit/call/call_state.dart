import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';

import '../../calls.dart';
import '../../constants.dart';
import '../../models/mapper.dart';

part 'call_state.mapper.dart';

/// Участник группового звонка для экрана: из [CallParticipant] + имя и аватар.
@MappableClass(includeCustomMappers: [Uint8ListMapper()])
class CallParticipantView with CallParticipantViewMappable {
  final List<int> userID;
  final String name;
  final Uint8List? avatarBytes;
  final bool joined;
  final bool micMuted;
  final bool videoOff;
  final bool speaking;

  const CallParticipantView({
    required this.userID,
    this.name = '',
    this.avatarBytes,
    this.joined = true,
    this.micMuted = false,
    this.videoOff = true,
    this.speaking = false,
  });
}

/// Состояние экрана звонка. Зеркалит [CallSnapshot] из сервиса [Calls]
/// (см. [CallCubit]) в mappable-состояние по конвенции проекта, плюс несёт
/// «личность» собеседника (имя/аватар), которую [CallCubit] подтягивает из
/// кэша профилей и стрима `PROFILE`.
@MappableClass(includeCustomMappers: [Uint8ListMapper()])
class CallState with CallStateMappable {
  final Status status;
  final CallStatus callStatus;
  final String callId;
  final List<int> remoteUserID;
  final bool video;
  final bool micMuted;
  final bool cameraOff;
  final bool speakerOn;

  /// Микрофон собеседника выключен (см. [CallSnapshot.remoteMicMuted]).
  final bool remoteMicMuted;

  /// Камера собеседника выключена — показываем аватар вместо застывшего кадра
  /// (см. [CallSnapshot.remoteVideoOff]).
  final bool remoteVideoOff;

  /// Собеседник на другой линии (см. [CallSnapshot.remoteOnHold]).
  final bool remoteOnHold;

  /// Мы переподключаемся к серверу звонков (см. [CallSnapshot.reconnecting]).
  final bool reconnecting;

  /// Собеседник пропал и ждём его возвращения (см. [CallSnapshot.remoteReconnecting]).
  final bool remoteReconnecting;

  final CallEndReason endReason;
  final String debug;

  /// Момент установления соединения ([CallStatus.active]) — точка отсчёта таймера
  /// разговора. `null`, пока звонок не активен. См. [CallSnapshot.connectedAt].
  final DateTime? connectedAt;

  /// Качество соединения собеседника для индикатора. См. [CallSnapshot.quality].
  final CallQuality quality;

  /// Счётчик смен медиа-дорожек (см. [CallSnapshot.mediaEpoch]). Меняется при
  /// появлении/исчезновении локального или удалённого [VideoTrack], чтобы
  /// mappable-равенство состояний различало снимки и UI перестраивал рендереры
  /// — сами `VideoTrack` не value-объекты и не участвуют в сравнении.
  final int mediaEpoch;

  /// Отображаемое имя собеседника (готовая строка с учётом локали) — пусто,
  /// пока не разрешено. Фолбэк на экране — «Звонок». Используется для однострочных
  /// потребителей (CallKit/Now Playing).
  final String displayName;

  /// То же имя, разнесённое по строкам для шапки экрана звонка: RU — фамилия
  /// сверху, имя снизу; остальные локали — наоборот (см. [Utils.composeNameLines]).
  /// 1–2 элемента; пусто, пока имя не разрешено (шапка тогда рисует фолбэк).
  final List<String> nameLines;

  /// Hex userID собеседника — сид для BoringAvatar-плейсхолдера, когда аватара
  /// нет.
  final String boringAvatarHash;

  /// Расшифрованный аватар собеседника для показа. `null`, пока не найден в
  /// кэше/не скачан.
  final Uint8List? avatarBytes;

  /// Состояние сквозного шифрования медиа. См. [CallEncryption].
  final CallEncryption encryption;

  /// SAS — 4 эмодзи для сверки от MITM. Пусто, пока ключ не согласован. См.
  /// [CallSnapshot.sas].
  final List<String> sas;

  /// Групповой звонок: остальные участники (в комнате и ещё звонящие); пусто —
  /// звонок 1-на-1.
  final List<CallParticipantView> participants;

  bool get group => participants.isNotEmpty;

  const CallState({
    this.status = Status.initialization,
    this.callStatus = CallStatus.idle,
    this.callId = '',
    this.remoteUserID = const [],
    this.video = false,
    this.micMuted = false,
    this.cameraOff = false,
    this.speakerOn = false,
    this.remoteMicMuted = false,
    this.remoteVideoOff = true,
    this.remoteOnHold = false,
    this.reconnecting = false,
    this.remoteReconnecting = false,
    this.endReason = CallEndReason.none,
    this.debug = '',
    this.connectedAt,
    this.quality = CallQuality.unknown,
    this.mediaEpoch = 0,
    this.displayName = '',
    this.nameLines = const [],
    this.boringAvatarHash = '',
    this.avatarBytes,
    this.encryption = CallEncryption.negotiating,
    this.sas = const [],
    this.participants = const [],
  });
}
