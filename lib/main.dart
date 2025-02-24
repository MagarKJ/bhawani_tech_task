import 'package:bhawani_tech_task/presentation/auth/login/bloc/login_bloc.dart';
import 'package:bhawani_tech_task/presentation/auth/register/bloc/register_bloc.dart';
import 'package:bhawani_tech_task/presentation/auth/login/login.dart';
import 'package:bhawani_tech_task/firebase_options.dart';
import 'package:bhawani_tech_task/presentation/dashboard/bloc/dashboard_bloc.dart';
import 'package:bhawani_tech_task/presentation/dashboard/report/bloc/report_bloc.dart';
import 'package:bhawani_tech_task/presentation/notification/bloc/notification_bloc.dart';
import 'package:bhawani_tech_task/services/notification_serices.dart';
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
  NotificationSerices notificationSerices = NotificationSerices();
  await notificationSerices.initializeLocalNotification();
  await notificationSerices.getDeviceToken();
  notificationSerices.setupFCMListeners();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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
