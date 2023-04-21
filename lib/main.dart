import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pesan_1/pages/home_pages.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(onBackgoundMessaging);
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> onBackgoundMessaging(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(message.notification!.title);
  print(message.notification!.body);
  print(message.data);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePages(),
    );
  }
}
