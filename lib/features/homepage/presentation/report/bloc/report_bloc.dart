import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/expense_mode.dart';
import '../../../data/repo/report_repo.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc() : super(ReportInitialState()) {
    on<FetchReportEvent>((event, emit) async {
      try {
        emit(ReportLoadingState());
        ReportRepository reportRepository = ReportRepository();
        List<ExpensModel> expenses = [];
        event.filterByCalender == false
            ? expenses = await reportRepository.getAdminReport(
                statusFilter: event.status ?? '',
                userNameFilter: event.userName ?? '',
                startDate: event.startDate,
                endDate: event.endDate,
              )
            : expenses = await reportRepository.getReportByCalender(
                dateFilter: event.calenderFilter ?? '',
              );

        emit(ReportSuccessState(expenses: expenses));
      } catch (e) {
        emit(ReportFailureState(errorMessage: e.toString()));
      }
    });
    on<DownloadReportEvent>((event, emit) {
      try {
        emit(ReportDownloadInProgressState());
        ReportRepository reportRepository = ReportRepository();
        reportRepository.generateReportPDF(event.expenses);

        emit(ReportDownloadSuccessState());
      } catch (e) {
        emit(ReportDownloadFailureState(errorMessage: e.toString()));
      }
    });
  }
}
