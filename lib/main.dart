import 'dart:developer';

import 'package:bhawani_tech_task/features/auth/presentation/login/bloc/login_bloc.dart';
import 'package:bhawani_tech_task/features/auth/presentation/register/bloc/register_bloc.dart';
import 'package:bhawani_tech_task/features/auth/presentation/login/login.dart';
import 'package:bhawani_tech_task/firebase_options.dart';
import 'package:bhawani_tech_task/features/homepage/presentation/dashboard/bloc/dashboard_bloc.dart';
import 'package:bhawani_tech_task/features/homepage/presentation/report/bloc/report_bloc.dart';
import 'package:bhawani_tech_task/features/notification/bloc/notification_bloc.dart';
import 'package:bhawani_tech_task/core/internet_services.dart';
import 'package:bhawani_tech_task/features/notification/repo/notification_serices.dart';
import 'package:bhawani_tech_task/features/notification/repo/sqlite_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages
  print("Handling background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Enable Firestore persistance to store data locally on device for offline access
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
  NotificationSerices notificationSerices = NotificationSerices();
  await notificationSerices.initializeLocalNotification();
  await notificationSerices.getDeviceToken();
  notificationSerices.setupFCMListeners();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await checkAndSyncExpenses();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
