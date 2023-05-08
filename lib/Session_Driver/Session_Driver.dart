import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wassalni/Firebase/AuthentificationController.dart';
import 'package:wassalni/Session_User/push_notification_booking.dart';
import 'package:wassalni/Splash/spalsh_screen.dart';
import 'package:wassalni/message/mainScreenChat.dart';
import '../Session_User/Controller.dart';
import '../Session_User/UpdateScreen.dart';
import '../Weather/ui/widgets/app/my_app.dart';
import '../audio_player/audio.dart';
import 'Adresse.dart';
import 'ReservationListScreenDriver.dart';

class Session_Driver extends StatefulWidget {
  const Session_Driver({Key? key}) : super(key: key);

  @override
  State<Session_Driver> createState() => _Session_DriverState();
}

class _Session_DriverState extends State<Session_Driver> {
  final AdresseController controller_Adresse = Get.put(AdresseController());
  @override
  init() async {
    // listen for user to click on notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      String? title = remoteMessage.notification!.title;
      String? description = remoteMessage.notification!.body;
      //im gonna have an alertdialog when clicking from push notification
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        title: title,
        desc:description,
        btnCancelOnPress: (){
          Navigator.pop(context);
        },
        btnOkOnPress: () {
          controller_Adresse.accepter(title);
          Push.sendNotification();
        },
      ).show();
    });
  }

  void initState() {
    super.initState();
    init();
  }

  @override
    Widget build(BuildContext context) {
      final AuthController controller=Get.put(AuthController());
      return Scaffold(
          appBar: AppBar(title: const Text("Driver",),backgroundColor: Colors.black26,
            actions: <Widget>[
              IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    controller.signOut();
                  }),
            ],
          ),
          drawer: session(),

          body:const CurrentLocationScreen());
  }
}
class session extends StatelessWidget {
   session({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final AuthController controller=Get.put(AuthController());

    return Container(
        color: Colors.white,
        width: 255.0,
        child: Drawer(

          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey]),
                ), child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                      "https://media.tenor.com/76rJ6E3tzyoAAAAi/jamrock-taxi-jamaica.gif")),
              ),
              ListTile(
                  title: Center(child: Text("${controller.user}"))),

              ListTile(
                leading: const Icon(Icons.verified_user),
                title: const Text('Profile'),
                onTap: () => {Get.to(ProfileUpdateScreen())},
              ),
              ListTile(
                leading: Icon(
                    Get.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode),
                title: Text("Mode Sombre"),
                onTap: () => {
                  Get.changeTheme(
                      Get.isDarkMode ? ThemeData.light() : ThemeData.dark())
                },
              ),
              ListTile(
                leading: const Icon(Icons.messenger_outlined),
                title: const Text('Chats'),
                onTap: () => {Get.to(const mainScreen())},
              ),
              ListTile(
                  leading: Icon(Icons.taxi_alert),
                  title: Text('Taxi Reservation'),
                  onTap: () {
                    Get.to(ReservationlistScreenDriver());
                  }
              ),
              ListTile(
                leading: Icon(Icons.ac_unit_rounded),
                title: Text('Weather'),
                onTap: () => {Get.to(const weather())},
              ),
              ListTile(
                leading: Icon(Icons.queue_music),
                title: Text('Music'),
                onTap: () => {Get.to(audio())},
              ),


              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Logout'),
                onTap: () => {controller.signOut()},
              ),
            ],
          ),

        ));
  }
}

