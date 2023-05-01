import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wassalni/Firebase/AuthentificationController.dart';

import 'package:wassalni/Session_User/UserAdresse.dart';

import '../message/mainScreenChat.dart';

class Session_User extends StatelessWidget {
  const Session_User({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final AuthController controller=Get.put(AuthController());
    return Scaffold(
        appBar: AppBar(
          title: const Text("User"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.logout),
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
          DrawerHeader(
          child: Text(
          'Menu',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
              decoration: BoxDecoration(
                  color: Colors.yellow,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/cover.jpg'))),
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
                leading: Icon(Icons.messenger_rounded),
                title: Text('chats'),
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

        body://const CustomMarkerInfoWindowScreen());
        CurrentLocationScreenUser());
  }
}