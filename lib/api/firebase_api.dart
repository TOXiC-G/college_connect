import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
  print('Title : ${message.notification?.title}');
  print('Body : ${message.notification?.body}');
  print('Data : ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final secureStorage = FlutterSecureStorage();

  final _androidChannel = const AndroidNotificationChannel(
      'high_importance_channel', 'High Importance Notifications',
      description: 'This channel is used for important notifications',
      importance: Importance.high);

  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    await secureStorage.write(key: 'fcmToken', value: fCMToken);
    print('FCM Token: $fCMToken');
    FirebaseMessaging.onBackgroundMessage((handleBackgroundMessage));
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  _androidChannel.id, _androidChannel.name,
                  channelDescription: _androidChannel.description,
                  icon: 'launch_background')),
          payload: jsonEncode(message.toMap()));
    });
  }

  // Future initLocalNoitifications() async {
  //   const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  //   const iOS = DarwinInitializationSettings();
  //   const settings = InitializationSettings(android: android, iOS: iOS);

  //   await _localNotifications.initialize(settings,
  //       onSelectNotification: (payload) {
  //     final message = RemoteMessage.fromMap(jsonDecode(payload!));
  //   });

  //   final platform = _localNotifications.resolvePlatformSpecificImplementation()

  // }
}
