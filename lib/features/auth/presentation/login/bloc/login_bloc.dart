
import 'package:bhawani_tech_task/features/homepage/presentation/dashboard/home_page.dart';
import 'package:bhawani_tech_task/core/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/model/user_model.dart';
import '../../../data/repo/user_auth_repo.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonTappedEvent>((event, emit) async {
      UserAuthRepo userAuthRepo = UserAuthRepo();
      // SharedPreferences to store user data locally on device for persistence across app restarts and sessions
      SharedPreferences prefs = await SharedPreferences.getInstance();

      try {
        emit(LoginLoadingState());
        // Login user with email and password
        UserModel userModel = await userAuthRepo.login(
          email: event.email,
          password: event.password,
        );
        // Save user data to shared preferences for persistence across app restarts and sessions
        uid = userModel.uid;
        prefs.setString('uid', userModel.uid);
        name = userModel.name;
        prefs.setString('name', userModel.name);
        email = userModel.email;
        prefs.setString('email', userModel.email);
        role = userModel.role;
        prefs.setString('role', userModel.role);

        prefs.setBool('login', true);
        // Navigate to home page after successful login and show success message
        Get.offAll(() => HomePage());
        Fluttertoast.showToast(
          msg: 'Login Success',
          backgroundColor: Colors.green,
        );
        emit(LoginSuccessState(user: userModel));
      } catch (e) {
        Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
        );
        emit(LoginErrorState(e.toString()));
      }
    });
  }
}
