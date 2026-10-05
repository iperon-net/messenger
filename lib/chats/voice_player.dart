import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../models.dart' as models;

/// Проигрывание голосовых: одно на всё приложение (новое останавливает
/// предыдущее), пузыри слушают [VoicePlayer.instance] и рисуют прогресс.
///
/// В демо у голосовых из истории нет файла — тогда проигрывание имитируется
/// таймером (прогресс идёт, звука нет).
class VoicePlayer extends ChangeNotifier {
  VoicePlayer._();

  static final instance = VoicePlayer._();

  AudioPlayer? _player;
  Timer? _fake;

  /// Сообщение, которое играет или стоит на паузе; `null` — ничего.
  String? currentID;
  bool playing = false;
  Duration position = Duration.zero;
  Duration total = Duration.zero;

  /// Доля проигранного у сообщения [id] (0, если оно не текущее).
  double progressOf(String id) {
    if (id != currentID || total <= Duration.zero) return 0;
    return (position.inMicroseconds / total.inMicroseconds).clamp(0.0, 1.0);
  }

  bool isPlaying(String id) => playing && id == currentID;

  /// Тап по кнопке в пузыре: играть / пауза / продолжить.
  Future<void> toggle(models.Message message) async {
    if (message.id == currentID) {
      return playing ? pause() : resume();
    }
    await stop();
    currentID = message.id;
    total = Duration(seconds: message.duration);
    position = Duration.zero;
    playing = true;
    notifyListeners();
    if (message.localPath.isEmpty || !File(message.localPath).existsSync()) {
      _startFake();
      return;
    }
    await (_player ??= _create()).play(DeviceFileSource(message.localPath));
  }

  Future<void> pause() async {
    playing = false;
    _fake?.cancel();
    notifyListeners();
    await _player?.pause();
  }

  Future<void> resume() async {
    if (currentID == null) return;
    playing = true;
    notifyListeners();
    if (_player?.state == PlayerState.paused) {
      await _player!.resume();
    } else {
      _startFake();
    }
  }

  /// Тап/протяжка по волне текущего голосового — перемотка на долю [fraction].
  Future<void> seek(String id, double fraction) async {
    if (id != currentID) return;
    position = total * fraction.clamp(0.0, 1.0);
    notifyListeners();
    if (_fake == null) await _player?.seek(position);
  }

  Future<void> stop() async {
    _fake?.cancel();
    _fake = null;
    final wasActive = currentID != null;
    currentID = null;
    playing = false;
    position = Duration.zero;
    if (wasActive) notifyListeners();
    await _player?.stop();
  }

  AudioPlayer _create() {
    final player = AudioPlayer();
    player.onPositionChanged.listen((value) {
      position = value;
      notifyListeners();
    });
    player.onDurationChanged.listen((value) {
      if (value > Duration.zero) total = value;
    });
    player.onPlayerComplete.listen((_) => stop());
    return player;
  }

  void _startFake() {
    _fake?.cancel();
    const tick = Duration(milliseconds: 50);
    _fake = Timer.periodic(tick, (_) {
      position += tick;
      if (position >= total) {
        stop();
      } else {
        notifyListeners();
      }
    });
  }
}
