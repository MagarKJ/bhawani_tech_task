part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

final class DashboardLoading extends DashboardState {}

final class DashboardSuccess extends DashboardState {}

final class DashboardFailure extends DashboardState {
  final String errorMessage;

  DashboardFailure({required this.errorMessage});
}

final class GetExpenseListSucessState extends DashboardState {
  final List<ExpensModel> expenses;

  GetExpenseListSucessState({required this.expenses});
}

final class FilteredExpenseListSucessState extends DashboardState {
  final List<ExpensModel> expenses;

  FilteredExpenseListSucessState({required this.expenses});
}

final class ExpenseStatusUpdated extends DashboardState {
  final String expenseId;
  final String status;

  ExpenseStatusUpdated({required this.expenseId, required this.status});
}
