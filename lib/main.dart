import 'package:bhawani_tech_task/features/auth/presentation/login/bloc/login_bloc.dart';
import 'package:bhawani_tech_task/features/auth/presentation/register/bloc/register_bloc.dart';
import 'package:bhawani_tech_task/features/auth/presentation/login/login.dart';
import 'package:bhawani_tech_task/firebase_options.dart';
import 'package:bhawani_tech_task/features/homepage/presentation/dashboard/bloc/dashboard_bloc.dart';
import 'package:bhawani_tech_task/features/homepage/presentation/report/bloc/report_bloc.dart';
import 'package:bhawani_tech_task/features/notification/bloc/notification_bloc.dart';
import 'package:bhawani_tech_task/core/internet_services.dart';
import 'package:bhawani_tech_task/features/notification/repo/notification_serices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

// function to handle background messages from firebase
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages
  print("Handling background message: ${message.messageId}");
}

void main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase App with default options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Enable Firestore persistance to store data locally on device for offline access
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);

  NotificationSerices notificationSerices = NotificationSerices();
  // Initialize local notification service
  await notificationSerices.initializeLocalNotification();
  // Get device token for push notifications called fcmtoken and setup listeners
  await notificationSerices.getDeviceToken();
  notificationSerices.setupFCMListeners();
  // Set up background message handler for Firebase Messaging
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

// this function will check if the user is synced with the expenses collection in firestore or not
//if not then it will sync the user with the expenses collection in firestore
// while offline when user adds expenses it will be stored locally in sqlite and when user comes online it will be synced with the firestore
  await checkAndSyncExpenses();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiBlocProvider to provide multiple blocs to the app
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterBloc(),
        ),
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
        BlocProvider(
          create: (context) => DashboardBloc(),
        ),
        BlocProvider(
          create: (context) => ReportBloc(),
        ),
        BlocProvider(
          create: (context) => NotificationBloc(),
        ),
      ],
      child: GetMaterialApp(
        title: 'Task Project',
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}
