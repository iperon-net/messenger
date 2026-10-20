import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';

import '../../chats/chats_sync.dart';
import '../../chats/reactions_list.dart';
import '../../cubit.dart';
import '../../models.dart' as models;
import 'chat_common.dart';
import 'reactions_list_cupertino.dart';
import 'reactions_list_material.dart';

/// «Кто поставил реакцию» на сообщение группы (подэтап 3.4): из меню
/// сообщения и долгим нажатием на реакцию под ним ([emoji] — сразу её
/// вкладка). iOS — лист `showCupertinoModalPopup`, Android — bottom sheet.
Future<void> showReactionsList(BuildContext context, ChatCubit cubit, models.Message message, {String emoji = ''}) {
  final controller = ReactionsListController(
    load: (emoji, cursor) => cubit.reactionsPage(message, emoji: emoji, cursor: cursor),
  )..open(reactionTabs(message.reactions), emoji: emoji);
  // Лист уже закрыт (его закрывает строка) — профиль из окна чата.
  void openProfile(MessageReactor reactor) {
    if (reactor.isSelf || reactor.userID.isEmpty || !context.mounted) return;
    unawaited(openUserProfile(context, reactor.userID));
  }

  final shown = Platform.isIOS
      ? showReactionsListCupertino(context, controller, onTap: openProfile)
      : showReactionsListMaterial(context, controller, onTap: openProfile);
  return shown.whenComplete(controller.dispose);
}

/// Почему список вкладки не показан.
enum ReactionsListError { none, offline, failed }

/// Состояние вкладки: загруженное, курсор продолжения и ошибка.
class ReactionsTabState {
  final List<MessageReactor> reactors;
  final String cursor;
  final bool loading;

  /// Дальше листать нечего.
  final bool done;
  final ReactionsListError error;

  const ReactionsTabState({
    this.reactors = const [],
    this.cursor = '',
    this.loading = false,
    this.done = false,
    this.error = ReactionsListError.none,
  });

  ReactionsTabState copyWith({List<MessageReactor>? reactors, String? cursor, bool? loading, bool? done, ReactionsListError? error}) =>
      ReactionsTabState(
        reactors: reactors ?? this.reactors,
        cursor: cursor ?? this.cursor,
        loading: loading ?? this.loading,
        done: done ?? this.done,
        error: error ?? this.error,
      );
}

/// Вкладки и постраничная загрузка списка: у каждой вкладки (эмодзи; «Все» —
/// пустой) свой список и курсор, грузится при первом показе и при прокрутке
/// к концу. Без сети — [ReactionsListError.offline] (показать «Нет
/// соединения» и «Повторить»), а не пустой список.
class ReactionsListController extends ChangeNotifier {
  final Future<ReactionsListPage> Function(String emoji, String cursor) load;

  ReactionsListController({required this.load});

  List<({String emoji, int count})> _tabs = const [];
  String _emoji = '';
  final _states = <String, ReactionsTabState>{};
  bool _disposed = false;

  List<({String emoji, int count})> get tabs => _tabs;

  /// Выбранная вкладка (пусто — «Все»).
  String get emoji => _emoji;
  ReactionsTabState get current => _states[_emoji] ?? const ReactionsTabState();

  /// Показать список: вкладки [tabs] (см. [reactionTabs]), открыть [emoji]
  /// (нет такой — первую).
  void open(List<({String emoji, int count})> tabs, {String emoji = ''}) {
    _tabs = tabs;
    _emoji = tabs.any((tab) => tab.emoji == emoji) ? emoji : (tabs.isEmpty ? '' : tabs.first.emoji);
    unawaited(more());
  }

  void select(String emoji) {
    if (_emoji == emoji) return;
    _emoji = emoji;
    notifyListeners();
    if (current.reactors.isEmpty && !current.done) unawaited(more(retry: true));
  }

  /// Следующая страница выбранной вкладки. После ошибки — только по
  /// [retry] («Повторить», выбор вкладки), а не при каждой прокрутке.
  Future<void> more({bool retry = false}) async {
    final emoji = _emoji;
    final state = current;
    if (state.loading || state.done || (!retry && state.error != ReactionsListError.none)) return;
    _states[emoji] = state.copyWith(loading: true, error: ReactionsListError.none);
    notifyListeners();
    try {
      final page = await load(emoji, state.cursor);
      _states[emoji] = state.copyWith(
        reactors: appendReactors(state.reactors, page.reactors),
        cursor: page.nextCursor,
        loading: false,
        done: page.nextCursor.isEmpty,
        error: ReactionsListError.none,
      );
    } on ChatsOfflineException {
      _states[emoji] = state.copyWith(loading: false, error: ReactionsListError.offline);
    } on Exception {
      _states[emoji] = state.copyWith(loading: false, error: ReactionsListError.failed);
    }
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
