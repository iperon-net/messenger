import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../chats/voice_player.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import '../../models.dart' as models;

/// Запись голосового (как в Telegram): удерживаешь микрофон — пишется,
/// отпустил — отправилось; влево — отмена, вверх — «замок» (пишется без
/// пальца, потом «Отмена» или отправка тапом по кругу).
enum VoiceRecordState { idle, recording, locked }

class VoiceRecorder extends ChangeNotifier {
  /// Готовая запись: файл (AAC в `.m4a`), секунды, волна 0..31.
  final Future<void> Function(String path, int seconds, List<int> waveform) onSend;

  /// Нет разрешения на микрофон; [permanently] — система больше не спросит,
  /// нужно вести в настройки.
  final Future<void> Function(bool permanently) onDenied;

  VoiceRecorder({required this.onSend, required this.onDenied});

  static const cancelDistance = 110.0;
  static const lockDistance = 70.0;

  /// Короче — не отправляем, подсказываем «Удерживайте».
  static const minDuration = Duration(milliseconds: 700);

  final _recorder = AudioRecorder();
  final _clock = Stopwatch();
  final _levels = <double>[];
  Timer? _tick;
  Timer? _hintTimer;
  StreamSubscription<Amplitude>? _amplitude;
  bool _starting = false;
  bool _releasedWhileStarting = false;

  VoiceRecordState state = VoiceRecordState.idle;
  Duration get elapsed => _clock.elapsed;

  /// Текущая громкость 0..1 — пульсирует круг под пальцем.
  double level = 0;

  /// Смещение пальца от точки нажатия (только влево/вверх).
  Offset drag = Offset.zero;

  /// Короткий тап — подсказка «Удерживайте, чтобы записать».
  bool holdHint = false;

  bool get active => state != VoiceRecordState.idle;

  /// Палец лёг на микрофон.
  Future<void> press() async {
    if (active || _starting) return;
    final status = await Permission.microphone.status;
    if (!status.isGranted) {
      // Палец всё равно отпустят ради системного диалога — запись не начинаем.
      if (status.isPermanentlyDenied) {
        await onDenied(true);
      } else {
        final result = await Permission.microphone.request();
        if (!result.isGranted) await onDenied(result.isPermanentlyDenied);
      }
      return;
    }
    _starting = true;
    _releasedWhileStarting = false;
    await VoicePlayer.instance.stop();
    HapticFeedback.mediumImpact();
    try {
      await _recorder.start(
        const RecordConfig(
          // AAC-LC моно 32 кбит/с: ~240 КБ в минуту, играется везде.
          encoder: AudioEncoder.aacLc,
          bitRate: 32000,
          sampleRate: 44100,
          numChannels: 1,
          noiseSuppress: true,
          iosConfig: IosRecordConfig(categoryOptions: [IosAudioCategoryOption.defaultToSpeaker, IosAudioCategoryOption.allowBluetooth]),
        ),
        path: await _newPath(),
      );
    } catch (e, s) {
      getIt.get<Logger>().handle(e, s, 'VoiceRecorder.start');
      _starting = false;
      return;
    }
    _starting = false;
    _levels.clear();
    level = 0;
    drag = Offset.zero;
    holdHint = false;
    state = VoiceRecordState.recording;
    _clock
      ..reset()
      ..start();
    _tick = Timer.periodic(const Duration(milliseconds: 100), (_) => notifyListeners());
    _amplitude = _recorder.onAmplitudeChanged(const Duration(milliseconds: 50)).listen((a) {
      // dBFS: −45 и тише — тишина, 0 — максимум.
      level = ((a.current + 45) / 45).clamp(0.0, 1.0);
      _levels.add(level);
    });
    notifyListeners();
    // Отпустили, пока запись запускалась, — это короткий тап.
    if (_releasedWhileStarting) await release();
  }

  /// Палец двигается: влево — к отмене, вверх — к замку.
  void move(Offset delta) {
    if (state != VoiceRecordState.recording) return;
    drag = Offset(math.min(0, drag.dx + delta.dx), math.min(0, drag.dy + delta.dy));
    if (drag.dx <= -cancelDistance) {
      HapticFeedback.lightImpact();
      cancel();
      return;
    }
    if (drag.dy <= -lockDistance) {
      HapticFeedback.mediumImpact();
      state = VoiceRecordState.locked;
      drag = Offset.zero;
    }
    notifyListeners();
  }

  /// Палец отпущен: запись — отправить; «замок» — продолжаем писать.
  Future<void> release() async {
    if (_starting) {
      _releasedWhileStarting = true;
      return;
    }
    if (state == VoiceRecordState.recording) await send();
  }

  Future<void> send() async {
    if (!active) return;
    final duration = _clock.elapsed;
    final waveform = _waveform();
    final path = await _stop();
    if (path == null) return;
    if (duration < minDuration) {
      _deleteQuietly(path);
      _showHint();
      return;
    }
    HapticFeedback.lightImpact();
    await onSend(path, math.max(1, (duration.inMilliseconds / 1000).round()), waveform);
  }

  Future<void> cancel() async {
    if (!active) return;
    _reset();
    try {
      await _recorder.cancel();
    } catch (e, s) {
      getIt.get<Logger>().handle(e, s, 'VoiceRecorder.cancel');
    }
  }

  Future<String?> _stop() async {
    _reset();
    try {
      return await _recorder.stop();
    } catch (e, s) {
      getIt.get<Logger>().handle(e, s, 'VoiceRecorder.stop');
      return null;
    }
  }

  void _reset() {
    _tick?.cancel();
    _amplitude?.cancel();
    _amplitude = null;
    _clock.stop();
    state = VoiceRecordState.idle;
    drag = Offset.zero;
    level = 0;
    notifyListeners();
  }

  void _showHint() {
    holdHint = true;
    notifyListeners();
    _hintTimer?.cancel();
    _hintTimer = Timer(const Duration(milliseconds: 1600), () {
      holdHint = false;
      notifyListeners();
    });
  }

  /// Громкость по времени → [models.Message.voiceWaveformBars] столбиков
  /// (максимум в каждом отрезке), 0..31.
  List<int> _waveform() {
    const bars = models.Message.voiceWaveformBars;
    if (_levels.isEmpty) return const [];
    return [
      for (var i = 0; i < bars; i++)
        () {
          final from = i * _levels.length ~/ bars;
          final to = math.max(from + 1, (i + 1) * _levels.length ~/ bars);
          final peak = _levels.sublist(from, math.min(to, _levels.length)).fold<double>(0, math.max);
          return (peak * 31).round();
        }(),
    ];
  }

  static Future<String> _newPath() async {
    final dir = Directory(p.join((await getTemporaryDirectory()).path, 'chat_media'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return p.join(dir.path, 'voice_${DateTime.now().microsecondsSinceEpoch}.m4a');
  }

  static void _deleteQuietly(String path) {
    File(path).delete().ignore();
  }

  @override
  void dispose() {
    _hintTimer?.cancel();
    if (active) cancel();
    _recorder.dispose();
    super.dispose();
  }
}

/// Цвета записи — свои у Cupertino и Material.
class VoiceRecorderStyle {
  final Color primary;
  final Color onPrimary;
  final Color text;
  final Color secondary;
  final Color danger;

  /// Подложка плашки «замка» и подсказки.
  final Color surface;

  const VoiceRecorderStyle({
    required this.primary,
    required this.onPrimary,
    required this.text,
    required this.secondary,
    required this.danger,
    required this.surface,
  });
}

/// Кнопка-микрофон справа в поле ввода (когда текста нет); размер — от
/// родителя (слот [ComposeActionSlot]). Пока пишется —
/// над ней большой круг за пальцем (пульсирует от громкости) и плашка
/// «замка» сверху; в режиме «замка» тап по кругу — отправить.
class VoiceRecordButton extends StatefulWidget {
  final VoiceRecorder recorder;
  final VoiceRecorderStyle style;

  const VoiceRecordButton({super.key, required this.recorder, required this.style});

  @override
  State<VoiceRecordButton> createState() => _VoiceRecordButtonState();
}

class _VoiceRecordButtonState extends State<VoiceRecordButton> {
  final _link = LayerLink();
  final _buttonKey = GlobalKey();
  final _portal = OverlayPortalController();

  static const _circle = 78.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _portal.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    final recorder = widget.recorder;
    final style = widget.style;
    return OverlayPortal(
      controller: _portal,
      overlayChildBuilder: (context) => ListenableBuilder(listenable: recorder, builder: (context, _) => _overlay(context)),
      child: CompositedTransformTarget(
        link: _link,
        // Eager-распознаватель сразу выигрывает арену: пока палец на кнопке,
        // движение не уходит в свайп «назад» страницы или скролл ленты.
        child: RawGestureDetector(
          gestures: {
            EagerGestureRecognizer: GestureRecognizerFactoryWithHandlers<EagerGestureRecognizer>(EagerGestureRecognizer.new, (_) {}),
          },
          child: Listener(
            key: _buttonKey,
            behavior: HitTestBehavior.opaque,
            onPointerDown: (_) => recorder.press(),
            onPointerMove: (event) => recorder.move(event.delta),
            onPointerUp: (_) => recorder.release(),
            onPointerCancel: (_) => recorder.cancel(),
            // Заполняет слот кнопки в поле ввода (размер задаёт он) — вся
            // площадь слота нажимается.
            child: Center(child: FaIcon(FontAwesomeIcons.microphone, size: 22, color: style.secondary)),
          ),
        ),
      ),
    );
  }

  Widget _overlay(BuildContext context) {
    final recorder = widget.recorder;
    final style = widget.style;
    if (!recorder.active) {
      if (!recorder.holdHint) return const SizedBox.shrink();
      // Подсказка над кнопкой, правым краем к её правому краю (кнопка у
      // правого края экрана) — позиция по реальному месту кнопки на экране и
      // не дальше 8 px от краёв экрана.
      final button = _buttonKey.currentContext?.findRenderObject();
      if (button is! RenderBox || !button.hasSize) return const SizedBox.shrink();
      final rect = button.localToGlobal(Offset.zero) & button.size;
      final screen = MediaQuery.sizeOf(context);
      return Stack(
        children: [
          Positioned(
            right: (screen.width - rect.right).clamp(8.0, screen.width),
            bottom: screen.height - rect.top + 8,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: screen.width - 16),
              child: _Bubble(
                color: style.surface,
                child: Text(context.t.screenChat.voiceHoldHint, style: TextStyle(fontSize: 14, color: style.text)),
              ),
            ),
          ),
        ],
      );
    }
    final locked = recorder.state == VoiceRecordState.locked;
    final pulse = _circle * (1 + 0.45 * recorder.level);
    return Stack(
      children: [
        // Плашка «замка»: тянешь вверх — подъезжает к кругу.
        if (!locked)
          _follow(
            offset: Offset(0, -110 + recorder.drag.dy * 0.5),
            child: _Bubble(
              color: style.surface,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(FontAwesomeIcons.lockOpen, size: 15, color: style.secondary),
                  const SizedBox(height: 6),
                  FaIcon(FontAwesomeIcons.chevronUp, size: 11, color: style.secondary),
                ],
              ),
            ),
          ),
        _follow(
          offset: Offset(recorder.drag.dx, recorder.drag.dy),
          child: IgnorePointer(
            // Пока палец на экране, жесты идут в Listener кнопки.
            ignoring: !locked,
            child: GestureDetector(
              onTap: recorder.send,
              child: SizedBox(
                width: _circle * 1.5,
                height: _circle * 1.5,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 90),
                      width: pulse,
                      height: pulse,
                      decoration: BoxDecoration(color: style.primary.withValues(alpha: 0.25), shape: BoxShape.circle),
                    ),
                    Container(
                      width: _circle,
                      height: _circle,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: style.primary, shape: BoxShape.circle),
                      child: FaIcon(locked ? FontAwesomeIcons.arrowUp : FontAwesomeIcons.microphone, size: 28, color: style.onPrimary),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Ребёнок центром над кнопкой со смещением [offset].
  Widget _follow({required Offset offset, required Widget child}) {
    return Align(
      alignment: Alignment.topLeft,
      child: CompositedTransformFollower(
        link: _link,
        showWhenUnlinked: false,
        targetAnchor: Alignment.center,
        followerAnchor: Alignment.center,
        offset: offset,
        child: child,
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final Color color;
  final Widget child;

  const _Bubble({required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: child,
    );
  }
}

/// Вместо поля ввода, пока пишется: мигающая точка и время, «‹ Влево —
/// отмена» (уезжает за пальцем) или, на «замке», «Отмена».
class VoiceRecordingPanel extends StatelessWidget {
  final VoiceRecorder recorder;
  final VoiceRecorderStyle style;

  const VoiceRecordingPanel({super.key, required this.recorder, required this.style});

  String _time(BuildContext context) {
    final ms = recorder.elapsed.inMilliseconds;
    final separator = Localizations.localeOf(context).languageCode == 'ru' ? ',' : '.';
    final seconds = (ms ~/ 1000 % 60).toString().padLeft(2, '0');
    return '${ms ~/ 60000}:$seconds$separator${ms % 1000 ~/ 100}';
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenChat;
    final locked = recorder.state == VoiceRecordState.locked;
    final fade = (1 + recorder.drag.dx / VoiceRecorder.cancelDistance).clamp(0.15, 1.0);
    return SizedBox(
      height: 36,
      child: Row(
        children: [
          const SizedBox(width: 12),
          _BlinkingDot(color: style.danger),
          const SizedBox(width: 8),
          Text(
            _time(context),
            style: TextStyle(fontSize: 16, color: style.text, fontFeatures: const [FontFeature.tabularFigures()]),
          ),
          Expanded(
            child: Center(
              child: locked
                  ? GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: recorder.cancel,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          context.t.common.cancel,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: style.primary),
                        ),
                      ),
                    )
                  : Opacity(
                      opacity: fade,
                      child: Transform.translate(
                        offset: Offset(recorder.drag.dx * 0.6, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(FontAwesomeIcons.chevronLeft, size: 12, color: style.secondary),
                            const SizedBox(width: 6),
                            Text(t.voiceSlideToCancel, style: TextStyle(fontSize: 15, color: style.secondary)),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlinkingDot extends StatefulWidget {
  final Color color;

  const _BlinkingDot({required this.color});

  @override
  State<_BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<_BlinkingDot> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 1, end: 0.2).animate(_controller),
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }
}

/// Слот кнопки справа от поля ввода фиксированного размера: микрофон и
/// «Отправить» меняются в нём с анимацией, не сдвигая поле ввода.
class ComposeActionSlot extends StatelessWidget {
  final Size size;

  /// Ключ ребёнка — чтобы смена микрофон ↔ отправка анимировалась.
  final Widget child;

  const ComposeActionSlot({super.key, required this.size, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 160),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: Tween<double>(begin: 0.6, end: 1).animate(animation), child: child),
        ),
        // Оба ребёнка — во весь слот, по центру.
        layoutBuilder: (current, previous) => Stack(fit: StackFit.expand, children: [...previous, ?current]),
        child: child,
      ),
    );
  }
}
