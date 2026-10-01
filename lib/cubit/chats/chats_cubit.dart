import 'package:bloc/bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';

import 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  ChatsCubit() : super(ChatsState());

  final logger = getIt.get<Logger>();

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));

    await checkNotificationPermission();
    if (isClosed) return;

    emit(state.copyWith(status: Status.success));
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
