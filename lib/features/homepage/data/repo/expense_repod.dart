import 'dart:developer';

import 'package:bhawani_tech_task/features/homepage/data/model/expense_mode.dart';
import 'package:bhawani_tech_task/core/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ExpenseRepo class to handle expense related operations like add, fetch, update status
class ExpenseRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to add a new expense to Firestore with the necessary fields
  Future<void> addExpense({required ExpensModel expense}) async {
    try {
      CollectionReference expensesCollection =
          _firestore.collection('expenses');

      // Add the expense to Firestore with the necessary fields
      await expensesCollection.add(expense.toMap());

      // log('Expense added successfully $expense');
    } catch (e) {
      // log(e.toString());
      rethrow;
    }
  }

// Function to fetch expenses from Firestore based on user ID, status, date range, etc. (with optional filters)
  Future<List<ExpensModel>> getUserExpenses({
    required String userId,
    String? statusFilter, // Optional for Manager & Admin
    String? userName, // Optional for Admin
    DateTime? startDate, // Optional for Admin
    DateTime? endDate, // Optional for Admin
  }) async {
    try {
      CollectionReference expensesCollection =
          _firestore.collection('expenses');
      Query query = expensesCollection;

// Check user role to apply filters accordingly (Admin, Manager, User)
      if (role == 'admin') {
        // Admin can filter by status
        if (statusFilter != null && statusFilter.isNotEmpty) {
          query = query.where('status', isEqualTo: statusFilter);
        }

        // Admin can filter by user name (convert to userId first)
        if (userName != null && userName.isNotEmpty) {
          QuerySnapshot userSnapshot = await _firestore
              .collection('users')
              .where('name', isEqualTo: userName)
              .limit(1)
              .get();
// Check if user exists with the given name
          if (userSnapshot.docs.isNotEmpty) {
            String filteredUserId = userSnapshot.docs.first.id;
            query = query.where('userId', isEqualTo: filteredUserId);
          } else {
            return []; // No matching user found
          }
        }

        // Admin can filter by date range
        if (startDate != null && endDate != null) {
          // log('Filtering by date range: ${Timestamp.fromDate(startDate)} - ${Timestamp.fromDate(endDate)}');
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
        }
        // manager can filter by status only
      } else if (role == 'manager') {
        // log('manager ma xiryo');
        // Manager can only filter by status
        if (statusFilter != null && statusFilter.isNotEmpty) {
          query = query.where('status', isEqualTo: statusFilter);
        }
        // Regular users can only see their own expenses (no filtering)
      } else {
        // log('user ma xiryo');
        // Regular users can only see their own expenses (no filtering)
        query = query.where('userId', isEqualTo: userId);
      }

      // Execute query
      QuerySnapshot querySnapshot = await query.get();

      // Convert to list of Expense models
      List<ExpensModel> expenses = querySnapshot.docs.map((doc) {
        return ExpensModel.fromFirestore(doc);
      }).toList();

      return expenses;
    } catch (e) {
      throw Exception('Failed to fetch expenses: $e');
    }
  }

// Function to update the status of an expense in Firestore
  Future<void> updateExpenseStatus({
    required String expenseId,
    required String newStatus,
  }) async {
    // Update the status of the expense in Firestore
    try {
      await _firestore.collection('expenses').doc(expenseId).update({
        'status': newStatus,
      });
    } catch (e) {
      throw Exception('Failed to update status: $e');
    }
  }
}
