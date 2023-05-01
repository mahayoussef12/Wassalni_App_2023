import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:wassalni/Firebase/AuthentificationController.dart';
import 'package:wassalni/message/mainScreenChat.dart';
import '../Session_User/Controller.dart';
import 'Adresse.dart';

class Session_Driver extends StatefulWidget {
  const Session_Driver({Key? key}) : super(key: key);

  @override
  State<Session_Driver> createState() => _Session_DriverState();
}

class _Session_DriverState extends State<Session_Driver> {
  final AdresseController controller_Adresse = Get.put(AdresseController());
  @override
  void initState() {
    init();
    super.initState();
  }

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
          btnCancelOnPress: () {
           // Get.back();
          },
      btnOkOnPress: () {
    controller_Adresse.update();
      },
      ).show();
    });
  }

  @override

    Widget build(BuildContext context) {
      final AuthController controller=Get.put(AuthController());
      return Scaffold(
          appBar: AppBar(title: const Text("Driver"),
            actions: <Widget>[
              IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    controller.signOut();
                  }),
            ],
          ),
          drawer: Container(
            color: Colors.white,
            width: 255.0,
            child: Drawer(

              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  const DrawerHeader(
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/images/cover.jpg'))),
                    child: Text(
                      'Menu',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.input),
                    title: Text('Welcome'),
                    onTap: () => {},
                  ),
                  ListTile(
                    leading: Icon(Icons.verified_user),
                    title: Text('Profile'),
                    onTap: () => {Navigator.of(context).pop()},
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                    onTap: () => {Navigator.of(context).pop()},
                  ),
                  ListTile(
                    leading: Icon(Icons.messenger_outlined),
                    title: Text('Chats'),
                    onTap: () => {Get.to(mainScreen())},
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Logout'),
                    onTap: () => {Navigator.of(context).pop()},
                  ),
                ],
              ),

            ),
          ),
          body:const CurrentLocationScreen());
  }


}
