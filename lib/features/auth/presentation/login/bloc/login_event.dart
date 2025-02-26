part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}
// Event to be called when the login button is tapped
class LoginButtonTappedEvent extends LoginEvent {
  final String email;
  final String password;

  LoginButtonTappedEvent({
    required this.email,
    required this.password,
  });
}
