part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoadingState extends LoginState {}

// State to be called when login is successful
final class LoginSuccessState extends LoginState {
  final UserModel user;

  LoginSuccessState({required this.user});
}

final class LoginErrorState extends LoginState {
  final String error;

  LoginErrorState(this.error);
}
