import 'dart:io';
import 'dart:ui';

import 'package:car_rent/Screens/login/sign_up.dart';
import 'package:car_rent/Screens/login/splash_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:car_rent/Screens/nav_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:car_rent/Screens/cars_list_page.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'Screens/cars_list_page.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'Screens/login/authentication_functions.dart';
import 'Screens/login/login_screen.dart';
import 'firebase_options.dart';
import 'models/car_model.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  await Firebase.initializeApp();

  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }
}

Future <void> main() async {


  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  ). then((value) => Get.put(AuthenticationFunctions()));
  // Future<InitializationStatus> _initGoogleMobileAds() {
  //   // TODO: Initialize Google Mobile Ads SDK
  //   return MobileAds.instance.initialize();
  // }
  MobileAds.instance.initialize();

  // RequestConfiguration requestConfiguration = RequestConfiguration(
  //   testDeviceIds:
  // );
  // MobileAds.instance.updateRequestConfiguration(requestConfiguration);


  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter<Car>(CarAdapter());
  await Hive.openBox <Car>('car');




  await FirebaseMessaging.instance.getInitialMessage();

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };


  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (kDebugMode) {
    print('User granted permission: ${settings.authorizationStatus}');
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('Got a message whilst in the foreground!');
    }
    if (kDebugMode) {
      print('Message data: ${message.data}');
    }

    if (message.notification != null) {
      if (kDebugMode) {
        print('Message also contained a notification: ${message.notification}');
      }
    }
  });

  // runApp(GetMaterialApp(
  //  debugShowCheckedModeBanner: false,
  //   home: MyApp(),
  // ));

  runApp( const MyApp());

}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){

    return  GetMaterialApp(
      title: 'carRent',
      // initialRoute: '/',
      routes:{
        // '/': (context) =>  const SplashScreen(),
        '/cars/automatic': (context) => const CarsListPage(),
        '/cars/electric': (context) => const CarsListPage(),
        '/login_screen' : (context) =>  LoginScreen(),
        '/sign_up': (context) =>  SignUpScreen(),
      },

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.white, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.blue)
      ),
      home: CircularProgressIndicator(),
    );
  }
}