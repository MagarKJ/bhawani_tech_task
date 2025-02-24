import 'dart:developer';
import 'dart:io';

import 'package:bhawani_tech_task/presentation/dashboard/home_page.dart';
import 'package:bhawani_tech_task/presentation/dashboard/repo/add_image.dart';
import 'package:bhawani_tech_task/presentation/dashboard/repo/expense_repod.dart';
import 'package:bhawani_tech_task/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../model/expense_mode.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<FetchExpensesEvent>((event, emit) async {
      try {
        emit(DashboardLoading());
        ExpenseRepo expenseRepo = ExpenseRepo();
        List<ExpensModel> expenses = [];

        if (role == 'employee') {
          // Regular users: Only fetch their own expenses
          expenses = await expenseRepo.getUserExpenses(
            userId: uid ?? '',
          );
        } else if (role == 'manager') {
          // Managers: Fetch all expenses, filter by status if provided
          expenses = await expenseRepo.getUserExpenses(
            userId: '', // Managers see all expenses, so userId is not needed

            statusFilter: event.status ?? '',
          );
        } else if (role == 'admin') {
          
          // Admins: Fetch all expenses and apply filters if available
          expenses = await expenseRepo.getUserExpenses(
            userId: '', // Admins see all expenses

            statusFilter: event.status ?? '',
            userName: event.userName, // Optional username filter
            startDate: event.startDate, // Optional date filter
            endDate: event.endDate, // Optional date filter
          );
        }

        await Future.delayed(Duration(seconds: 1)); // Simulate delay for UX
        log('Expenses fetched successfully: $expenses');
        emit(GetExpenseListSucessState(expenses: expenses));
      } catch (e) {
        log(e.toString());
        emit(DashboardFailure(errorMessage: e.toString()));
      }
    });

    on<AddReciptButtonPressed>((event, emit) async {
      try {
        emit(DashboardLoading());
        ExpenseRepo expenseRepo = ExpenseRepo();
        ReciptImage reciptImage = ReciptImage();
        String? imageUrl = await reciptImage.uploadImage(event.image);

        expenseRepo
            .addExpense(
          expense: ExpensModel(
            name: name ?? 'User',
            userId: uid ?? '',
            title: event.title,
            description: event.description,
            amount: event.amount,
            receiptImage: imageUrl ?? '',
            status: 'pending',
            createdAt: Timestamp.fromDate(DateTime.now()),
          ),
        )
            .then(
          (value) {
            Get.offAll(() => HomePage());
            Fluttertoast.showToast(
              msg: 'Your expense was sucessfully added.',
              backgroundColor: Colors.green,
            );
          },
        );
        emit(DashboardSuccess());
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Failed to add expense',
          backgroundColor: Colors.red,
        );
        emit(DashboardFailure(errorMessage: e.toString()));
      }
    });

    on<UpdateExpenseStatus>((event, emit) async {
      try {
        emit(DashboardLoading());
        ExpenseRepo expenseRepo = ExpenseRepo();
        await expenseRepo.updateExpenseStatus(
          expenseId: event.expenseId,
          newStatus: event.status,
        );
        Fluttertoast.showToast(
          msg: 'Expense status updated successfully',
          backgroundColor: Colors.green,
        );
        Get.offAll(() => HomePage());

        emit(DashboardSuccess());
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Failed to update expense status',
          backgroundColor: Colors.red,
        );
        emit(DashboardFailure(errorMessage: e.toString()));
      }
    });
  }
}
