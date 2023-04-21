import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pesan_1/massage_screen.dart';

class NotificationsService {
  FirebaseMessaging massaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNatificationsPlugin =
      FlutterLocalNotificationsPlugin();

  localNotificationsInit(BuildContext context, RemoteMessage message) async {
    var andoridInisializations =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings =
        InitializationSettings(android: andoridInisializations);
    await _flutterLocalNatificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        handleMessage(context, message);
      },
    );
  }

  firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((masagge) {
      print(masagge.notification!.title);
      print(masagge.data.toString());
      print(masagge.data['type'].toString());
      print(masagge.data['id'].toString());
      if (Platform.isAndroid) {
        localNotificationsInit(context, masagge);
        showNotifications(masagge);
      } else {
        showNotifications(masagge);
      }
    });
  }

  showNotifications(RemoteMessage masagge) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random().nextInt(10000).toString(), 'Hight Notifications Inpontant');

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: 'your chanel details',
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker');

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    Future.delayed(
      Duration.zero,
      () {
        _flutterLocalNatificationsPlugin.show(
            0,
            masagge.notification!.title.toString(),
            masagge.notification!.body.toString(),
            notificationDetails);
      },
    );
  }

  requestNotificationsPermissions() async {
    NotificationSettings settings = await massaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user granted premissions');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('user granted profesional premissions');
    } else {
      print('user denied premissions');
    }
  }

  Future<String> getToken() async {
    final token = await massaging.getToken();
    return token!;
  }

  isTokenRefresh() async {
    massaging.onTokenRefresh.listen((event) {
      event.toString();
      print('refresh');
    });
  }

  setupInteractMessage(BuildContext context) async {
    RemoteMessage? interactMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (interactMessage != null) {
      handleMessage(context, interactMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  handleMessage(BuildContext context, RemoteMessage message) async {
    if (message.data['id'] == '12345678') {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessageScreen(
              id: message.data['id'],
            ),
          ));
    }
  }
}
