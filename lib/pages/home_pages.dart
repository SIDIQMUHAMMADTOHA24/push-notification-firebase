import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pesan_1/notifications_setting.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  NotificationsService notificationsService = NotificationsService();

  @override
  void initState() {
    notificationsService.requestNotificationsPermissions();
    notificationsService.firebaseInit(context);
    notificationsService.setupInteractMessage(context);
    //! notificationsService.isTokenRefresh();
    notificationsService.getToken().then((value) {
      if (kDebugMode) {
        print('device token');
        print(value.toString());
      }
    });
    super.initState();
  }

  postData(String value) async {
    try {
      var notificationData = {
        'title': 'tess',
        'body': 'join with me',
      };

      var data = {
        'notification': notificationData,
        'to': value.toString(),
        'data': {'type': 'message', 'id': '12345678'}
      };

      var response = await Dio().post(
        'https://fcm.googleapis.com/fcm/send',
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAA4b5eYSk:APA91bE-iSHhvpwzwAh1Ir6SncHhQmiLJEAqg3ggGKiVaqHVoMYO8msaSOzMEFeDvoR5Ai5FQQIBsQ1qsCItrqAUtoW60HrKpavrfuFspDIYsHeo_eyu4UkAGdsolWsoRUHaggf-uxnX',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Notification Sent');
      } else {
        print('Notification Failed');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              onPressed: () {
                notificationsService.getToken().then((value) async {
                  postData(value);
                });
              },
              child: Text('Simpele Notifications')),
        ]),
      ),
    );
  }
}
