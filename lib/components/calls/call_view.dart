import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:livekit_client/livekit_client.dart';

import '../../calls.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models/constants.dart';

/// Палитра экрана звонка. Две версии — светлая/тёмная (см. [_CallPalette.of]),
/// плюс «поверх медиа» ([_CallPalette.overMedia]): когда на весь экран идёт видео
/// собеседника, текст/контролы всегда светлые для контраста над картинкой,
/// независимо от темы приложения.
class _CallPalette {
  final Color bg;
  final Color fg;
  final Color dim;
  final Color controlBg;
  final Color controlActiveBg;

  const _CallPalette({required this.bg, required this.fg, required this.dim, required this.controlBg, required this.controlActiveBg});

  static const _dark = _CallPalette(
    bg: Color(0xFF1C1C1E),
    fg: Color(0xFFFFFFFF),
    dim: Color(0xFFB0B0B5),
    controlBg: Color(0xFF2C2C2E),
    controlActiveBg: Color(0xFF48484A),
  );

  static const _light = _CallPalette(
    bg: Color(0xFFF2F2F7),
    fg: Color(0xFF1C1C1E),
    dim: Color(0xFF6C6C70),
    controlBg: Color(0xFFE3E3E8),
    controlActiveBg: Color(0xFFCED0D6),
  );

  /// Поверх видео — та же тёмная палитра (светлый текст на картинке).
  static const overMedia = _dark;

  /// Палитра под тему приложения: [darkMode] из настроек (система/светлая/тёмная),
  /// для `system` берём яркость платформы.
  static _CallPalette of(BuildContext context, DarkModeModel darkMode) {
    final brightness = switch (darkMode) {
      DarkModeModel.alwaysOn => Brightness.dark,
      DarkModeModel.disabled => Brightness.light,
      DarkModeModel.system => MediaQuery.platformBrightnessOf(context),
    };
    return brightness == Brightness.dark ? _dark : _light;
  }
}

/// Экран звонка (общий для обеих платформ): рендерит удалённое видео на весь
/// экран, локальное — картинкой-в-картинке, а для аудиозвонка — аватар/имя
/// собеседника, плюс панель управления, зависящую от стадии звонка
/// ([CallStatus]). Действия проксируются в [CallCubit] → [Calls]. Платформенные
/// обёртки (`CallCupertino`/`CallMaterial`) лишь дают Scaffold и фон. Палитра
/// следует теме приложения (светлая/тёмная), а поверх активного видео всегда
/// светлая — см. [_CallPalette].
class CallView extends StatelessWidget {
  const CallView({super.key});

  // Семантические цвета кнопок/индикатора — одинаковы в обеих темах (хорошо
  // читаются и на светлом, и на тёмном фоне).
  static const _red = Color(0xFFFF3B30);
  static const _green = Color(0xFF34C759);
  static const _amber = Color(0xFFFF9F0A);

  // Цвет иконки на цветной (красной/зелёной) кнопке — всегда белый в обеих темах.
  static const _onAccent = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    final darkMode = context.select((CommonCubit c) => c.state.settingsDevice.darkMode);

    return BlocBuilder<CallCubit, CallState>(
      builder: (context, state) {
        final cubit = context.read<CallCubit>();
        final video = state.video;
        final showVideo = video && (state.callStatus == CallStatus.active || state.callStatus == CallStatus.connecting);
        // Поверх видео — светлая палитра (контраст над картинкой); иначе — под тему.
        final palette = showVideo ? _CallPalette.overMedia : _CallPalette.of(context, darkMode);
        // Дорожки берём из сервиса; mediaEpoch в state гарантирует, что при их
        // появлении/смене BlocBuilder перестроит рендереры (сами VideoTrack не
        // участвуют в equality состояния).
        final remoteTrack = cubit.remoteVideoTrack;
        final localTrack = cubit.localVideoTrack;

        return ColoredBox(
          color: palette.bg,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (showVideo && remoteTrack != null) VideoTrackRenderer(remoteTrack, fit: VideoViewFit.cover),
              if (showVideo && localTrack != null)
                Positioned(
                  right: 16,
                  top: 48,
                  width: 110,
                  height: 160,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: VideoTrackRenderer(localTrack, fit: VideoViewFit.cover, mirrorMode: VideoViewMirrorMode.mirror),
                  ),
                ),
              _Overlay(state: state, showVideo: showVideo, palette: palette),
            ],
          ),
        );
      },
    );
  }
}

class _Overlay extends StatelessWidget {
  final CallState state;
  final bool showVideo;
  final _CallPalette palette;

  const _Overlay({required this.state, required this.showVideo, required this.palette});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CallCubit>();
    final active = state.callStatus == CallStatus.active;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 8),
                // Для видеозвонка лицо собеседника уже на весь экран — аватар не
                // дублируем. Для аудио (или до старта видео) показываем аватар.
                if (!showVideo) ...[_Avatar(state: state, palette: palette), const SizedBox(height: 20)],
                Text(
                  _title(context),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: palette.fg, fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                // На активном звонке подпись — таймер разговора; иначе — статус.
                if (active && state.connectedAt != null)
                  _CallTimer(connectedAt: state.connectedAt!, color: palette.dim)
                else
                  Text(
                    _subtitle(context),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: palette.dim, fontSize: 15),
                  ),
                // Индикатор качества связи (только на активном звонке, когда
                // LiveKit уже прислал оценку).
                if (active && state.quality != CallQuality.unknown) ...[
                  const SizedBox(height: 8),
                  _QualityIndicator(quality: state.quality, dim: palette.dim),
                ],
                // Диагностика соединения прямо на экране (этапы сигналинга/ICE/
                // медиа) — без выгрузки логов с устройства.
                if (state.debug.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      state.debug,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: palette.dim, fontSize: 11),
                    ),
                  ),
              ],
            ),
            _controls(context, cubit, state),
          ],
        ),
      ),
    );
  }

  Widget _controls(BuildContext context, CallCubit cubit, CallState state) {
    final t = context.t.screenCall;
    switch (state.callStatus) {
      case CallStatus.incoming:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _CircleButton(
              label: t.decline,
              icon: CupertinoIcons.phone_down_fill,
              color: CallView._red,
              iconColor: CallView._onAccent,
              palette: palette,
              onTap: cubit.reject,
            ),
            _CircleButton(
              label: t.accept,
              icon: CupertinoIcons.phone_fill,
              color: CallView._green,
              iconColor: CallView._onAccent,
              palette: palette,
              onTap: cubit.accept,
            ),
          ],
        );
      case CallStatus.outgoing:
      case CallStatus.connecting:
        return _CircleButton(
          label: t.hangup,
          icon: CupertinoIcons.phone_down_fill,
          color: CallView._red,
          iconColor: CallView._onAccent,
          palette: palette,
          onTap: cubit.hangup,
        );
      case CallStatus.active:
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _CircleButton(
                  label: state.micMuted ? t.micOn : t.micOff,
                  icon: state.micMuted ? CupertinoIcons.mic_slash_fill : CupertinoIcons.mic_fill,
                  color: state.micMuted ? palette.controlActiveBg : palette.controlBg,
                  iconColor: palette.fg,
                  palette: palette,
                  onTap: cubit.toggleMic,
                ),
                _CircleButton(
                  label: state.speakerOn ? t.speakerOff : t.speakerOn,
                  icon: state.speakerOn ? CupertinoIcons.speaker_3_fill : CupertinoIcons.speaker_1_fill,
                  color: state.speakerOn ? palette.controlActiveBg : palette.controlBg,
                  iconColor: palette.fg,
                  palette: palette,
                  onTap: cubit.toggleSpeaker,
                ),
                if (state.video)
                  _CircleButton(
                    label: state.cameraOff ? t.cameraOn : t.cameraOff,
                    icon: state.cameraOff ? CupertinoIcons.video_camera : CupertinoIcons.video_camera_solid,
                    color: state.cameraOff ? palette.controlActiveBg : palette.controlBg,
                    iconColor: palette.fg,
                    palette: palette,
                    onTap: cubit.toggleCamera,
                  ),
                if (state.video)
                  _CircleButton(
                    label: t.switchCamera,
                    icon: CupertinoIcons.switch_camera_solid,
                    color: palette.controlBg,
                    iconColor: palette.fg,
                    palette: palette,
                    onTap: cubit.switchCamera,
                  ),
              ],
            ),
            const SizedBox(height: 24),
            _CircleButton(
              label: t.hangup,
              icon: CupertinoIcons.phone_down_fill,
              color: CallView._red,
              iconColor: CallView._onAccent,
              palette: palette,
              onTap: cubit.hangup,
            ),
          ],
        );
      case CallStatus.ended:
      case CallStatus.idle:
        return const SizedBox.shrink();
    }
  }

  String _title(BuildContext context) {
    // Имя собеседника из профиля (кэш/стрим, см. CallCubit); пока не разрешено —
    // нейтральный фолбэк.
    return state.displayName.isNotEmpty ? state.displayName : context.t.screenCall.title;
  }

  String _subtitle(BuildContext context) {
    final t = context.t.screenCall;
    switch (state.callStatus) {
      case CallStatus.incoming:
        return state.video ? t.incomingVideo : t.incomingAudio;
      case CallStatus.outgoing:
        return t.calling;
      case CallStatus.connecting:
        return t.connecting;
      case CallStatus.active:
        return t.talking;
      case CallStatus.ended:
        switch (state.endReason) {
          case CallEndReason.rejected:
            return t.endedRejected;
          case CallEndReason.failed:
            return t.endedFailed;
          case CallEndReason.busy:
            return t.endedBusy;
          case CallEndReason.hangup:
          case CallEndReason.none:
            return t.ended;
        }
      case CallStatus.idle:
        return '';
    }
  }
}

/// Тикающий таймер разговора (mm:ss, а от часа — h:mm:ss) от момента
/// [connectedAt]. Обновляется раз в секунду.
class _CallTimer extends StatefulWidget {
  final DateTime connectedAt;
  final Color color;

  const _CallTimer({required this.connectedAt, required this.color});

  @override
  State<_CallTimer> createState() => _CallTimerState();
}

class _CallTimerState extends State<_CallTimer> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  static String _format(Duration d) {
    final total = d.inSeconds < 0 ? 0 : d.inSeconds;
    final h = total ~/ 3600;
    final m = (total % 3600) ~/ 60;
    final s = total % 60;
    final ss = s.toString().padLeft(2, '0');
    if (h > 0) return '$h:${m.toString().padLeft(2, '0')}:$ss';
    return '$m:$ss';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _format(DateTime.now().difference(widget.connectedAt)),
      textAlign: TextAlign.center,
      style: TextStyle(color: widget.color, fontSize: 15, fontFeatures: const [FontFeature.tabularFigures()]),
    );
  }
}

/// Индикатор качества связи: три «столбика» (закрашено 1/2/3 по качеству) плюс
/// краткая подпись. Цвет — красный/жёлтый/зелёный.
class _QualityIndicator extends StatelessWidget {
  final CallQuality quality;
  final Color dim;

  const _QualityIndicator({required this.quality, required this.dim});

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenCall;
    final (bars, color, label) = switch (quality) {
      CallQuality.excellent => (3, CallView._green, t.qualityExcellent),
      CallQuality.good => (2, CallView._amber, t.qualityGood),
      CallQuality.poor => (1, CallView._red, t.qualityPoor),
      CallQuality.unknown => (0, dim, ''),
    };
    final inactive = dim.withValues(alpha: 0.3);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 3; i++)
          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Container(
              width: 3,
              height: 6.0 + i * 3,
              decoration: BoxDecoration(color: i < bars ? color : inactive, borderRadius: BorderRadius.circular(1)),
            ),
          ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }
}

/// Аватар собеседника на экране аудиозвонка: скачанная картинка либо
/// BoringAvatar-плейсхолдер (сид — hex userID), как на экране профиля.
class _Avatar extends StatelessWidget {
  final CallState state;
  final _CallPalette palette;

  const _Avatar({required this.state, required this.palette});

  static const _size = 128.0;

  @override
  Widget build(BuildContext context) {
    final bytes = state.avatarBytes;
    return SizedBox(
      width: _size,
      height: _size,
      child: bytes != null
          ? ClipOval(
              child: Image.memory(
                bytes,
                width: _size,
                height: _size,
                fit: BoxFit.cover,
                gaplessPlayback: true,
                cacheWidth: (_size * MediaQuery.devicePixelRatioOf(context)).round(),
                cacheHeight: (_size * MediaQuery.devicePixelRatioOf(context)).round(),
              ),
            )
          : (state.boringAvatarHash.isNotEmpty
                ? AnimatedBoringAvatar(
                    name: state.boringAvatarHash,
                    type: BoringAvatarType.beam,
                    shape: const CircleBorder(),
                    duration: const Duration(milliseconds: 600),
                  )
                : DecoratedBox(
                    decoration: BoxDecoration(color: palette.controlBg, shape: BoxShape.circle),
                  )),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final _CallPalette palette;
  final VoidCallback onTap;

  const _CircleButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.palette,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: palette.fg, fontSize: 13)),
        ],
      ),
    );
  }
}
