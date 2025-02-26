import 'dart:developer';

import 'package:bhawani_tech_task/features/homepage/data/model/expense_mode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class ReportRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Function to fetch expenses from Firestore based on user ID, status, date range, etc. (with optional filters)
// this is used in the report page to get the expenses based on the filters
  Future<List<ExpensModel>> getAdminReport({
    String statusFilter = '',
    String userNameFilter = '',
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // Reference to the 'expenses' collection
      CollectionReference expensesCollection =
          _firestore.collection('expenses');

      // Start building the query
      Query query = expensesCollection;

      // Apply status filter if provided
      if (statusFilter.isNotEmpty) {
        query = query.where('status', isEqualTo: statusFilter);
      }

      // Apply user name filter if provided
      if (userNameFilter.isNotEmpty) {
        query = query.where('name',
            isEqualTo:
                userNameFilter); // Assuming 'userName' field exists in the expense document
      }

      // Apply date range filter if both start and end dates are provided
      if (startDate != null && endDate != null) {
        query = query
            .where('createdAt',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where(
              'createdAt',
              isLessThanOrEqualTo: Timestamp.fromDate(
                endDate.add(Duration(
                    hours: 23,
                    minutes: 59,
                    seconds:
                        59)), //because of how Firestore timestamps are being filtered. When you set endDate to today's date (YYYY-MM-DD), Firestore treats it as midnight (00:00:00), meaning it excludes all expenses from today.
              ),
            );
      } else if (startDate != null) {
        query = query.where('createdAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
      } else if (endDate != null) {
        query = query.where(
          'createdAt',
          isLessThanOrEqualTo: Timestamp.fromDate(
            endDate.add(Duration(
                hours: 23,
                minutes: 59,
                seconds:
                    59)), //because of how Firestore timestamps are being filtered. When you set endDate to today's date (YYYY-MM-DD), Firestore treats it as midnight (00:00:00), meaning it excludes all expenses from today.
          ),
        );
      }

      // Execute the query to fetch data
      QuerySnapshot querySnapshot = await query.get();

      // Convert the QuerySnapshot to a List of Expense objects
      List<ExpensModel> expenses = querySnapshot.docs.map((doc) {
        return ExpensModel.fromFirestore(doc);
      }).toList();

      return expenses;
    } catch (e) {
      throw Exception('Failed to fetch expenses: $e');
    }
  }

  Future<List<ExpensModel>> getReportByCalender({
    required String dateFilter, // Added date filter (day, week, month)
  }) async {
    try {
      // Reference to the 'expenses' collection
      CollectionReference expensesCollection =
          _firestore.collection('expenses');

      // Start building the query
      Query query = expensesCollection;

      // Apply status fi

      // Apply date range filter based on the dateFilter value (day, week, month)
      if (dateFilter.isNotEmpty) {
        DateTime now = DateTime.now();
        DateTime startDate = DateTime.now();
        DateTime endDate = DateTime.now();

        if (dateFilter == 'day') {
          // For day-wise report, filter expenses for today
          startDate = DateTime(now.year, now.month, now.day);
          endDate = startDate
              .add(Duration(days: 1)); // To fetch only today's expenses
        } else if (dateFilter == 'week') {
          // For week-wise report, filter expenses for the current week (Monday to Sunday)
          startDate = now.subtract(Duration(
              days: now.weekday - 1)); // First day of the week (Monday)
          endDate =
              startDate.add(Duration(days: 7)); // Last day of the week (Sunday)
        } else if (dateFilter == 'month') {
          // For month-wise report, filter expenses for the current month
          startDate =
              DateTime(now.year, now.month, 1); // First day of the month
          endDate =
              DateTime(now.year, now.month + 1, 1); // First day of next month
        }

        // Apply the date filters to the query
        query = query
            .where('createdAt',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where('createdAt',
                isLessThanOrEqualTo: Timestamp.fromDate(endDate));
      }

      // Execute the query to fetch data
      QuerySnapshot querySnapshot = await query.get();

      // Convert the QuerySnapshot to a List of Expense objects
      List<ExpensModel> expenses = querySnapshot.docs.map((doc) {
        return ExpensModel.fromFirestore(doc);
      }).toList();

      return expenses;
    } catch (e) {
      throw Exception('Failed to fetch expenses: $e');
    }
  }

  void generateReportPDF(List<ExpensModel> expenses) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text("Expense Report", style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(data: <List<String>>[
                [
                  'Expense ID',
                  'User Name',
                  'Date',
                  'Amount',
                  'Description',
                  'Status'
                ],
                ...expenses.map((expense) {
                  return [
                    expense.id ?? '',
                    expense.name.capitalizeFirst ?? '',
                    // DateFormat('yyyy-MM-dd').format(expense.createdAt.toDate()),
                    DateFormat('yyyy-MM-dd').format(expense.timestampCreatedAt.toDate()),
                    expense.amount.toString(),
                    expense.description,
                    expense.status,
                  ];
                }),
              ]),
            ],
          );
        },
      ));

      // Printing PDF to a file or preview
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
      Fluttertoast.showToast(
        msg: 'PDF report generated successfully',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      // log('Failed to generate PDF: $e');
      Fluttertoast.showToast(
        msg: 'Failed to generate PDF report',
        backgroundColor: Colors.red,
      );
    }
  }
}
