import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/User.dart';

class Push {
  static late UserModel me;

  // for accessing firebase messaging (Push Notification)
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;
  static FirebaseFirestore _db = FirebaseFirestore.instance;

  // for getting firebase messaging token
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log('Push Token: $t');
      }
    });
  }

  // for sending push notification
  static Future<void> sendPushNotification(String id) async {
    final prefs = await SharedPreferences.getInstance();

    _db.collection('users')
        .doc(prefs.getString('idDriver'))
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        {
          try {
            final body = {
              "to": documentSnapshot.get('pushToken'),
              "notification": {
                "title": id, //our name should be send
                "body": "reservation",
                "android_channel_id": "chats"
              },
            };

            var res = await post(
                Uri.parse('https://fcm.googleapis.com/fcm/send'),
                headers: {
                  HttpHeaders.contentTypeHeader: 'application/json',
                  HttpHeaders.authorizationHeader:
                  'key=AAAAFN3Cc6w:APA91bG-fEMPn9oV60tPFlc2zRn_Z3Y50xMQk2USRjnGoGBHi_aFO5unAp8a0qR3PTJZSX_UZIpQ9tYGOlEbMXegqoSs1DL4tMmhyIZTYIsU8Uq31ataj83Apspi6pa7yDh7ZlYwDPgB'
                },
                body: jsonEncode(body));
            log('Response status: ${res.statusCode}');
            log('Response ody: ${res.body}');
          } catch (e) {
            log('\nsendPushNotificationE: $e');
          }
        }
      }
    });
  }

  static Future<void> sendNotification() async {
    final prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("document");
    _db.collection('users')
        .doc(prefs.getString('document'))
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        {
          try {
            final body = {
              "to": documentSnapshot.get('pushToken'),
              "notification": {
                "title": "payment", //our name should be send
                "body": "Pay Now ",
                "android_channel_id": "chats"
              },
            };

            var res = await post(
                Uri.parse('https://fcm.googleapis.com/fcm/send'),
                headers: {
                  HttpHeaders.contentTypeHeader: 'application/json',
                  HttpHeaders.authorizationHeader:
                  'key=AAAAFN3Cc6w:APA91bG-fEMPn9oV60tPFlc2zRn_Z3Y50xMQk2USRjnGoGBHi_aFO5unAp8a0qR3PTJZSX_UZIpQ9tYGOlEbMXegqoSs1DL4tMmhyIZTYIsU8Uq31ataj83Apspi6pa7yDh7ZlYwDPgB'
                },
                body: jsonEncode(body));
            log('Response status: ${res.statusCode}');
            log('Response ody: ${res.body}');
          } catch (e) {
            log('\nsendPushhNotificationE: $e');
          }
        }
      }
    });
  }
}