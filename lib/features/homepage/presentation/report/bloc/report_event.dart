part of 'report_bloc.dart';

@immutable
sealed class ReportEvent {}


// Event to be called when the user taps on the "Download" button
class FetchReportEvent extends ReportEvent {
  final String? status;
  final String? userName;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool filterByCalender;
  final String? calenderFilter;

  FetchReportEvent({
    this.status,
    this.userName,
    this.startDate,
    this.endDate,
    this.filterByCalender = false,
    this.calenderFilter,
  });
}

class DownloadReportEvent extends ReportEvent {
  final List<ExpensModel> expenses;
  DownloadReportEvent(
    this.expenses,
  );
}
