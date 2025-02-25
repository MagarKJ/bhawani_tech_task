import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repo/notification_repo.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitialState()) {
    on<StatusChangeEvent>((event, emit) {
      try {
        emit(NotificationLoadingState());
        SendNotification sendNotification = SendNotification();
        sendNotification.sendNotification(
          reciverToken: event.reciverToken,
          status: event.status,
        );
      } catch (e) {
        emit(NotificationErrorState(e.toString()));
      }
    });
  }
}
