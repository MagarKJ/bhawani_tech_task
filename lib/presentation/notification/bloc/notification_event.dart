part of 'notification_bloc.dart';

@immutable
sealed class NotificationEvent {}

class StatusChangeEvent extends NotificationEvent {
  final String status;
  final String reciverToken;

  StatusChangeEvent({
    required this.status,
    required this.reciverToken,
  });
}
