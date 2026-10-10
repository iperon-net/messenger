import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../chats/chats_data_source.dart';
import '../../chats/chats_remote_data_source.dart';
import '../../demo/chats_demo_data_source.dart';
import '../../models.dart' as models;

import 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  ChatsCubit() : super(ChatsState());

  final logger = getIt.get<Logger>();

  ChatsDataSource? _source;
  StreamSubscription<List<models.Chat>>? _chatsSubscription;
  StreamSubscription<List<models.ChatFolder>>? _foldersSubscription;

  /// [demo] — флаг «Демо чатов» из `settingsDevice`. [archive] — экран «Архив»:
  /// баннер уведомлений там не нужен.
  Future<void> initialization({required bool demo, bool archive = false}) async {
    emit(state.copyWith(status: Status.loading));

    setDemo(demo);
    if (!archive) await checkNotificationPermission();
    if (isClosed) return;

    emit(state.copyWith(status: Status.success));
  }

  /// Переключает источник данных: демо — фейковые чаты, иначе настоящие
  /// ([ChatsRemoteDataSource]: SQLite-кэш + сервер, пока только личные).
  void setDemo(bool demo) {
    if (_source != null && demo == state.demo) return;
    _chatsSubscription?.cancel();
    _foldersSubscription?.cancel();
    _source = demo ? ChatsDemoDataSource.instance : ChatsRemoteDataSource.instance;
    emit(state.copyWith(demo: demo, chats: const [], folders: const [], folderIndex: 0));

    final source = _source;
    if (source == null) return;
    _chatsSubscription = source.watchChats().listen((chats) {
      if (!isClosed) emit(state.copyWith(chats: chats));
    });
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

  void setFolderIndex(int index) {
    if (index != state.folderIndex) emit(state.copyWith(folderIndex: index));
  }

  void search(String query) => emit(state.copyWith(query: query.trim()));

  Future<void> setPinned(models.Chat chat, bool pinned) async => _source?.setPinned(chat.id, pinned);
  Future<void> setMuted(models.Chat chat, bool muted, {DateTime? until}) async => _source?.setMuted(chat.id, muted, until: until);
  Future<void> setArchived(models.Chat chat, bool archived) async => _source?.setArchived(chat.id, archived);
  Future<void> setRead(models.Chat chat, bool read) async => _source?.setRead(chat.id, read);
  Future<void> delete(models.Chat chat) async => _source?.delete(chat.id);

  Future<void> readAll(models.ChatFolder folder) async =>
      _source?.readAll(state.chats.where((c) => folder.matches(c)).map((c) => c.id).toList());

  Future<void> deleteFolder(models.ChatFolder folder) async => _source?.deleteFolder(folder.id);

  @override
  Future<void> close() async {
    await _chatsSubscription?.cancel();
    await _foldersSubscription?.cancel();
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
