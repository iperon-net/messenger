import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekit_client/livekit_client.dart' show VideoTrack;

import '../../calls.dart';
import '../../components/calls/call_view.dart';
import '../../constants.dart';
import '../../cubit.dart';

/// DEBUG-only превью экрана звонка ([CallView]) без реального звонка. Открывается
/// из скрытого раздела «Разработчик» и подаёт [CallView] заранее собранное
/// мок-состояние, чтобы можно было спокойно вычитывать/править дизайн всех стадий
/// звонка на устройстве, не поднимая LiveKit и не звоня по-настоящему.
///
/// Мок-кубит [_PreviewCallCubit] заменяет обращения к сервису [Calls]
/// локальными правками состояния (кнопки просто перекидывают стадию/флаги), а
/// видео-дорожек нет — в видео-стадии рисуется только оверлей контролов поверх
/// фона. Компактный переключатель в левом верхнем углу гоняет стадии по кругу.
class CallPreview extends StatelessWidget {
  const CallPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CallCubit>(create: (_) => _PreviewCallCubit(), child: const _CallPreviewBody());
  }
}

class _CallPreviewBody extends StatelessWidget {
  const _CallPreviewBody();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: const [
        CallView(),
        SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(padding: EdgeInsets.all(12), child: _StageSwitcher()),
          ),
        ),
      ],
    );
  }
}

/// Одна стадия превью: подпись для переключателя + фабрика мок-состояния.
class _Stage {
  final String label;
  final CallState Function() build;

  const _Stage(this.label, this.build);
}

/// Компактная «таблетка» слева сверху: тап — следующая стадия по кругу.
class _StageSwitcher extends StatefulWidget {
  const _StageSwitcher();

  @override
  State<_StageSwitcher> createState() => _StageSwitcherState();
}

class _StageSwitcherState extends State<_StageSwitcher> {
  // Фиксированные «личность» и точка отсчёта таймера, чтобы стадии выглядели
  // осмысленно и стабильно между переключениями.
  static const _name = 'Анна Смирнова';
  static const _avatarHash = '5f3a9c1b7e2d4a6f8c0b1d2e';

  CallState _base() => const CallState(status: Status.success, displayName: _name, boringAvatarHash: _avatarHash);

  late final List<_Stage> _stages = [
    _Stage(
      'Активный аудио',
      () => _base().copyWith(
        callStatus: CallStatus.active,
        connectedAt: DateTime.now().subtract(const Duration(minutes: 3, seconds: 42)),
        quality: CallQuality.excellent,
      ),
    ),
    _Stage('Входящий', () => _base().copyWith(callStatus: CallStatus.incoming)),
    _Stage('Исходящий', () => _base().copyWith(callStatus: CallStatus.outgoing)),
    _Stage(
      'Активный видео',
      () => _base().copyWith(
        callStatus: CallStatus.active,
        video: true,
        connectedAt: DateTime.now().subtract(const Duration(minutes: 3, seconds: 42)),
        quality: CallQuality.good,
      ),
    ),
    _Stage('Завершён', () => _base().copyWith(callStatus: CallStatus.ended, endReason: CallEndReason.hangup)),
  ];

  int _index = 0;

  @override
  void initState() {
    super.initState();
    // Стартовая стадия — активный аудиозвонок (первый элемент). Пушим в кубит
    // после первого кадра, когда провайдер уже доступен из контекста.
    WidgetsBinding.instance.addPostFrameCallback((_) => _apply());
  }

  void _apply() {
    if (!mounted) return;
    (context.read<CallCubit>() as _PreviewCallCubit).show(_stages[_index].build());
  }

  void _next() {
    setState(() => _index = (_index + 1) % _stages.length);
    _apply();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _next,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: const Color(0xCC000000), borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CupertinoIcons.arrow_2_circlepath, color: Color(0xFFFFFFFF), size: 16),
            const SizedBox(width: 8),
            Text(
              _stages[_index].label,
              style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

/// Мок-[CallCubit] для превью: не подписывается на [Calls] и не разрешает
/// личность собеседника; состояние задаёт [show], а действия кнопок правят
/// состояние локально, чтобы превью было живым (mute/динамик/камера, принять/
/// отклонить/завершить).
class _PreviewCallCubit extends CallCubit {
  _PreviewCallCubit();

  // Реальных дорожек нет — видео-стадия показывает только оверлей поверх фона.
  @override
  VideoTrack? get localVideoTrack => null;
  @override
  VideoTrack? get remoteVideoTrack => null;

  /// Подставить состояние выбранной стадии.
  void show(CallState next) => emit(next);

  @override
  Future<void> accept() async =>
      emit(state.copyWith(callStatus: CallStatus.active, connectedAt: DateTime.now(), quality: CallQuality.excellent));

  @override
  Future<void> reject() async => emit(state.copyWith(callStatus: CallStatus.ended, endReason: CallEndReason.rejected));

  @override
  Future<void> hangup() async => emit(state.copyWith(callStatus: CallStatus.ended, endReason: CallEndReason.hangup));

  @override
  Future<void> toggleMic() async => emit(state.copyWith(micMuted: !state.micMuted));

  @override
  Future<void> toggleSpeaker() async => emit(state.copyWith(speakerOn: !state.speakerOn));

  @override
  Future<void> toggleCamera() async => emit(state.copyWith(cameraOff: !state.cameraOff));

  @override
  Future<void> enableVideo() async => emit(state.copyWith(video: true, cameraOff: false));

  @override
  Future<void> pauseVideoForBackground() async {}

  @override
  Future<void> resumeVideoAfterBackground() async {}

  @override
  Future<void> switchCamera() async {}
}
