// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotServices {
//   final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   Future<void> initNotification() async {
//     try {
//       // Android initialization settings
//       const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('ic_launcher');
//
//       // iOS initialization settings
//       // final IOSInitializationSettings iosInitializationSettings = IOSInitializationSettings(
//       //   requestAlertPermission: true,
//       //   defaultPresentBadge: true,
//       //   requestBadgePermission: true,
//       //   requestSoundPermission: true,
//       //   onDidReceiveLocalNotification: (int? id, String? title, String? body, String? payload) async {
//       //     // Handle receiving local notifications here
//       //   },
//       // );
//
//       // Combined initialization settings
//       // final InitializationSettings initializationSettings = InitializationSettings(
//       //   android: androidInitializationSettings,
//       //   iOS: iosInitializationSettings,
//       // );
//
//       // Initialize notifications plugin
//       // await notificationsPlugin.initialize(
//       //   initializationSettings,
//       //   // onSelectNotification: (String? payload) async {
//       //   //   // Handle notification selection here
//       //   // },
//       // );
//     } catch (e) {
//       print('Error initializing notifications: $e');
//       // Handle initialization error here
//     }
//   }
//
//   NotificationDetails notificationDetail() {
//     return NotificationDetails(
//       android: AndroidNotificationDetails(
//         'channelId',
//         'channelName',
//         importance: Importance.max,
//       ),
//       // iOS: IOSNotificationDetails(),
//     );
//   }
//
//   Future<void> showNotification({int id = 0, String? title, String? body, String? payload}) async {
//     try {
//       await notificationsPlugin.show(
//         id,
//         title,
//         body,
//         await notificationDetail(),
//       );
//     } catch (e) {
//       print('Error showing notification: $e');
//       // Handle notification show error here
//     }
//   }
// }
