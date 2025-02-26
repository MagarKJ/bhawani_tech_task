part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardEvent {}

class AddReciptButtonPressed extends DashboardEvent {
  final String title;
  final String description;
  final double amount;
  final File image;

  AddReciptButtonPressed({
    required this.title,
    required this.description,
    required this.amount,
    required this.image,
  });
}

// Combined event to handle both "GetExpenseListEvent" and "FilterByStatusEvent"
// This event will be called when the user taps on the "Filter" button
class FetchExpensesEvent extends DashboardEvent {
  final String? status;
  final String? userName;
  final DateTime? startDate;
  final DateTime? endDate;
  final DocumentSnapshot? lastDocument;

  FetchExpensesEvent({
    this.status,
    this.userName,
    this.startDate,
    this.endDate,
    this.lastDocument,
  });
}

class UpdateExpenseStatus extends DashboardEvent {
  final String expenseId;
  final String status;
  final String token;

  UpdateExpenseStatus({
    required this.expenseId,
    required this.status,
    required this.token,
  });
}
