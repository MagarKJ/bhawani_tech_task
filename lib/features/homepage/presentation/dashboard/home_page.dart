import 'dart:developer';

import 'package:bhawani_tech_task/features/homepage/presentation/dashboard/add_expense_page.dart';
import 'package:bhawani_tech_task/features/homepage/presentation/dashboard/expense_details.dart';
import 'package:bhawani_tech_task/features/homepage/presentation/report/report_page.dart';
import 'package:bhawani_tech_task/core/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../auth/presentation/login/login.dart';
import '../../../auth/data/repo/user_auth_repo.dart';
import 'bloc/dashboard_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  @override
  void initState() {
    // Fetch expenses data from firestore and store in local storage
    storeUserDataFromLocalStorage();
    BlocProvider.of<DashboardBloc>(context).add(FetchExpensesEvent());
    super.initState();
  }

// function to get user data from local storage
  void storeUserDataFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
      email = prefs.getString('email') ?? '';
      role = prefs.getString('role') ?? '';
      uid = prefs.getString('uid') ?? '';
      fcmToken = prefs.getString('playerId') ?? '';
    });
    // log('user id yo ho $uid');
  }

// function to show dialog box with filter options for expenses list
  void _filterDialogBox() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ListTile to show filter options for expenses list
              ListTile(
                leading: Icon(Icons.clear_all),
                title: Text('All'),
                onTap: () {
                  BlocProvider.of<DashboardBloc>(context)
                      .add(FetchExpensesEvent());
                  Navigator.pop(context);
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
                              // Fetch expenses data from firestore by name
                              String name = nameController.text.trim();
                              BlocProvider.of<DashboardBloc>(context)
                                  .add(FetchExpensesEvent(userName: name));
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
                  // Show dialog box with date range picker
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
                                    // Show date picker to select start date
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
                                    // Show date picker to select end date
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
                              // Fetch expenses data from firestore by date range
                              DateTime startDate =
                                  DateTime.parse(startDateController.text);
                              DateTime endDate =
                                  DateTime.parse(endDateController.text);
                              BlocProvider.of<DashboardBloc>(context).add(
                                FetchExpensesEvent(
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
              // ListTile to show report option for admin role
              role == 'admin'
                  ? ListTile(
                      leading: Icon(Icons.summarize),
                      title: Text('Report'),
                      onTap: () {
                        Get.to(() => ReportPage());
                      },
                    )
                  : SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        leading: role == 'employee'
            ? SizedBox.shrink()
            : IconButton(
                onPressed: () {
                  //show dialog box with filter options
                  _filterDialogBox();
                },
                icon: const Icon(Icons.filter_alt_sharp),
              ),
        title: Text('${role.toString().capitalizeFirst} Dashboard'),
        actions: [
          IconButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              UserAuthRepo().logout();
              prefs.setBool('login', false);

              Get.offAll(() => const LoginPage());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: role == 'employee'
          ? FloatingActionButton(
              onPressed: () {
                Get.to(() => const AddExpenseScreen());
              },
              child: const Icon(Icons.add),
            )
          : SizedBox.shrink(),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          BlocProvider.of<DashboardBloc>(context).add(FetchExpensesEvent());
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              role == 'manager' || role == 'admin'
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<DashboardBloc>(context)
                                .add(FetchExpensesEvent());
                          },
                          child: Text(
                            'All ',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<DashboardBloc>(context)
                                .add(FetchExpensesEvent(status: 'pending'));
                          },
                          child: Text(
                            'Pending',
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<DashboardBloc>(context)
                                .add(FetchExpensesEvent(status: 'approved'));
                          },
                          child: Text(
                            'Approved',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<DashboardBloc>(context)
                                .add(FetchExpensesEvent(status: 'rejected'));
                          },
                          child: Text(
                            'Rejected',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              SizedBox(
                height: 10,
              ),
              BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  if (state is DashboardInitial) {
                    BlocProvider.of<DashboardBloc>(context)
                        .add(FetchExpensesEvent());
                  }
                  if (state is DashboardLoading) {
                    return Center(
                      child: const CircularProgressIndicator(),
                    );
                  }
                  if (state is DashboardFailure) {
                    return Text(state.errorMessage);
                  }
                  if (state is GetExpenseListSucessState) {
                    return state.expenses.isEmpty
                        ? Center(
                            child: Text('There are No Expenses'),
                          )
                        : ListView.builder(
                            itemCount: state.expenses.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  Get.to(
                                    () => ExpenseDetailsPage(
                                      expense: state.expenses[index],
                                    ),
                                  );
                                },
                                title: Text(
                                  '${state.expenses[index].title} ${role == 'employee' ? '' : 'by ${state.expenses[index].name}'} ',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(state.expenses[index].status,
                                    style: TextStyle(
                                        color: state.expenses[index].status ==
                                                'pending'
                                            ? Colors.orange
                                            : state.expenses[index].status ==
                                                    'approved'
                                                ? Colors.green
                                                : Colors.red)),
                                trailing: Text(
                                  state.expenses[index].amount.toString(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            },
                          );
                  }
                  return const SizedBox(
                    child: Text('No Expenses'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
