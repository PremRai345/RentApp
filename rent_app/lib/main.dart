import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:rent_app/constants/constants.dart';
import 'package:rent_app/providers/room_provider.dart';
import 'package:rent_app/providers/room_rent_provider.dart';
import 'package:rent_app/providers/user_provider.dart';
import 'package:rent_app/providers/utilities_price_provider.dart';
import 'package:rent_app/screens/login_screen.dart';
import 'package:rent_app/theme/theme_data.dart';
import 'package:rent_app/utils/size_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final localAuth = LocalAuthentication();
  final canCheckBioMetric = await localAuth.canCheckBiometrics;
  runApp(
    MyApp(canCheckBioMetric),
  );
}

class MyApp extends StatelessWidget {
  final bool canCheckBioMetric;
  MyApp(this.canCheckBioMetric, {Key? key}) : super(key: key);

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  configureMessaging() async {
    final messagingInstance = FirebaseMessaging.instance;
    final permission = await messagingInstance.requestPermission();

    // messagingInstance.
    FirebaseMessaging.onMessage.forEach(
      (event) {
        const androidNotification = AndroidNotificationDetails(
          "channel id",
          "channel name",
          importance: Importance.high,
          priority: Priority.high,
        );

        const notificationDetails =
            NotificationDetails(android: androidNotification);

        flutterLocalNotificationsPlugin.show(
          Random().nextInt(100000),
          event.notification?.title ?? "title",
          event.notification?.body ?? "body",
          notificationDetails,
        );
        // event.
        // print("object");
        // print(event.notification?.title ?? "title");
        // print(event.notification?.body ?? "messageBody");
        // print(event.notification?.android?.imageUrl ?? "imageUrl");
      },
    );
  }

  configureNotification() {
    const androidSettings =
        AndroidInitializationSettings(ImageConstants.notificationIcon);
    const iosSettings = IOSInitializationSettings();

    const initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    configureNotification();
    configureMessaging();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UtilitiesPriceProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RoomProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RoomRentProvider(),
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          SizeConfig().init(constraints);
          return MaterialApp(
            title: 'Rent App',
            theme: lightTheme(context),
            home: LoginScreen(canCheckBioMetric),
          );
        },
      ),
    );
  }
}
