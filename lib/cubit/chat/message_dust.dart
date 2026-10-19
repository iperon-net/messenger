import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../models.dart' as models;

/// «Пыль» при удалении сообщений (как в Telegram) для окна чата — обычного
/// ([ChatCubit]) и секретного ([SecretChatCubit]). Удаляемые держатся в ленте,
/// пока окно снимает с них снимок и рассыпает его (`deleteWithDust` /
/// `dissolveRemoved` в `chat_common.dart`), потом их место схлопывается.
mixin MessageDust<S> on Cubit<S> {
  /// Сколько строка держит место после старта пыли (видна пыль, потом место
  /// схлопывается — сам схлоп анимирует лента).
  static const vanishDuration = Duration(milliseconds: 950);

  /// Удаляемые с «пылью» (id → сообщение): пока пыль летит, они остаются в
  /// ленте, даже если источник их уже убрал, — иначе соседние строки прыгнули
  /// бы на их место раньше пыли.
  final _retained = <String, models.Message>{};
  List<models.Message> _sourceMessages = const [];
  Timer? _vanishTimer;
  final _dustRequests = StreamController<List<String>>.broadcast();

  /// Лента сейчас (`state.messages`).
  List<models.Message> get dustShown;

  /// Рассыпающиеся сейчас (`state.vanishingIDs`).
  List<String> get dustVanishing;

  /// Записать ленту и рассыпающиеся в состояние.
  void emitDust({required List<models.Message> messages, required List<String> vanishingIDs});

  /// Сообщения, удалённые не здесь (собеседником, на другом моём устройстве,
  /// автоудалением): они уже придержаны в ленте — окно снимает их и рассыпает
  /// пылью ([vanish]) или, если их не видно, отпускает ([releaseDust]).
  Stream<List<String>> get dustRequests => _dustRequests.stream;

  /// Свежая лента из источника — вместе с придержанными для пыли.
  List<models.Message> withDustRetained(List<models.Message> fresh) {
    _sourceMessages = fresh;
    return _withRetained(fresh);
  }

  List<models.Message> _withRetained(List<models.Message> messages) {
    if (_retained.isEmpty) return messages;
    final result = [...messages];
    for (final kept in _retained.values) {
      if (result.any((m) => m.id == kept.id)) continue;
      final index = result.indexWhere((m) => m.date.isAfter(kept.date));
      result.insert(index < 0 ? result.length : index, kept);
    }
    return result;
  }

  /// Перед удалением с «пылью»: держать [ids] в ленте, пока не [vanish] /
  /// [releaseDust].
  void holdForDust(List<String> ids) {
    for (final m in dustShown) {
      if (ids.contains(m.id)) _retained[m.id] = m;
    }
  }

  /// Удаление прошло — строки [ids] становятся пустым местом (пыль рисуется
  /// поверх), через [vanishDuration] уходят из ленты совсем.
  void vanish(List<String> ids) {
    if (isClosed) return;
    emitDust(messages: dustShown, vanishingIDs: {...dustVanishing, ...ids}.toList());
    _vanishTimer?.cancel();
    _vanishTimer = Timer(vanishDuration, () {
      if (isClosed) return;
      final gone = dustVanishing.toSet();
      _retained.removeWhere((id, _) => gone.contains(id));
      emitDust(messages: _withRetained(_sourceMessages), vanishingIDs: const []);
    });
  }

  /// Удалённые не нами (см. [dustRequests]): придержать строки, пока окно не
  /// снимет с них снимок. Свои удаления ([holdForDust]) уже придержаны.
  void dissolveRemoved(List<String> ids) {
    if (isClosed) return;
    final shown = {for (final m in dustShown) m.id};
    final vanishing = dustVanishing.toSet();
    final fresh = [
      for (final id in ids)
        if (shown.contains(id) && !_retained.containsKey(id) && !vanishing.contains(id)) id,
    ];
    if (fresh.isEmpty || !_dustRequests.hasListener) return;
    holdForDust(fresh);
    _dustRequests.add(fresh);
  }

  /// Удалить не вышло — больше не держим.
  void releaseDust(List<String> ids) {
    for (final id in ids) {
      _retained.remove(id);
    }
    if (!isClosed) emitDust(messages: _withRetained(_sourceMessages), vanishingIDs: dustVanishing);
  }

  @override
  Future<void> close() async {
    _vanishTimer?.cancel();
    await _dustRequests.close();
    return super.close();
  }
}
