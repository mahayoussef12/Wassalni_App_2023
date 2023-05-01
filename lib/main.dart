
import 'dart:developer';


import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:flutter_notification_channel/notification_visibility.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'Splash/spalsh_screen.dart';
late Size mq;
/*
Future<void> backgroundHandler(RemoteMessage message) async{
  String? title=message.notification!.title;
  String? body=message.notification!.body;
  AwesomeNotifications().createNotification(content:
  NotificationContent(id: 123, channelKey: "Reservation_channel",color: Colors.white,
    title: title,
    body: body,
    category: NotificationCategory.Call,
    wakeUpScreen: true,
    fullScreenIntent: true,
    autoDismissible: false,
    backgroundColor:Colors.orange,

  ),
      actionButtons: [
        NotificationActionButton(key:"ACCEPT", label: "Accept reservation",
          color: Colors.green,
          autoDismissible: true,
        ),
        NotificationActionButton(key:"REJECT", label: "Reject reservation",
          color: Colors.green,
          autoDismissible: true,
        )
      ]);

}
*/

Future<void> main() async {
  /*AwesomeNotifications().initialize(null,[
    NotificationChannel(
        channelKey: "Reservation_channel",
        channelName: "Reservation_channel",
        channelDescription: "Reservation_channel",
        defaultColor: Colors.redAccent,
      ledColor: Colors.white, importance: NotificationImportance.Max,
      channelShowBadge: true,
      locked: true,
      defaultRingtoneType: DefaultRingtoneType.Ringtone

    )
]);
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);*/
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //enter full-screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  //for setting orientation to portrait only
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    _initializeFirebase();
    runApp(MyApp());
  });
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Wassalni',
      theme: ThemeData(
      ),
      home:
      MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}


_initializeFirebase() async {
  var result = await FlutterNotificationChannel.registerNotificationChannel(
      description: 'For Showing Message Notification',
      id: 'chats',
      importance: NotificationImportance.IMPORTANCE_HIGH,
      visibility: NotificationVisibility.VISIBILITY_PUBLIC,
      allowBubbles: true,
      enableVibration: true,
      enableSound: true,
      showBadge: true,
      name: 'Chats');
  log('\nNotification Channel Result: $result');
}
