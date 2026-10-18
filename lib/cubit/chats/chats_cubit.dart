import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../chats/chats_data_source.dart';
import '../../chats/chats_remote_data_source.dart';
import '../../chats/chats_sync.dart';
import '../../chats/secret/secret_chats_list.dart';
import '../../chats/secret/secret_chats_sync.dart';
import '../../models.dart' as models;
import '../../repositories/repositories.dart';
import '../../utils.dart';

import 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  ChatsCubit() : super(ChatsState());

  final logger = getIt.get<Logger>();
  final utils = getIt.get<Utils>();
  final repositories = getIt.get<Repositories>();

  ChatsDataSource? _source;
  StreamSubscription<List<models.Chat>>? _chatsSubscription;
  StreamSubscription<List<models.Chat>>? _secretSubscription;

  /// Обычные (из источника) и секретные (только этого устройства) чаты —
  /// список показывает их вместе.
  List<models.Chat> _regular = const [];
  List<models.Chat> _secret = const [];
  StreamSubscription<List<models.ChatFolder>>? _foldersSubscription;
  StreamSubscription<void>? _hiddenSubscription;

  /// [demo] — флаг «Демо чатов» из `settingsDevice`. [archive] — экран «Архив»:
  /// баннер уведомлений там не нужен.
  Future<void> initialization({required bool demo, bool archive = false}) async {
    emit(state.copyWith(status: Status.loading));

    // Локально скрытые профили: читаем сразу и перечитываем по сигналу (профиль
    // скрыли/показали на отдельном экране — вкладка живёт в IndexedStack).
    _hiddenSubscription ??= repositories.hiddenProfiles.changes.listen((_) => _reloadHidden());
    await _reloadHidden();
    if (isClosed) return;

    setDemo(demo);
    if (!archive) await checkNotificationPermission();
    if (isClosed) return;

    emit(state.copyWith(status: Status.success));
  }

  /// Переключает источник данных: демо — фейковые чаты, иначе настоящие
  /// ([ChatsRemoteDataSource]: SQLite-кэш + сервер, пока только личные) — при
  /// включённом флаге «Серверные чаты», без него — пусто (см. [chatsDataSource]).
  /// Зовётся и при смене флага: источник пересобирается, если поменялся.
  void setDemo(bool demo) {
    final next = chatsDataSource(demo: demo);
    if (next != null && identical(next, _source)) return;
    _chatsSubscription?.cancel();
    _foldersSubscription?.cancel();
    _secretSubscription?.cancel();
    _secretSubscription = null;
    _source = next;
    _regular = const [];
    _secret = const [];
    emit(state.copyWith(demo: demo, chats: const [], folders: const [], folderIndex: 0));

    final source = _source;
    if (source == null) return;
    _chatsSubscription = source.watchChats().listen((chats) {
      _regular = chats;
      _emitChats();
    });
    // Секретные чаты — только у настоящих (не в демо).
    if (!demo) {
      _secretSubscription = watchSecretChats().listen((chats) {
        _secret = chats;
        _emitChats();
      });
    }
    _foldersSubscription = source.watchFolders().listen((folders) {
      if (isClosed) return;
      // Папки переставили / изменили на экране «Папки» — остаёмся на той же
      // папке; её удалили — на соседней.
      final current = state.folderIndex < state.folders.length ? state.folders[state.folderIndex].id : null;
      final kept = folders.indexWhere((f) => f.id == current);
      final index = kept >= 0 ? kept : state.folderIndex.clamp(0, folders.isEmpty ? 0 : folders.length - 1);
      emit(state.copyWith(folders: folders, folderIndex: index));
    });
  }

  void _emitChats() {
    if (!isClosed) emit(state.copyWith(chats: [..._regular, ..._secret]));
  }

  void setFolderIndex(int index) {
    if (index != state.folderIndex) emit(state.copyWith(folderIndex: index));
  }

  /// Поиск + раскрытие скрытых по «/код-фразе». Асинхронный из-за sha256 фразы
  /// (считаем на ввод, не в build).
  Future<void> search(String query) async {
    final trimmed = query.trim();
    final revealed = await _revealedFor(trimmed, state.hiddenHashByHex);
    if (isClosed) return;
    emit(state.copyWith(query: trimmed, revealedHex: revealed));
  }

  /// hex(userID) скрытых профилей, чью код-фразу содержит запрос «/фраза».
  Future<Set<String>> _revealedFor(String query, Map<String, String> hidden) async {
    if (!query.startsWith('/') || hidden.isEmpty) return const {};
    final phrase = query.substring(1);
    if (phrase.trim().isEmpty) return const {};
    final hash = await utils.passphraseHash(phrase);
    return hidden.entries.where((e) => e.value == hash).map((e) => e.key).toSet();
  }

  /// Перечитывает набор скрытых профилей из БД и пересчитывает раскрытые под
  /// текущий запрос.
  Future<void> _reloadHidden() async {
    try {
      final hidden = await repositories.hiddenProfiles.hashByHex();
      final revealed = await _revealedFor(state.query, hidden);
      if (isClosed) return;
      emit(state.copyWith(hiddenHashByHex: hidden, revealedHex: revealed));
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  /// Серверное действие без сети: не делаем вид, что получилось, — экран
  /// покажет «Нет соединения» (см. `offlineNotice`). false — не выполнено.
  Future<bool> _online(Future<void>? Function() action) async {
    try {
      await action();
      return true;
    } on ChatsOfflineException {
      if (!isClosed) emit(state.copyWith(offlineNotice: state.offlineNotice + 1));
      return false;
    }
  }

  /// Закрепить — не больше [models.chatPinnedLimit] в списке (без архива):
  /// сверх — объяснение без запроса; сервер проверяет тот же лимит (закреп с
  /// другого устройства мог ещё не долететь).
  Future<void> setPinned(models.Chat chat, bool pinned) async {
    if (pinned && !chat.pinned) {
      final count = state.chats.where((c) => c.pinned && !c.archived && !c.hiddenInList).length;
      if (count >= models.chatPinnedLimit) return _pinnedLimit();
    }
    try {
      await _online(() => _source?.setPinned(chat.id, pinned));
    } on ChatsRequestException catch (error) {
      if (!error.isPinnedLimit) rethrow;
      _pinnedLimit();
    }
  }

  void _pinnedLimit() {
    if (!isClosed) emit(state.copyWith(pinnedLimitNotice: state.pinnedLimitNotice + 1));
  }

  Future<void> setMuted(models.Chat chat, bool muted, {DateTime? until}) => _online(() => _source?.setMuted(chat.id, muted, until: until));
  Future<void> setArchived(models.Chat chat, bool archived) => _online(() => _source?.setArchived(chat.id, archived));
  Future<void> setRead(models.Chat chat, bool read) => _online(() => _source?.setRead(chat.id, read));
  Future<void> readReactions(models.Chat chat) => _online(() => _source?.readAllReactions(chat.id));

  /// [forEveryone] — и у собеседника (личный чат: его история тоже очищается).
  Future<void> delete(models.Chat chat, {bool forEveryone = false}) => _online(() => _source?.delete(chat.id, forEveryone: forEveryone));

  Future<void> readAll(models.ChatFolder folder) async =>
      _source?.readAll(state.chats.where((c) => folder.matches(c) && !c.isSecret).map((c) => c.id).toList());

  /// Удалить секретный чат: закрыть у собеседника (с перепиской) и убрать с
  /// устройства. Без сети — «Нет соединения» (закрыть на сервере нужно сразу,
  /// иначе собеседник продолжит писать в него).
  Future<void> deleteSecret(models.Chat chat) => _online(
    () => SecretChatsSync.instance.discard(
      utils.hexToBytes(chat.id.substring(secretChatIDPrefix.length)),
      deleteHistory: true,
      removeLocal: true,
    ),
  );

  Future<void> deleteFolder(models.ChatFolder folder) => _online(() => _source?.deleteFolder(folder.id));

  @override
  Future<void> close() async {
    await _chatsSubscription?.cancel();
    await _foldersSubscription?.cancel();
    await _secretSubscription?.cancel();
    await _hiddenSubscription?.cancel();
    return super.close();
  }

  /// Статус разрешения на уведомления БЕЗ системного диалога — только для
  /// показа мягкого баннера-объяснения. Сам запрос — по кнопке в баннере
  /// ([requestNotificationPermission]): не на старте и не сразу после логина,
  /// а там, где пользователь ждёт уведомлений (как с микрофоном на «Звонках»).
  Future<void> checkNotificationPermission() async {
    try {
      final status = await Permission.notification.status;
      if (isClosed) return;
      emit(state.copyWith(notificationsMissing: !status.isGranted && !status.isProvisional));
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  /// Кнопка «Разрешить» в баннере: системный запрос, а если система диалог уже
  /// не покажет (отклонено навсегда) — системные настройки приложения.
  Future<void> requestNotificationPermission() async {
    try {
      final status = await Permission.notification.status;
      if (isClosed) return;
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      } else {
        await Permission.notification.request();
      }
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
    if (isClosed) return;
    await checkNotificationPermission();
  }

  void dismissNotificationsBanner() {
    if (state.notificationsBannerDismissed) return;
    emit(state.copyWith(notificationsBannerDismissed: true));
  }
}
