import 'dart:convert';
import 'dart:developer';

import 'package:bhawani_tech_task/core/user_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSerices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


      // Function to get device token for push notifications and store it in shared preferences

  Future<void> getDeviceToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    fcmToken = await messaging.getToken();
    // log('FCMtoken: $fcmToken');

    if (fcmToken != null) {
      prefs.setString('playerId', fcmToken!);
    }
  }


// Function to initialize local notification service with default options
  Future<void> initializeLocalNotification() async {
    // Initialize local notification service with default options for android
    var androidInitializationSettings = const AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    
    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
        // Function to handle notification response when user taps on notification
            (NotificationResponse notificationResponse) {
      String? payload = notificationResponse.payload;
      // log('payload:$payload');
      if (payload != null) {
        // Convert payload to map
        Map<String, dynamic> data = jsonDecode(payload);
        // log('Parsed payload data: $data');

        // Create a dummy RemoteMessage for handling
        RemoteMessage message = RemoteMessage(data: data);

        // _handleMessage(message);
      }
    });
  }


  // Function to setup Firebase Cloud Messaging (FCM) listeners for foreground messages

  void setupFCMListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("Foreground Notification: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");
      if (message.notification != null) {
        await _showNotification(_flutterLocalNotificationsPlugin, message);
      }
    });
  }

  // Function to show notification using Flutter Local Notifications plugin with the message data

  Future<void> _showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );


// Create a notification with the message data and show it
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);


// Show the notification with the message data
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}
