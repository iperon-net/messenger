import 'dart:async';
import 'dart:io' show Platform;

import 'package:audioplayers/audioplayers.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../calls.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models/constants.dart';
import '../../themes/cupertino.dart';
import '../../themes/material.dart';
import 'audio_routes_sheet.dart';
import 'route_picker_button.dart';

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

  /// Цвет имени собеседника (заголовок).
  final Color name;

  /// Цвет строки статуса соединения (calling/connecting/talking/ended…).
  final Color status;

  /// Цвет таймера разговора на активном звонке.
  final Color timer;

  /// Цвет подписей под круглыми кнопками управления.
  final Color buttonLabel;

  const _CallPalette({
    required this.bg,
    required this.fg,
    required this.dim,
    required this.controlBg,
    required this.controlActiveBg,
    required this.name,
    required this.status,
    required this.timer,
    required this.buttonLabel,
  });

  static const _dark = _CallPalette(
    bg: Color(0xFFF2F2F7),
    fg: Color(0xFF1C1C1E),
    dim: Color(0xFF6C6C70),
    controlBg: Color(0xFFE3E3E8),
    controlActiveBg: Color(0xFFCED0D6),
    name: Color(0xFFCED0D6),
    status: Color(0xFFCED0D6),
    timer: Color(0xFFCED0D6),
    buttonLabel: Color(0xFFFFFFFF),
  );

  static const _light = _CallPalette(
    bg: Color(0xFFF2F2F7),
    fg: Color(0xFF1C1C1E),
    dim: Color(0xFF6C6C70),
    controlBg: Color(0xFFE3E3E8),
    controlActiveBg: Color(0xFFCED0D6),
    name: Color(0xFFCED0D6),
    status: Color(0xFFCED0D6),
    timer: Color(0xFFCED0D6),
    buttonLabel: Color(0xFFFFFFFF),
  );

  /// Поверх видео — та же тёмная палитра (светлый текст на картинке).
  static const overMedia = _dark;

  _CallPalette _withBg(Color bg) => _CallPalette(
    bg: bg,
    fg: fg,
    dim: dim,
    controlBg: controlBg,
    controlActiveBg: controlActiveBg,
    name: name,
    status: status,
    timer: timer,
    buttonLabel: buttonLabel,
  );

  /// Палитра под тему приложения: [darkMode] из настроек (система/светлая/тёмная),
  /// для `system` берём яркость платформы. Фон подменяется на зависящий от
  /// оформления [ThemesCupertino.callBackground] / [ThemesMaterial.callBackground],
  /// а остальные цвета (текст/контролы) остаются под яркость.
  static _CallPalette of(BuildContext context, DarkModeModel darkMode) {
    final brightness = switch (darkMode) {
      DarkModeModel.alwaysOn => Brightness.dark,
      DarkModeModel.disabled => Brightness.light,
      DarkModeModel.system => MediaQuery.platformBrightnessOf(context),
    };
    final base = brightness == Brightness.dark ? _dark : _light;
    final bg = Platform.isIOS ? ThemesCupertino.callBackground(context) : ThemesMaterial.callBackground(context);
    return base._withBg(bg);
  }
}

/// Экран звонка (общий для обеих платформ): рендерит удалённое видео на весь
/// экран, локальное — картинкой-в-картинке, а для аудиозвонка — аватар/имя
/// собеседника, плюс панель управления, зависящую от стадии звонка
/// ([CallStatus]). Действия проксируются в [CallCubit] → [Calls]. Платформенные
/// обёртки (`CallCupertino`/`CallMaterial`) лишь дают Scaffold и фон. Палитра
/// следует теме приложения (светлая/тёмная), а поверх активного видео всегда
/// светлая — см. [_CallPalette].
class CallView extends StatefulWidget {
  const CallView({super.key});

  // Семантические цвета кнопок/индикатора — одинаковы в обеих темах (хорошо
  // читаются и на светлом, и на тёмном фоне).
  static const _red = Color(0xFFFF3B30);
  static const _green = Color(0xFF34C759);
  static const _amber = Color(0xFFFF9F0A);

  // Цвет иконки на цветной (красной/зелёной) кнопке — всегда белый в обеих темах.
  static const _onAccent = Color(0xFFFFFFFF);

  @override
  State<CallView> createState() => _CallViewState();
}

class _CallViewState extends State<CallView> with WidgetsBindingObserver {
  // Picture-in-Picture (Android): мини-окно видеозвонка поверх рабочего стола.
  // Канал совпадает с обработчиком в MainActivity.kt. `_pipAllowed` — что мы уже
  // сообщили нативу (дедуп, как у [_wakelockEnabled]); `_inPip` — активен ли режим
  // мини-окна сейчас (натив шлёт `pipModeChanged`), в нём прячем панель управления.
  static const _pipChannel = MethodChannel('net.iperon.messenger/call_pip');
  bool _pipAllowed = false;
  bool _inPip = false;

  // Рингтон входящего. Играет ТОЛЬКО пока звонок в статусе `incoming` и только
  // там, где входящий ведёт наш экран (iOS-foreground — см. CallGate); на Android
  // и на фоне/локскрине/cold-start iOS входящий ведёт системная звонилка и звонит
  // сама. Зациклённый; гасится при уходе из `incoming` (принятие/отбой) и в
  // [dispose]. Ошибки проигрывания глушим — рингтон косметика, звонок из-за него
  // падать не должен.
  AudioPlayer? _ringtone;

  // Держим экран включённым только на видеозвонке: пользователь смотрит на
  // картинку, а не держит телефон у уха, поэтому системный таймаут гашения/
  // блокировки экрана здесь мешает. Для аудио wakelock НЕ включаем — там экран
  // должен гаснуть штатно (в т.ч. по датчику приближения у уха). Флаг хранит
  // текущее состояние, чтобы не дёргать нативный вызов на каждый build.
  bool _wakelockEnabled = false;

  // Аудио-контекст рингтона. На iOS категория `ambient` — её ГЛУШИТ аппаратный
  // переключатель «без звука» (в отличие от `playback`), т.е. рингтон уважает
  // беззвучный режим. `mixWithOthers` — не выбиваем чужое аудио. Android: usage
  // `notificationRingtone` следует громкости/режиму звонка (в текущем потоке экран
  // входящего показывается лишь на iOS, но контекст задаём корректный).
  static final AudioContext _ringtoneAudioContext = AudioContext(
    iOS: AudioContextIOS(category: AVAudioSessionCategory.ambient, options: const {AVAudioSessionOptions.mixWithOthers}),
    android: const AudioContextAndroid(
      isSpeakerphoneOn: false,
      stayAwake: false,
      contentType: AndroidContentType.sonification,
      usageType: AndroidUsageType.notificationRingtone,
      audioFocus: AndroidAudioFocus.gainTransientMayDuck,
    ),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Android: слушаем смену режима PiP от натива (вход/выход мини-окна).
    if (Platform.isAndroid) _pipChannel.setMethodCallHandler(_onPipCall);
    // Экран звонка — только портрет: в ландшафте вертикальная колонка контролов
    // не влезала и кнопка отбоя уезжала за пределы экрана. Возвращаем свободную
    // ориентацию при уходе с экрана.
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // Экран мог открыться сразу на входящем (CallGate пушит `/call` по `incoming`).
    // Слушатель ниже ловит только СМЕНЫ статуса, поэтому стартовый `incoming`
    // заводим здесь, после первого кадра (нужен доступ к CallCubit из контекста).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (context.read<CallCubit>().state.callStatus == CallStatus.incoming) {
        unawaited(_startRingtone());
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Уходим с экрана звонка — запрещаем PiP и снимаем обработчик канала.
    _syncPipAllowed(false);
    if (Platform.isAndroid) _pipChannel.setMethodCallHandler(null);
    unawaited(_stopRingtone());
    _syncWakelock(false);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  /// Обработчик вызовов от натива по PiP-каналу:
  ///  • `pipModeChanged` — вход/выход мини-окна, переключаем компактный лейаут;
  ///  • `pipSwitchCamera` — тап по кнопке «Сменить камеру» в PiP-окне (кнопки в
  ///    PiP не могут дёргать Flutter напрямую, натив ретранслирует их сюда).
  Future<dynamic> _onPipCall(MethodCall call) async {
    if (!mounted) return null;
    switch (call.method) {
      case 'pipModeChanged':
        setState(() => _inPip = call.arguments == true);
      case 'pipSwitchCamera':
        unawaited(context.read<CallCubit>().switchCamera());
      case 'pipClosed':
        // Пользователь закрыл мини-окно крестиком (убрать эту кнопку нельзя — она
        // системная). Система лишь убирает окно, поэтому завершаем звонок сами.
        unawaited(context.read<CallCubit>().hangup());
    }
    return null;
  }

  /// Разрешает/запрещает нативу автовход в PiP по Home. Идемпотентно (дедуп по
  /// [_pipAllowed]); только Android. Взводим на активном видеозвонке, снимаем на
  /// аудио/уходе с экрана — иначе любое сворачивание уводило бы в мини-окно.
  void _syncPipAllowed(bool allow) {
    if (!Platform.isAndroid || _pipAllowed == allow) return;
    _pipAllowed = allow;
    unawaited(_pipChannel.invokeMethod<void>('setPipAllowed', allow).catchError((_) {}));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycle) {
    if (!mounted) return;
    final cubit = context.read<CallCubit>();
    final isVideoCall =
        cubit.state.video && (cubit.state.callStatus == CallStatus.active || cubit.state.callStatus == CallStatus.connecting);
    if (!isVideoCall) return;

    switch (lifecycle) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        // Уход в фон: на iOS камера в фоне всё равно не снимает — глушим её, чтобы
        // собеседник увидел аватар, а не застывший последний кадр (на Android
        // захват в фоне продолжается, метод там no-op).
        unawaited(cubit.pauseVideoForBackground());
      case AppLifecycleState.resumed:
        // Возврат из фона: восстанавливаем приглушённую камеру. Кадры сами пойдут в
        // уже существующий рендерер — пересоздавать его НЕЛЬЗЯ (гонка с renderFrame:
        // на главном потоке роняет flutter_webrtc, EXC_BAD_ACCESS).
        unawaited(cubit.resumeVideoAfterBackground());
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        // `inactive` на iOS прилетает и на транзиентные помехи (шторка/переключатель)
        // — камеру на нём НЕ трогаем, иначе моргала бы зря.
        break;
    }
  }

  /// Включает/выключает удержание экрана. Идемпотентно — дёргает нативный вызов
  /// только при реальной смене состояния. Ошибки глушим: wakelock не критичен.
  void _syncWakelock(bool enable) {
    if (_wakelockEnabled == enable) return;
    _wakelockEnabled = enable;
    unawaited(WakelockPlus.toggle(enable: enable).catchError((_) {}));
  }

  Future<void> _startRingtone() async {
    if (!Platform.isIOS || _ringtone != null) return;
    try {
      final player = _ringtone = AudioPlayer();
      await player.setAudioContext(_ringtoneAudioContext);
      await player.setReleaseMode(ReleaseMode.loop);
      await player.setVolume(0.9);
      await player.play(AssetSource('audio/ringtone.wav'));
    } catch (_) {
      // Рингтон косметика — проигрывание не критично.
    }
  }

  Future<void> _stopRingtone() async {
    final player = _ringtone;
    _ringtone = null;
    if (player == null) return;
    try {
      await player.stop();
      await player.dispose();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = context.select((CommonCubit c) => c.state.settingsDevice.darkMode);

    return BlocConsumer<CallCubit, CallState>(
      // Рингтон завязан на статус: заводим на входящем, гасим при любом другом
      // (принятие → connecting, отбой → ended). Реагируем только на смену статуса.
      listenWhen: (prev, curr) => prev.callStatus != curr.callStatus,
      listener: (context, state) {
        if (state.callStatus == CallStatus.incoming) {
          unawaited(_startRingtone());
        } else {
          unawaited(_stopRingtone());
        }
        // Звонок завершился, пока мы в мини-окне (в т.ч. собеседник положил трубку):
        // просим натив закрыть PiP-окно, иначе оно осталось бы висеть после конца
        // звонка. В обычном (не PiP) режиме окно закрывать не нужно — экран звонка
        // свернёт CallGate штатной навигацией.
        if (_inPip && (state.callStatus == CallStatus.ended || state.callStatus == CallStatus.idle)) {
          unawaited(_pipChannel.invokeMethod<void>('exitPip').catchError((_) {}));
        }
      },
      builder: (context, state) {
        final cubit = context.read<CallCubit>();
        final video = state.video;
        final isVideoCall = video && (state.callStatus == CallStatus.active || state.callStatus == CallStatus.connecting);
        // Удерживаем экран включённым, пока идёт видеозвонок; на аудио и после
        // завершения — отпускаем (dispose тоже страхует на уходе с экрана).
        _syncWakelock(isVideoCall);
        // Android: разрешаем автовход в PiP по Home ровно на время видеозвонка.
        _syncPipAllowed(isVideoCall);
        // Дорожки берём из сервиса; mediaEpoch в state гарантирует, что при их
        // появлении/смене BlocBuilder перестроит рендереры (сами VideoTrack не
        // участвуют в equality состояния).
        final remoteTrack = cubit.remoteVideoTrack;
        final localTrack = cubit.localVideoTrack;
        // Удалённое видео реально видно, только когда дорожка есть И камера
        // собеседника не выключена: при выключении LiveKit мьютит дорожку, но не
        // отписывает — рендер застыл бы на последнем кадре, поэтому вместо него
        // показываем аватар (см. [CallSnapshot.remoteVideoOff]).
        final remoteVideoVisible = isVideoCall && remoteTrack != null && !state.remoteVideoOff;
        // Поверх видео — светлая палитра (контраст над картинкой); иначе — под тему.
        final palette = remoteVideoVisible ? _CallPalette.overMedia : _CallPalette.of(context, darkMode);

        // Единый Stack для обоих режимов (полный экран и мини-окно PiP). Удалённый
        // рендерер держим ПЕРВЫМ и БЕЗ ключа — его позиция в дереве не меняется при
        // входе/выходе PiP, поэтому его State (и нативный FlutterRTCVideoRenderer) не
        // пересоздаётся. Это критично: пересоздание рендерера во время звонка гонялось
        // с блоком `renderFrame:` на главном потоке и роняло приложение
        // (EXC_BAD_ACCESS в FlutterRTCVideoRenderer). В PiP лишь прячем панель
        // управления/имя и локальное превью — места нет и они не нужны.
        return ColoredBox(
          color: palette.bg,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (remoteVideoVisible) VideoTrackRenderer(remoteTrack, fit: VideoViewFit.cover),
              // В мини-окне без видео собеседника (камера у него выключена) —
              // его аватар по центру вместо пустого фона.
              if (_inPip && !remoteVideoVisible)
                Center(
                  child: _Avatar(state: state, palette: palette),
                ),
              // Локальное видео (наша камера) — картинкой-в-картинке, пока наша
              // камера включена. В PiP прячем (окно крошечное).
              if (!_inPip && isVideoCall && localTrack != null)
                Positioned(
                  right: 16,
                  top: 48,
                  width: 110,
                  height: 160,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: VideoTrackRenderer(localTrack, fit: VideoViewFit.cover, mirrorMode: VideoViewMirrorMode.auto),
                  ),
                ),
              if (!_inPip) _Overlay(state: state, showVideo: remoteVideoVisible, palette: palette),
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
                  style: TextStyle(color: palette.name, fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                // На активном звонке подпись — таймер разговора; иначе — статус.
                if (active && state.connectedAt != null)
                  _CallTimer(connectedAt: state.connectedAt!, color: palette.timer)
                else
                  Text(
                    _subtitle(context),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: palette.status, fontSize: 15),
                  ),
                // Индикатор качества связи (только на активном звонке, когда
                // LiveKit уже прислал оценку).
                if (active && state.quality != CallQuality.unknown) ...[
                  const SizedBox(height: 8),
                  _QualityIndicator(quality: state.quality, dim: palette.dim),
                ],
                // Микрофон собеседника выключен — значок ниже статуса связи.
                // if (active && state.remoteMicMuted) ...[const SizedBox(height: 8), _RemoteMicIndicator(dim: palette.dim)],
                // Диагностика соединения прямо на экране (этапы сигналинга/ICE/
                // медиа) — без выгрузки логов с устройства.
                // if (state.debug.isNotEmpty)
                //   Padding(
                //     padding: const EdgeInsets.only(top: 12),
                //     child: Text(
                //       state.debug,
                //       textAlign: TextAlign.center,
                //       style: TextStyle(color: palette.dim, fontSize: 11),
                //     ),
                //   ),
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
        // Кнопки «отклонить»/«принять» разнесены к краям экрана (spaceBetween +
        // боковой отступ), чтобы их было труднее нажать по ошибке.
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CircleButton(
                label: t.decline,
                icon: HugeIcons.strokeRoundedCallEnd02,
                color: CallView._red,
                iconColor: CallView._onAccent,
                palette: palette,
                onTap: cubit.reject,
              ),
              _CircleButton(
                label: t.accept,
                icon: HugeIcons.strokeRoundedCall02,
                color: CallView._green,
                iconColor: CallView._onAccent,
                palette: palette,
                onTap: cubit.accept,
              ),
            ],
          ),
        );
      // Исходящий/соединение показывают тот же набор управления, что и активный
      // разговор (микрофон/динамик/камера + отбой): на исходящем комната LiveKit
      // уже подключена и локальный трек опубликован (см. Calls.startCall →
      // _connectRoom), поэтому mute/динамик работают ещё до ответа абонента.
      case CallStatus.outgoing:
      case CallStatus.connecting:
      case CallStatus.active:
        return _mediaControls(context, cubit, state);
      case CallStatus.ended:
      case CallStatus.idle:
        return const SizedBox.shrink();
    }
  }

  /// Ряд кнопок управления медиа (микрофон/динамик, для видео — камера и её
  /// переключение) плюс кнопка отбоя. Общий для исходящего, соединения и
  /// активного разговора.
  Widget _mediaControls(BuildContext context, CallCubit cubit, CallState state) {
    final t = context.t.screenCall;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _CircleButton(
              label: state.micMuted ? t.micOn : t.micOff,
              icon: state.micMuted ? HugeIcons.strokeRoundedMicOff01 : HugeIcons.strokeRoundedMic01,
              color: state.micMuted ? palette.controlActiveBg : palette.controlBg,
              iconColor: palette.fg,
              palette: palette,
              onTap: cubit.toggleMic,
            ),
            // Выбор аудио-выхода. iOS — системный пикер (AVRoutePickerView:
            // iPhone/Speaker/BT/CarPlay/AirPlay); Android — свой лист устройств
            // (setCommunicationDevice). См. route_picker_button.dart /
            // audio_routes_sheet.dart.
            if (Platform.isIOS)
              RoutePickerButton(backgroundColor: palette.controlBg, iconColor: palette.fg, labelColor: palette.buttonLabel)
            else
              AudioOutputButton(backgroundColor: palette.controlBg, iconColor: palette.fg, labelColor: palette.buttonLabel),
            // Камера. В аудиозвонке — кнопка «Видео»: апгрейд аудио→видео
            // (публикует нашу камеру, собеседник увидит картинку). В видео —
            // вкл/выкл своей камеры плюс переключение фронт/тыл.
            if (!state.video)
              _CircleButton(
                label: t.startVideo,
                icon: HugeIcons.strokeRoundedVideo01,
                color: palette.controlBg,
                iconColor: palette.fg,
                palette: palette,
                onTap: cubit.enableVideo,
              )
            else ...[
              _CircleButton(
                label: state.cameraOff ? t.cameraOn : t.cameraOff,
                icon: state.cameraOff ? HugeIcons.strokeRoundedVideoOff : HugeIcons.strokeRoundedVideo01,
                color: state.cameraOff ? palette.controlActiveBg : palette.controlBg,
                iconColor: palette.fg,
                palette: palette,
                onTap: cubit.toggleCamera,
              ),
              _CircleButton(
                label: t.switchCamera,
                icon: HugeIcons.strokeRoundedCameraRotated01,
                color: palette.controlBg,
                iconColor: palette.fg,
                palette: palette,
                onTap: cubit.switchCamera,
              ),
            ],
          ],
        ),
        const SizedBox(height: 24),
        _CircleButton(
          label: t.hangup,
          icon: HugeIcons.strokeRoundedCallEnd02,
          color: CallView._red,
          iconColor: CallView._onAccent,
          palette: palette,
          onTap: cubit.hangup,
        ),
      ],
    );
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
          case CallEndReason.notAllowed:
            return t.endedNotAllowed;
          case CallEndReason.noConnection:
            return t.endedNoConnection;
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

/// Значок «микрофон собеседника выключен»: перечёркнутый микрофон + подпись.
/// Показывается под индикатором качества связи на активном звонке.
// class _RemoteMicIndicator extends StatelessWidget {
//   final Color dim;
//
//   const _RemoteMicIndicator({required this.dim});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(CupertinoIcons.mic_slash_fill, color: dim, size: 14),
//         const SizedBox(width: 6),
//         Text(context.t.screenCall.remoteMicMuted, style: TextStyle(color: dim, fontSize: 12)),
//       ],
//     );
//   }
// }

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
    final avatar = bytes != null
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
                ));

    return SizedBox(
      width: _size,
      height: _size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: avatar),
          // Бейдж «микрофон собеседника выключен» — перечёркнутый микрофон в углу
          // аватара, чтобы было однозначно видно, чей это микрофон.
          if (state.remoteMicMuted) Positioned(right: -2, bottom: -2, child: _MicBadge(palette: palette)),
        ],
      ),
    );
  }
}

/// Круглый бейдж с перечёркнутым микрофоном поверх угла аватара собеседника.
/// Обводка цветом фона экрана визуально «вырезает» бейдж из аватара.
class _MicBadge extends StatelessWidget {
  final _CallPalette palette;

  const _MicBadge({required this.palette});

  static const _size = 36.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        color: CallView._red,
        shape: BoxShape.circle,
        border: Border.all(color: palette.bg, width: 3),
      ),
      alignment: Alignment.center,
      child: const HugeIcon(icon: HugeIcons.strokeRoundedMicOff01, color: CallView._onAccent, size: 18),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final String label;
  final List<List<dynamic>> icon;
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
            child: HugeIcon(icon: icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: palette.buttonLabel, fontSize: 13)),
        ],
      ),
    );
  }
}
