part of 'report_bloc.dart';

@immutable
sealed class ReportState {}

final class ReportInitialState extends ReportState {}

final class ReportLoadingState extends ReportState {}


final class ReportSuccessState extends ReportState {
  final List<ExpensModel> expenses;

  ReportSuccessState({
    required this.expenses,
  });
}

final class ReportFailureState extends ReportState {
  final String errorMessage;

  ReportFailureState({required this.errorMessage});
}

final class ReportDownloadInProgressState extends ReportState {}

final class ReportDownloadSuccessState extends ReportState {
  ReportDownloadSuccessState();
}

final class ReportDownloadFailureState extends ReportState {
  final String errorMessage;

  ReportDownloadFailureState({required this.errorMessage});
}
