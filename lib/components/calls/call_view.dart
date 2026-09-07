import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../calls.dart';
import '../../cubit.dart';

/// Экран звонка (общий для обеих платформ, как [LocalMediaPreview]): рендерит
/// удалённое видео на весь экран, локальное — картинкой-в-картинке, и панель
/// управления, зависящую от стадии звонка ([CallStatus]). Действия проксируются
/// в [CallCubit] → [Calls]. Платформенные обёртки (`CallCupertino`/
/// `CallMaterial`) лишь дают Scaffold и фон. Полный UI/UX — фаза 3.
class CallView extends StatelessWidget {
  const CallView({super.key});

  static const _bg = Color(0xFF1C1C1E);
  static const _fg = Color(0xFFFFFFFF);
  static const _dim = Color(0xFFB0B0B5);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CallCubit, CallState>(
      builder: (context, state) {
        final cubit = context.read<CallCubit>();
        final video = state.video;
        final showVideo = video && (state.callStatus == CallStatus.active || state.callStatus == CallStatus.connecting);

        return ColoredBox(
          color: _bg,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (showVideo) RTCVideoView(cubit.remoteRenderer, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
              if (showVideo)
                Positioned(
                  right: 16,
                  top: 48,
                  width: 110,
                  height: 160,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: RTCVideoView(cubit.localRenderer, mirror: true, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
                  ),
                ),
              _Overlay(state: state, showVideo: showVideo),
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

  const _Overlay({required this.state, required this.showVideo});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CallCubit>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  _title(state),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: CallView._fg, fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  _subtitle(state),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: CallView._dim, fontSize: 15),
                ),
                // Фаза 1: диагностика соединения прямо на экране — видно стадию
                // сигналинга/ICE/медиа без выгрузки логов с устройства.
                if (state.debug.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      state.debug,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: CallView._dim, fontSize: 11),
                    ),
                  ),
              ],
            ),
            _controls(cubit, state),
          ],
        ),
      ),
    );
  }

  Widget _controls(CallCubit cubit, CallState state) {
    switch (state.callStatus) {
      case CallStatus.incoming:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _CircleButton(label: 'Отклонить', color: const Color(0xFFFF3B30), onTap: cubit.reject),
            _CircleButton(label: 'Принять', color: const Color(0xFF34C759), onTap: cubit.accept),
          ],
        );
      case CallStatus.outgoing:
      case CallStatus.connecting:
        return _CircleButton(label: 'Завершить', color: const Color(0xFFFF3B30), onTap: cubit.hangup);
      case CallStatus.active:
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _CircleButton(
                  label: state.micMuted ? 'Вкл. звук' : 'Выкл. звук',
                  color: state.micMuted ? const Color(0xFF48484A) : const Color(0xFF2C2C2E),
                  onTap: cubit.toggleMic,
                ),
                _CircleButton(
                  label: state.speakerOn ? 'Динамик' : 'Тихо',
                  color: state.speakerOn ? const Color(0xFF48484A) : const Color(0xFF2C2C2E),
                  onTap: cubit.toggleSpeaker,
                ),
                if (state.video)
                  _CircleButton(
                    label: state.cameraOff ? 'Вкл. камеру' : 'Выкл. камеру',
                    color: state.cameraOff ? const Color(0xFF48484A) : const Color(0xFF2C2C2E),
                    onTap: cubit.toggleCamera,
                  ),
                if (state.video) _CircleButton(label: 'Камера', color: const Color(0xFF2C2C2E), onTap: cubit.switchCamera),
              ],
            ),
            const SizedBox(height: 24),
            _CircleButton(label: 'Завершить', color: const Color(0xFFFF3B30), onTap: cubit.hangup),
          ],
        );
      case CallStatus.ended:
      case CallStatus.idle:
        return const SizedBox.shrink();
    }
  }

  String _title(CallState state) {
    // Собеседника пока показываем по короткому идентификатору — имя/аватар из
    // профиля подключит фаза 3.
    return 'Звонок';
  }

  String _subtitle(CallState state) {
    switch (state.callStatus) {
      case CallStatus.incoming:
        return state.video ? 'Входящий видеозвонок' : 'Входящий звонок';
      case CallStatus.outgoing:
        return 'Вызов…';
      case CallStatus.connecting:
        return 'Соединение…';
      case CallStatus.active:
        return 'Идёт разговор';
      case CallStatus.ended:
        switch (state.endReason) {
          case CallEndReason.rejected:
            return 'Звонок отклонён';
          case CallEndReason.failed:
            return 'Не удалось соединиться';
          case CallEndReason.busy:
            return 'Занято';
          case CallEndReason.hangup:
          case CallEndReason.none:
            return 'Звонок завершён';
        }
      case CallStatus.idle:
        return '';
    }
  }
}

class _CircleButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _CircleButton({required this.label, required this.color, required this.onTap});

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
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: CallView._fg, fontSize: 13)),
        ],
      ),
    );
  }
}
