part of 'notification_bloc.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitialState extends NotificationState {}

final class NotificationLoadingState extends NotificationState {}


// State to be called when notification is successful
final class NotificationSuccessState extends NotificationState {
  final String message;

  NotificationSuccessState(this.message);
}

final class NotificationErrorState extends NotificationState {
  final String message;

  NotificationErrorState(this.message);
}
