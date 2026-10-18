import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../firebase_options.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import 'storage_service.dart';

final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel _defaultChannel = AndroidNotificationChannel(
  'velix_default_channel',
  'Velix Notifications',
  description: 'Notifications for subscription renewals and alerts',
  importance: Importance.max,
  playSound: true,
  enableVibration: true,
);

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kDebugMode) {
    print('Handling a background message: ${message.messageId}');
  }

  // If the message already has a notification payload, Android/iOS system natively shows it in the status bar
  if (message.notification != null) {
    return;
  }

  // If it is a data-only payload arriving in background, display it via local notifications
  final title = message.data['title'] ?? 'Velix';
  final body = message.data['body'] ?? message.data['message'] ?? '';

  if (body.isNotEmpty || title.isNotEmpty) {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await _localNotifications.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );

    const androidDetails = AndroidNotificationDetails(
      'velix_default_channel',
      'Velix Notifications',
      channelDescription: 'Notifications for subscription renewals and alerts',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
    );
  }
}

class PushNotificationService extends GetxService {
  final ApiClient _apiClient = ApiClient();
  FirebaseMessaging get _fcm => FirebaseMessaging.instance;

  String? _currentFcmToken;
  String? get currentFcmToken => _currentFcmToken;

  static Future<PushNotificationService> init() async {
    final service = PushNotificationService();
    await service._initialize();
    return service;
  }

  Future<void> _initialize() async {
    try {
      // 1. Initialize Firebase
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // 2. Setup Local Notification Channel for Android
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosInit = DarwinInitializationSettings();
      await _localNotifications.initialize(
        const InitializationSettings(android: androidInit, iOS: iosInit),
        onDidReceiveNotificationResponse: (response) {
          try {
            Get.toNamed('/notifications');
          } catch (_) {}
        },
      );

      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        await androidPlugin.createNotificationChannel(_defaultChannel);
      }

      // 3. Set Background Message Handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // 4. Request Permissions for iOS and Android 13+
      await _requestPermission();

      // 5. Set Foreground Presentation Options for iOS
      await _fcm.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // 5. Retrieve Token and Sync with Backend
      await setupFcmToken();

      // 6. Listen for Token Refreshes
      _fcm.onTokenRefresh.listen((newToken) {
        _currentFcmToken = newToken;
        syncTokenWithBackend();
      });

      // 7. Setup In-App Foreground Listener
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _handleForegroundMessage(message);
      });

      // 8. Setup App Launch / Notification Click Listener
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _handleNotificationClick(message);
      });

      if (kDebugMode) {
        print('🔥 PushNotificationService initialized successfully.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ PushNotificationService initialization warning: $e');
      }
    }
  }

  Future<void> _requestPermission() async {
    try {
      final settings = await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      // Explicitly request notification permission for Android 13+ (API 33+)
      final androidImplementation = _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
      }

      if (kDebugMode) {
        print('FCM Permission Status: ${settings.authorizationStatus}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting push notification permission: $e');
      }
    }
  }

  Future<void> setupFcmToken() async {
    try {
      // On iOS, wait for APNS token before fetching FCM token
      if (Platform.isIOS) {
        String? apnsToken = await _fcm.getAPNSToken();
        // Give it a brief retry if APNs token takes a moment to arrive
        int retry = 0;
        while (apnsToken == null && retry < 3) {
          await Future.delayed(const Duration(seconds: 1));
          apnsToken = await _fcm.getAPNSToken();
          retry++;
        }
        if (kDebugMode) {
          print('📱 iOS APNS Token: $apnsToken');
        }
      }

      _currentFcmToken = await _fcm.getToken();

      if (kDebugMode) {
        print('🔥 Current FCM Token: $_currentFcmToken');
      }

      await syncTokenWithBackend();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching FCM Token: $e');
      }
    }
  }

  /// Sends the current FCM token to the backend if the user is authenticated
  Future<void> syncTokenWithBackend() async {
    if (_currentFcmToken == null || _currentFcmToken!.isEmpty) return;

    try {
      if (Get.isRegistered<StorageService>()) {
        final storage = Get.find<StorageService>();
        if (!storage.isLoggedIn) {
          // Will be synced once the user logs in
          return;
        }

        final deviceType = Platform.isIOS ? 'ios' : 'android';

        final response = await _apiClient.post(
          ApiEndpoints.notificationDeviceToken,
          data: {
            'fcmToken': _currentFcmToken,
            'deviceType': deviceType,
          },
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (kDebugMode) {
            print('✅ FCM token registered with backend successfully.');
          }
        } else {
          if (kDebugMode) {
            print('⚠️ Token registration failed with code: ${response.statusCode}');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Could not sync FCM token with backend: $e');
      }
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final title = message.notification?.title ?? 'Velix';
    final body = message.notification?.body ?? '';

    if (body.isEmpty && (message.notification == null)) return;

    // 1. Show In-App Top Snackbar
    Get.snackbar(
      title,
      body,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF1E1F30),
      colorText: Colors.white,
      icon: const Icon(Icons.notifications_active, color: Color(0xFF9482FF)),
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      duration: const Duration(seconds: 4),
      onTap: (_) => _handleNotificationClick(message),
    );

    // 2. Also pop directly in phone's Notification Tray / Status Bar
    _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _defaultChannel.id,
          _defaultChannel.name,
          channelDescription: _defaultChannel.description,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  void _handleNotificationClick(RemoteMessage message) {
    if (kDebugMode) {
      print('Notification clicked: ${message.data}');
    }
    // Navigate to notifications page
    try {
      Get.toNamed('/notifications');
    } catch (_) {}
  }
}
