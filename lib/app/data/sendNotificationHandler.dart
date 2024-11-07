import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print(message.data);
}

class SendNotificationHandler {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? serverKeyGG;
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<String> getAccessToken() async {
    // Your client ID and client secret obtained from Google Cloud Console
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "taxiproj-b2f9d",
      "private_key_id": "590e0dd9df8674038fc649def852ca2c00610a6c",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDK7Cmf+XdrMzyX\nuKky+RtDbKkp0qP+nwH/jtaNAvuUFO6V+G6HILWdjc1dxNMH1HXjX/mJWsb36yDC\nK/zoB/ClxZb1Xnf0A9Xn423B7Bgki4eNcu1ODrP1l4kQCOBktpaxS1UhTdXcJkyq\ndszH1ndJ8MFpQFR98U2t4ojZ0pPcSxR6FOQ53va4HJVuw/XSSgea1Pgvz8pT8QKI\nd6u34j9HJV90t6kXzREV1qwu+VvdTIS+wuzjbAWtH/pWYgNKxcx3p2KfVJyWXI3B\nG0xNm3EGYu5prWcxu/jyaiqpWV2A5+Di8VYy2MDdwvtaOlY0+H77Exs6/Az1PbiH\nsNo2SxCBAgMBAAECgf8UfRjfQHGmaQ04RIAOI27VwvGw+Rnr4pETasDZbH+X4m5e\nCQKdV5GP9gMufmsY43ATTbPAmxE0Y9ysLkApsAHdEhjai0k1CtkcvNQuOiMyzKWZ\nCLBCMvBCRQspnSaU2zb4alJ4Pa7NxS9LZ0eRlhFN8lvVOdascMcY1ooJUQqShMnD\noJznrYDflgo8z65EJ5fSWWtSWfTbjMf/mXZmkSmkVk1BkNcUdOYBsLgihapAfnAn\nFM+MW8rj8L3bwAbbBDJ/9XUe4WtBflw4sK47ZH/CiyBLD7jx58+1AH0oHZDza+n2\nXHTGbxUvLqbC3/YCV+e2eOECnXCUwuFF8XWTbWkCgYEA6A/nFDXoMtzdbdn4epGR\nKGftQwhKp7L5SzUp+nzNMCWShrt8B35G3Suz/1namWM8FBl2qWdRPTgpJuKojkKj\nZRP3C0ZbCss2Iwe9CN9Tr50OekEpa60IXvQwOEke7Rv9BvwfFb22RcSTOg1UWo6M\n4iDAjzXJWK9OuUQE7NCNMlUCgYEA39rEIY2Qw1R52kbGjpgZovJbv6Fmyybjg+cu\nJE7wPo+utccdcm0Qc4gpPUULz4+Q36WBwTqsaJChNtc0/aOQcuB4C9wc0t0eEeJj\nvpkfA5Ca2YmY+o2edUWqEAAk7K35rt1XMvAy55z3uPVyd8baFk/mPQXcB0bZh50y\nCPnCiX0CgYEAxrE/CEXzrwD+slzL7J4QbEk3k4pY6WdLHcLCU49h3BR/dc63Lm9H\nW31c24jiqyyVNxxqRjeJDmK0kW/GJDAYWKYUgtnVf9NoYevxRdR5gcZ2q+R5A5Ge\ntjZbxwWMbjXlmoJqVyIdG3VpHW5mSDb/l2m1lajW4ZEQVX5QvTb/fhUCgYA3ek41\nSpJf9mWklPnMiSGBYrMeUO/a1S55mCe1U+LyfkV8Q3amzyTOnSYrSxtcO2ZaJvh7\nXQExgPaTUs6NNaYs8jiOJ+T01VwIbqTtraEkDwhxdUp2ffaRdcxp3r9H8O36Sly8\nAQ98m0hBjILr8FpIQVD8OqGHJCXxGCI4Wz29OQKBgQCCUKZKOJFCMSMdlLwuF2cA\nFTlvmX7N+Tx/qfTcOrQMhIDMsl9vFiZe0NolXAx7MJsD9VT1VpFEHxxGmwmFNp6w\n7QqBo1kA9imh0p7i/qHoee/Fk/RnAnGizBBT7Yc2fuEubjaQIAfUnDSo3Pdtk8aI\nQWDOp8xTIAfdYpCnVk8pRw==\n-----END PRIVATE KEY-----\n",
      "client_email": "myatecommerce@taxiproj-b2f9d.iam.gserviceaccount.com",
      "client_id": "100759835886263192963",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/myatecommerce%40taxiproj-b2f9d.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    client.close();
    return credentials.accessToken.data;
  }

  Future<void> getKey() async {
    serverKeyGG = await getAccessToken();
    print(serverKeyGG);
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    Get.toNamed('/notification');
  }

  Future initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);

    await FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    FirebaseMessaging.onMessage.listen((message) async {
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        print(message.data);
        // Local Notification Code to Display Alert
        displayNotification(message);

        print('GG');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> initNotification() async {
    await messaging.requestPermission();
    final fCMToken = await messaging.getToken();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "token": fCMToken,
    }, SetOptions(merge: true));
    print("Token $fCMToken");

    initPushNotification();
  }

  static void displayNotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            "push_notification_demo", "push_notification_demo_channel",
            importance: Importance.max, priority: Priority.high),
      );

      await flutterLocalNotificationsPlugin.show(
          id,
          message.notification!.title,
          message.notification!.body,
          notificationDetails,
          payload: json.encode(message.data));
    } on Exception catch (e) {
      print(e);
    }
  }

  static void initialized() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(android: initializationSettingsAndroid),
        onDidReceiveNotificationResponse: (details) {
      print(details.toString());
      print("localBackgroundHandler :");
      print(details.notificationResponseType ==
              NotificationResponseType.selectedNotification
          ? "selectedNotification"
          : "selectedNotificationAction");
      print(details.payload);

      try {
        var payloadObj = json.decode(details.payload ?? "{}") as Map? ?? {};
      } catch (e) {
        print(e);
      }
    }, onDidReceiveBackgroundNotificationResponse: localBackgroundHandler);
  }

  Future<void> sendPushNotificationToAllUsers(String title, String body) async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      List<String> tokens = [];

      for (var doc in querySnapshot.docs) {
        String? token = doc['token'];
        if (token != null && token.isNotEmpty) {
          tokens.add(token);
        }
      }

      if (tokens.isEmpty) {
        print('No tokens found!');
        return;
      }
      // Store the notification in Firestore
      var docRef = FirebaseFirestore.instance.collection("notifications").doc();
      docRef.set({
        "id": docRef.id,
        "title": title,
        "body": body,
      });

      for (String token in tokens) {
        await sendPushNotification(token: token, title: title, body: body);
      }
    } catch (e) {
      print('Error sending notifications: $e');
    }
  }

  Future<void> sendPushNotification({
    required String token,
    required String title,
    required String body,
  }) async {
    final Uri url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/taxiproj-b2f9d/messages:send');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKeyGG',
    };

    final Map<String, dynamic> payload = {
      'message': {
        'token': token,
        'notification': {
          'title': title,
          'body': body,
        },
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'message': 'This is additional data payload',
        },
      }
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('Push Notification Sent Successfully!');
      } else {
        print('Failed to send push notification: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while sending push notification: $e');
    }
  }

  static Future<void> localBackgroundHandler(NotificationResponse data) async {
    print(data.toString());
    print("localBackgroundHandler :");
    print(data.notificationResponseType ==
            NotificationResponseType.selectedNotification
        ? "selectedNotification"
        : "selectedNotificationAction");
    print(data.payload);

    try {
      var payloadObj = json.decode(data.payload ?? "{}") as Map? ?? {};
      // openNotification(payloadObj);
    } catch (e) {
      print(e);
    }
  }
}
