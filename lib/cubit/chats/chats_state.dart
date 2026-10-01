import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';

part 'chats_state.mapper.dart';

@MappableClass()
class ChatsState with ChatsStateMappable {
  final Status status;

  /// Разрешение на уведомления не выдано (iOS — authorization, Android 13+ —
  /// POST_NOTIFICATIONS). Управляет баннером-объяснением на вкладке.
  final bool notificationsMissing;

  /// Пользователь закрыл баннер — не показываем до конца сессии.
  final bool notificationsBannerDismissed;

  const ChatsState({this.status = Status.initialization, this.notificationsMissing = false, this.notificationsBannerDismissed = false});

  bool get showNotificationsBanner => notificationsMissing && !notificationsBannerDismissed;
}
