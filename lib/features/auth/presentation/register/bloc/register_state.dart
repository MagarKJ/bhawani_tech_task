part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitialState extends RegisterState {}

final class RegisterLoadingState extends RegisterState {}
// State to be called when registration is successful and user data is returned
final class RegisterSuccessState extends RegisterState {
  final UserModel user;

  RegisterSuccessState({required this.user});
}

final class RegisterFailureState extends RegisterState {
  final String errorMessage;

  RegisterFailureState({required this.errorMessage});
}
