import 'dart:convert';
import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:zoom_clone/controlers/join_metting_method.dart';
import 'package:zoom_clone/main.dart';
import 'package:zoom_clone/provider/join_metting_provide.dart';
import 'package:cloud_functions/cloud_functions.dart';
class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
      carPlay: true,
      announcement: true,
      criticalAlert: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print("User declined or has not accepted permission");
    }
  }

  void firebaseInit(BuildContext context) async {
    await requestNotificationPermission();
    FirebaseMessaging.onMessage.listen((message) async {
      print(message.data);
      await initLocalNotification(context, message);
      showNotification(message);
    });
  }

  Future<void> initLocalNotification(
    BuildContext context,
    RemoteMessage message,
  ) async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidInitializationSettings,
          iOS: iosInitializationSettings,
        );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        final data = jsonDecode(response.payload!);
        print("message data ${data}");
        messageHendaler(data);
      },
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'high_importance_notification',
      description: 'Channel for app notifications',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: channel.importance,
          priority: Priority.high,
          playSound: channel.playSound,
          enableVibration: channel.enableVibration,
          icon: '@mipmap/ic_launcher',
        );
    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    await _localNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
      payload: jsonEncode(message.data),
    );
  }

  Future<void> setupInteractMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    if (initialMessage != null) {

      Future.delayed(const Duration(milliseconds: 500), () {
      messageHendaler(initialMessage.data);
    });
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
       Future.delayed(const Duration(milliseconds: 500), () {
      messageHendaler(message.data);
    });
    });
  }

  Future<String?> getDeviceToken() async {
    return await _firebaseMessaging.getToken();
  }

  void messageHendaler(Map<String, dynamic> data) {
    final notifier = globalContainer.read(joinMettingProvide.notifier);
    final state = globalContainer.read(joinMettingProvide);
    final User? user = FirebaseAuth.instance.currentUser;
    print("mettting id ${data['mettingID']}");
    print("data ${data}");
    joinMettingMethod(
      notifier,
      state,
      user!.displayName ?? "Guset",
      data['mettingID'],
    );
  }
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  developer.log('Background message received: ${message.messageId}');
}

Future<void> sendMettingStartNotification(
    String token,
    String mettingID,
) async {

  final callable =
      FirebaseFunctions.instance.httpsCallable('sendNotificationToDevice');

  await callable.call({
    "token": token,
    "mettingID": mettingID,
  });
}
