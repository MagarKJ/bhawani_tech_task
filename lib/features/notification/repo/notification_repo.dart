import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

class SendNotification {
  final String projectId = 'task-c4106'; // Your Firebase project ID
  final String serviceAccountKeyPath = 'assets/adminsdk/adminsdk.json';

  final Dio _dio = Dio();

  Future<bool> sendNotification({
    required String reciverToken,
    required String status,
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
      log(data.toString());

      Response response = await _dio.post(
          'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
          data: data,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${client.credentials.accessToken.data}',
          }));
      log(response.data.toString());
      log(response.statusCode.toString());
      return response.statusCode == 200;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
