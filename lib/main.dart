import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parquecambui/firebase_options.dart';
import 'package:parquecambui/pq_cambui_app.dart';
import 'package:parquecambui/src/config/hive_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) await HiveConfig.start();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final status = await FirebaseMessaging.instance.requestPermission();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const PqCambuiApp());
}
