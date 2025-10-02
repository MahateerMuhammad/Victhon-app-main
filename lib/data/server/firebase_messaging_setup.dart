// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:victhon/config/theme/app_color.dart';
// import 'package:victhon/widget/custom_snackbar.dart';

// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // You can initialize Flutter here if needed
//   debugPrint('Handling background message: ${message.messageId}');
// }

// @pragma('vm:entry-point')
// void notificationTapBackground(NotificationResponse notificationResponse) {
//   debugPrint('Tapped notification payload: ${notificationResponse.payload}');
//   // Use navigation or logic as needed — avoid complex UI logic here
// }


// class NotificationService {
//   static final _firebaseMessaging = FirebaseMessaging.instance;
//   static final _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> init() async {
//     await _firebaseMessaging.requestPermission();

//     // Local notification config
//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/launcher_icon');

//     const InitializationSettings initSettings = InitializationSettings(
//       android: androidSettings,
//     );

//     await _flutterLocalNotificationsPlugin.initialize(
//       initSettings,
//       onDidReceiveBackgroundNotificationResponse: notificationTapBackground
//     );

//     // Foreground notification listener
//     FirebaseMessaging.onMessage.listen(_handleForegroundNotification);

//     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

//     // Background/terminated open listener
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       Get.toNamed('/notification-detail', arguments: message.data);
//     });

//     final token = await _firebaseMessaging.getToken();
//     print("🔑 FCM Token: $token");
//     // You can send this token to your backend
//   }

//   void _handleForegroundNotification(RemoteMessage message) {
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//       'default_channel',
//       'App Notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const NotificationDetails platformDetails =
//         NotificationDetails(android: androidDetails);

//     _flutterLocalNotificationsPlugin.show(
//       0,
//       message.notification?.title ?? 'New Notification',
//       message.notification?.body ?? '',
//       platformDetails,
//       payload: message.data.toString(),
//     );

//     customSnackbar("Notification", message, AppColor.primaryColor.shade700);
//   }

// // @pragma('vm:entry-point')
// // void notificationTapBackground(NotificationResponse notificationResponse) {
// //   // Handle the notification tap in background
// //   debugPrint('Notification payload: ${notificationResponse.payload}');
// // }

// }
