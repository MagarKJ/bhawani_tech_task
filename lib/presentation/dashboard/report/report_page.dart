import 'package:bhawani_tech_task/custom_widgets/custom_buttons.dart';
import 'package:bhawani_tech_task/presentation/dashboard/home_page.dart';
import 'package:bhawani_tech_task/presentation/dashboard/report/bloc/report_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  double totalExpenses = 0.00;
  int noOfExpenses = 0;
  int noOfApprovedExpenses = 0;
  int noOfRejectedExpenses = 0;
  int noOfPendingExpenses = 0;

  void _filterDialogBox() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.clear_all),
                title: Text('All'),
                onTap: () {
                  BlocProvider.of<ReportBloc>(context).add(FetchReportEvent());
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.summarize),
                title: Text('Filter by Status'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Filter by Status'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text('Pending'),
                              onTap: () {
                                BlocProvider.of<ReportBloc>(context)
                                    .add(FetchReportEvent(status: 'pending'));
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: Text('Approved'),
                              onTap: () {
                                BlocProvider.of<ReportBloc>(context)
                                    .add(FetchReportEvent(status: 'approved'));
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: Text('Rejected'),
                              onTap: () {
                                BlocProvider.of<ReportBloc>(context)
                                    .add(FetchReportEvent(status: 'rejected'));
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.filter_list),
                title: Text('Filter by Name'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      TextEditingController nameController =
                          TextEditingController();
                      return AlertDialog(
                        title: Text('Filter by Name'),
                        content: TextField(
                          controller: nameController,
                          decoration: InputDecoration(hintText: "Enter name"),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              String name = nameController.text.trim();
                              BlocProvider.of<ReportBloc>(context)
                                  .add(FetchReportEvent(userName: name));
                              Navigator.pop(context);
                            },
                            child: Text('Filter'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                        ],
                      );
                    },
                  );

                  // Implement filter by name functionality
                },
              ),
              ListTile(
                leading: Icon(Icons.date_range),
                title: Text('Filter by Date'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      TextEditingController startDateController =
                          TextEditingController();
                      TextEditingController endDateController =
                          TextEditingController();
                      return AlertDialog(
                        title: Text('Filter by Date'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: startDateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: "Start date",
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.calendar_today),
                                  onPressed: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2101),
                                    );
                                    if (pickedDate != null) {
                                      startDateController.text =
                                          pickedDate.toString().split(' ')[0];
                                    }
                                  },
                                ),
                              ),
                            ),
                            TextField(
                              controller: endDateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: "End date",
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.calendar_today),
                                  onPressed: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2101),
                                    );
                                    if (pickedDate != null) {
                                      endDateController.text =
                                          pickedDate.toString().split(' ')[0];
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              DateTime startDate =
                                  DateTime.parse(startDateController.text);
                              DateTime endDate =
                                  DateTime.parse(endDateController.text);
                              BlocProvider.of<ReportBloc>(context).add(
                                FetchReportEvent(
                                  startDate: startDate,
                                  endDate: endDate,
                                ),
                              );
                              Navigator.pop(context);
                            },
                            child: Text('Filter'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.today),
                title: Text('Daily Report'),
                onTap: () {
                  BlocProvider.of<ReportBloc>(context).add(FetchReportEvent(
                      filterByCalender: true, calenderFilter: 'day'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.view_week),
                title: Text('Weekly Report'),
                onTap: () {
                  BlocProvider.of<ReportBloc>(context).add(FetchReportEvent(
                      filterByCalender: true, calenderFilter: 'week'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.calendar_month),
                title: Text('Monthly Report'),
                onTap: () {
                  BlocProvider.of<ReportBloc>(context).add(FetchReportEvent(
                      filterByCalender: true, calenderFilter: 'month'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.offAll(() => HomePage());
            },
          ),
          title: Text('Report Page'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _filterDialogBox();
          },
          child: Icon(Icons.filter_alt_sharp),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: BlocBuilder<ReportBloc, ReportState>(
            builder: (context, state) {
              if (state is ReportInitialState) {
                BlocProvider.of<ReportBloc>(context).add(FetchReportEvent());
              }
              if (state is ReportLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is ReportFailureState) {
                return Center(
                  child: Text(state.errorMessage),
                );
              }
              if (state is ReportSuccessState) {
                totalExpenses = state.expenses.fold(0.00,
                    (previousValue, element) => previousValue + element.amount);
                noOfExpenses = state.expenses.length;
                noOfApprovedExpenses = state.expenses
                    .where((element) => element.status == 'approved')
                    .length;
                noOfRejectedExpenses = state.expenses
                    .where((element) => element.status == 'rejected')
                    .length;
                noOfPendingExpenses = state.expenses
                    .where((element) => element.status == 'pending')
                    .length;
                return Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Expenses: $totalExpenses',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    Text('No of Expenses: $noOfExpenses',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    Text('No of Pending Expenses: $noOfPendingExpenses',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    Text('No of Approved Expenses: $noOfApprovedExpenses',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    Text('No of Rejected Expenses: $noOfRejectedExpenses',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const <DataColumn>[
                          DataColumn(label: Text('Expense ID')),
                          DataColumn(label: Text('User Name')),
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Amount')),
                          DataColumn(label: Text('Description')),
                          DataColumn(label: Text('Status')),
                        ],
                        rows: List.generate(state.expenses.length, (index) {
                          final expense = state.expenses[index];
                          return DataRow(
                            cells: <DataCell>[
                              DataCell(Text(expense.id ?? '')),
                              DataCell(Text(
                                  expense.name.capitalizeFirst.toString())),
                              DataCell(Text(DateFormat('yyyy-MM-dd – kk:mm')
                                  .format(expense.createdAt.toDate()))),
                              DataCell(Text(expense.amount.toString())),
                              DataCell(Text(expense.description)),
                              DataCell(Text(expense.status,
                                  style: TextStyle(
                                      color: expense.status == 'approved'
                                          ? Colors.green
                                          : expense.status == 'rejected'
                                              ? Colors.red
                                              : Colors.orange))),
                            ],
                          );
                        }),
                      ),
                    ),
                    Center(
                      child: CustomButton(
                          buttonText: 'Download Report',
                          onTap: () {
                            BlocProvider.of<ReportBloc>(context)
                                .add(DownloadReportEvent(state.expenses));
                            BlocProvider.of<ReportBloc>(context)
                                .add(FetchReportEvent());
                          }),
                    ),
                  ],
                );
              }
              return SizedBox(
                child: Center(
                  child: Text('No data found'),
                ),
              );
            },
          ),
        ));
  }
}
