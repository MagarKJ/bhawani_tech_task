import 'package:bhawani_tech_task/presentation/auth/login/bloc/login_bloc.dart';
import 'package:bhawani_tech_task/presentation/auth/register/bloc/register_bloc.dart';
import 'package:bhawani_tech_task/presentation/auth/login/login.dart';
import 'package:bhawani_tech_task/firebase_options.dart';
import 'package:bhawani_tech_task/presentation/dashboard/bloc/dashboard_bloc.dart';
import 'package:bhawani_tech_task/presentation/dashboard/report/bloc/report_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      ],
      child: GetMaterialApp(
        title: 'Task Project',
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}
