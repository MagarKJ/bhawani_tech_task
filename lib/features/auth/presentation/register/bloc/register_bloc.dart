import 'package:bhawani_tech_task/features/auth/presentation/login/login.dart';
import 'package:bhawani_tech_task/features/auth/data/model/user_model.dart';
import 'package:bhawani_tech_task/features/auth/data/repo/user_auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitialState()) {
    on<RegisterButtonTappedEvent>((event, emit) async {
      UserAuthRepo userAuthRepo = UserAuthRepo();
      emit(RegisterLoadingState());
      try {
        UserModel user = await userAuthRepo.register(
          email: event.email,
          password: event.password,
          name: event.name,
          role: event.role,
        );
        Get.to(() => LoginPage());
        Fluttertoast.showToast(
          msg: 'Register Success',
          backgroundColor: Colors.green,
        );
        emit(RegisterSuccessState(user: user));
      } catch (e) {
        Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
        );
        emit(RegisterFailureState(errorMessage: e.toString()));
      }
    });
  }
}
