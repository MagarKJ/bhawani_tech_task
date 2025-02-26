part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}
// Event to be called when the register button is tapped to register a user
class RegisterButtonTappedEvent extends RegisterEvent {
  final String email;
  final String password;
  final String name;
  final String role;

  RegisterButtonTappedEvent({
    required this.email,
    required this.password,
    required this.name,
    required this.role,
  });
}
