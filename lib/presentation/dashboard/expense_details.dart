import 'package:bhawani_tech_task/custom_widgets/custom_buttons.dart';
import 'package:bhawani_tech_task/presentation/dashboard/home_page.dart';
import 'package:bhawani_tech_task/presentation/dashboard/model/expense_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../user_data.dart';
import 'bloc/dashboard_bloc.dart';

class ExpenseDetailsPage extends StatefulWidget {
  final ExpensModel expense;
  const ExpenseDetailsPage({
    super.key,
    required this.expense,
  });

  @override
  State<ExpenseDetailsPage> createState() => _ExpenseDetailsPageState();
}

class _ExpenseDetailsPageState extends State<ExpenseDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.offAll(() => const HomePage());
          },
        ),
        title: const Text('Expense Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 10,
          children: [
            Table(
              border: TableBorder.all(
                color: Colors.black,
                width: 1,
              ),
              children: [
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.expense.status,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: widget.expense.status == 'pending'
                              ? Colors.orange
                              : widget.expense.status == 'approved'
                                  ? Colors.green
                                  : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Title',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.expense.title,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.expense.name,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Description',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.expense.description,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Amount',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.expense.amount.toString(),
                          style: const TextStyle(fontSize: 22)),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Time',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        DateFormat('yyyy-MM-dd – kk:mm')
                            .format(widget.expense.createdAt.toDate()),
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Receipt Image',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        widget.expense.receiptImage,
                        height: 100,
                        width: 100,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            role == 'manager'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      widget.expense.status != 'approved'
                          ? CustomButton(
                              buttonText: 'Approve',
                              width: Get.width * 0.3,
                              color: Colors.green,
                              onTap: () {
                                BlocProvider.of<DashboardBloc>(context).add(
                                  UpdateExpenseStatus(
                                    expenseId: widget.expense.id ?? '',
                                    status: 'approved',
                                  ),
                                );
                              },
                            )
                          : SizedBox.shrink(),
                      widget.expense.status != 'pending'
                          ? CustomButton(
                              buttonText: 'Pending',
                              width: Get.width * 0.3,
                              color: Colors.orange,
                              onTap: () {
                                BlocProvider.of<DashboardBloc>(context).add(
                                  UpdateExpenseStatus(
                                    expenseId: widget.expense.id ?? '',
                                    status: 'pending',
                                  ),
                                );
                              },
                            )
                          : SizedBox.shrink(),
                      widget.expense.status != 'rejected'
                          ? CustomButton(
                              buttonText: 'Reject',
                              width: Get.width * 0.3,
                              color: Colors.red,
                              onTap: () {
                                BlocProvider.of<DashboardBloc>(context).add(
                                  UpdateExpenseStatus(
                                    expenseId: widget.expense.id ?? '',
                                    status: 'rejected',
                                  ),
                                );
                              },
                            )
                          : SizedBox.shrink(),
                    ],
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
