import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:splash_practices/auth_screens/login_screen.dart';
import 'package:splash_practices/provider_classes/add_cart.dart';
import 'package:splash_practices/ui_screens/bottomnav_bar.dart';

import 'firebase_options.dart';
import 'loca_notification/loc_notification.dart'; // Ensure correct import path to NotServices

void main() async{
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white)

  ]
    ,debug: true,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AddCart()),
      ],
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: userChecker(),
        );
      },
    );
  }

  Widget userChecker() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return const BottomNavBar();
    } else {
      return const LoginScreen();
    }
  }
}
