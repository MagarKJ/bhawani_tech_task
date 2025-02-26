part of 'notification_bloc.dart';

@immutable
sealed class NotificationEvent {}


// StatusChangeEvent to send notification to the user based on the status
class StatusChangeEvent extends NotificationEvent {
  final String status;
  final String reciverToken;

  StatusChangeEvent({
    required this.status,
    required this.reciverToken,
  });
}
