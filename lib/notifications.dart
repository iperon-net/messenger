import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'di.dart';
import 'firebase_options.dart';
import 'logger.dart';
import 'routers.dart';

// Documentation - https://firebase.google.com/docs/cloud-messaging/flutter/receive
// Tutorial - https://www.youtube.com/watch?v=uKz8tWbMuUw

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  getIt.registerSingletonAsync<Logger>(() async => Logger());
  getIt.registerSingletonAsync<Routers>(() async => Routers(), dependsOn: [Logger]);
  getIt.registerSingletonAsync<Notifications>(() async => Notifications(), dependsOn: [Logger]);
  await getIt.allReady();

  final logger = getIt.get<Logger>();
  final notifications = getIt.get<Notifications>();

  final details = notifications.notificationDetails();
  notifications.show(notificationDetails: details);

  logger.debug("Handling a background message: ${message.messageId}");
}


class Notifications {
  final _logger = getIt.get<Logger>();
  final _notificationsPlugin = FlutterLocalNotificationsPlugin();
  final _androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

  // NotificationDetails
  NotificationDetails notificationDetails() {
    final androidDetails = AndroidNotificationDetails(
      "notification",
      "General notifications",
      channelDescription: "This channel will receive notifications from the messenger, we will not send spam or marketing messages",
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    return NotificationDetails(android: androidDetails);
  }

  void show({required NotificationDetails notificationDetails}) {
    _notificationsPlugin.show(
      Random().nextInt(100000000),
      "Тестовое сообщение",
      "В данный канал будут приходить уведомления от мессенджера",
      notificationDetails,
    );
  }

  Future<void> initialization() async {
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      _logger.info("onTokenRefresh $fcmToken");
    }).onError((err) {
      _logger.info("onTokenRefresh ${err.toString()}");
    });

    final initializationSettings = InitializationSettings(android: _androidSettings);
    _notificationsPlugin.initialize(initializationSettings);

    final details = notificationDetails();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      show(notificationDetails: details);

      _logger.info("FCM message ${message.messageId}, ${message.data}, ${message.category}");
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> updateToken() async {
    final settings = await FirebaseMessaging.instance.requestPermission(provisional: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      _logger.info("FCM token is available $fcmToken");
    }

  }

}

//     final notificationSettings = await FirebaseMessaging.instance.requestPermission(provisional: true);
