import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  static String fcmToken = "";

  Future<String> getAccessToken() async {
    // Your client ID and client secret obtained from Google Cloud Console
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "myatecommerce",
      "private_key_id": "d9f000d339b877c33aa901d787a13db8c444ed2f",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCV4adnkdZc+Mje\nrdyRoBGINOZJrhVukT0vSiaUA8bUY9iZLc0f+8AEOEa9JvNwuURckxJOwLWGJ7Ru\nkEj9vAooJiwqzLawgNVXrtCvdcSt/hTfri5RgS83bpRZMm0KD1cEwgaIubAqfM48\nplnfaoGREDHgV1yPQjXNk6joSazW1e5l4oT8osBfEgzrTtZEk0zApNNhrnJ9bf2R\nxDpwwgS168VzNlBckIHcjEdRYyWjUY2UqrsZt2S5SJ6uvD/nCR0x+TBwdLD+X2NM\nXxl694Exn/jEH08srBcnfUqNhmOEFfp2fGkj/j8Pa0DjVXuUgN4NDv7NlfQXtbpz\nIuRJP4svAgMBAAECggEAKCrS3d9IJx9nWcIXcBGJUUr4Anv8c2bKEm/ZWeaPNSFT\nDW4oYG9r/NWGI7AaIrYL+5FQoTllDIB8ivrxDMsFn8/nG0tElJXaVwbbF4LExGpo\n9q8r65zm5gClEiiA72bAB97luGOnMiPDc56TTFwzQAiqjThsblosqBzv8dy4zNQc\nXwx41FaJMgqlEStI9poQ591c6LyH30xkVXgX9QXHMs8hGFdgGw7OjIWWMssv6mxT\n5VpAdn8cj1dXNLllTD+mwQ0uC4RdprGGRO//65Jh9KuRS/HDp9h7iWhSYuDARfHK\nGQP5yTQCsV6r+lQVJQiShjXb7E3pxgQypYJhGEn5YQKBgQDLpmoi/AsgnoSZt42B\nq4dr1n/9aHvCDFU5/WRlJ+zcbDShL01JHLmN5D/V5SlRhwsaA8BEfYUukASIB1e/\nv5xHRnHUYpITasKgWEQw10w4dYiQH/lrgAghQUicIaj7okM5V2/pJFokAnJtQLda\ncXMmK9f5xx/e48tTaakmxkSBYQKBgQC8aOSaDG/eTXU+2VoH2epAmuCeHjMCIFux\njwxJUd+Y/j653tmm2Ma6jS/uCDHUq4V+b9lJ364y47+q8EqXjZvT3KXfU8bj38+7\ntcDzICBc5kBSu9jglS3MFU1H4sOVMBJn4JGwLQhdsyEjUgrdSu/Qv8A39SP0ez39\n3PfkK9MGjwKBgAUP3OGDvE8SQZ+EhXrspZATo9jLqQ/YuKGZX8534JZWBjTfdR9V\nHHOfccrCSHWjUq5R24yYRiAzKjmrXQ4CGENZR+kMji73X2EW8JL6NwXMPhm/Abcf\nVpRlCAYBfC7NCLi7KKf15Fuyx99ZVXVlDoSrYFHwFiW3Kc2n+bFiCj/hAoGAFlli\n9JsREg+iHshtk4zX6r30cw0mA9SOy+sqC/B4U4+lJSs4KkCAolRpIRU7w/xso2jl\nH4w2/7ZgYAiM8JlNqL39txYa+6Dq5VtT/gMLk7mEW8wIl+taOWE1f5d4l9PR+xx6\na6mL2oGLJsNuon1nIR390SV1FGUiH2D8zsYcDCUCgYBmvzJ9cVx2RDGWGPnZ6X4K\n1K03uxjdZKCn/dUtCzR7SCeNRXVrfdYDS3qK/TZ02yp+M1bQM+hTou+WJ1odOpE4\nJBCTkB/wt15pwG7RNRu8kMZ691a7fOaf0P8Zbfgqt12N+XkA76B8OtqFTqeFtCwI\nfdKinpSa+qPNEO8Q/w+ZAA==\n-----END PRIVATE KEY-----\n",
      "client_email": "myatecomm@myatecommerce.iam.gserviceaccount.com",
      "client_id": "116955830035983094531",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/myatecomm%40myatecommerce.iam.gserviceaccount.com",
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

    initPushNotification();
  }

  static Future<String> getDeviceTokenToSendNotification() async {
    fcmToken = (await FirebaseMessaging.instance.getToken()).toString();
    print("FCM Token: $fcmToken");

    return fcmToken;
  }
  // static Future<String> getDeviceTokenToSendNotification() async {
  //    await messaging.requestPermission();
  //   final fCMToken = await messaging.getToken();

  //   return fcmToken;
  // }
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
        'https://fcm.googleapis.com/v1/projects/myatecommerce/messages:send');

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
