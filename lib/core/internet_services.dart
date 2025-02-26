import 'dart:developer';
import 'dart:io';

import 'package:bhawani_tech_task/features/homepage/data/model/expense_mode.dart';
import 'package:bhawani_tech_task/features/homepage/data/repo/add_image.dart';
import 'package:bhawani_tech_task/features/notification/repo/sqlite_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../features/homepage/data/repo/expense_repod.dart';

// Function to check if the device is online or not
Future<bool> isOnline() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}

// Function to check and sync expenses to Firestore

Future<void> checkAndSyncExpenses() async {
  // First, check if the device is online

  bool online = await isOnline();
  log('Device is online: $online');

  if (online) {
    // Fetch unsynced expenses from local database
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    List<ExpensModel> unsyncedExpenses =
        await databaseHelper.getUnsyncedExpenses();

    // Iterate through unsynced expenses and sync them
    for (var expense in unsyncedExpenses) {
      try {
        // Upload the receipt image if it exists (you may already have a path)
        String? imageUrl = expense.receiptImage.isNotEmpty
            ? await ReciptImage().uploadPhotoUsingCloudinary(
                imageFile: File(expense.receiptImage))
            : null;

        // Update the expense with the image URL and mark it as synced
        expense.receiptImage = imageUrl ?? expense.receiptImage;
        expense.isSynced = true;

        // Sync the expense to Firebase
        await ExpenseRepo().addExpense(expense: expense);

        // If the sync is successful, remove it from the local database
        await databaseHelper.deleteExpense(expense.id ?? '');

        // Optionally, notify the user that syncing is done
        Fluttertoast.showToast(
          msg: 'Expense synced successfully.',
          backgroundColor: Colors.green,
        );
      } catch (e) {
        log('Failed to sync expense: ${e.toString()}');
        // Handle error if sync fails
        Fluttertoast.showToast(
          msg: 'Failed to sync expense: ${e.toString()}',
          backgroundColor: Colors.red,
        );
      }
    }
  } else {
    // Notify the user that the device is offline
    log('Device is offline, please check your connection.');
    Fluttertoast.showToast(
      msg: 'Device is offline, please check your connection.',
      backgroundColor: Colors.red,
    );
  }
}
