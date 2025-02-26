import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

class SendNotification {
  final String projectId = 'task-c4106'; // Your Firebase project ID
  final String serviceAccountKeyPath = 'assets/adminsdk/adminsdk.json'; // Path to your service account key

  final Dio _dio = Dio();


// function to send notification to the user based on the status using Firebase Cloud Messaging (FCM)
  Future<bool> sendNotification({
    required String reciverToken, // User's FCM token to send notification
    required String status, // Status of the expense to send in the notification
  }) async {
    try {
      // Load the JSON file from the assets
      final String keyString =
          await rootBundle.loadString(serviceAccountKeyPath);
      final auth.ServiceAccountCredentials credentials =
          auth.ServiceAccountCredentials.fromJson(keyString);

      // Get OAuth2 token
      final auth.AutoRefreshingAuthClient client =
          await auth.clientViaServiceAccount(
        credentials,
        ['https://www.googleapis.com/auth/firebase.messaging'],
      );

      // Data to send in the notification message

      final Map<dynamic, dynamic> data = {
        "message": {
          "token": reciverToken,
          "notification": {
            "title": "Status notification",
            "body": "Your expense is $status",
          },
          "android": {"priority": "HIGH"},
        }
      };
      // log(data.toString());

      // Send the notification using FCM API

      Response response = await _dio.post(
          'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
          data: data,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${client.credentials.accessToken.data}',
          }));
      // log(response.data.toString());
      // log(response.statusCode.toString());
      return response.statusCode == 200;
    } catch (e) {
      // log(e.toString());
      rethrow;
    }
  }
}
