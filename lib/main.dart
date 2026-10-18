import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app.dart';
import 'core/services/push_notification_service.dart';
import 'core/services/storage_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase First
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Persistent Storage Service globally before runApp
  await Get.putAsync(() => StorageService().init());

  // Initialize Push Notification Service
  await Get.putAsync(() => PushNotificationService.init());

  runApp(const MyApp());
}
