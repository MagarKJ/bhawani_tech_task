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
class FetchExpensesEvent extends DashboardEvent {
  final String? status;
  final String? userName;
  final DateTime? startDate;
  final DateTime? endDate;

  FetchExpensesEvent({
    this.status,
    this.userName,
    this.startDate,
    this.endDate,
  });
}

class UpdateExpenseStatus extends DashboardEvent {
  final String expenseId;
  final String status;

  UpdateExpenseStatus({
    required this.expenseId,
    required this.status,
  });
}
