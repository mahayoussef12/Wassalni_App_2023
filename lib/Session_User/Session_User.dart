import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Firebase/AuthentificationController.dart';

class Session_User extends StatelessWidget {
  const Session_User({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController controller=Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(title: const Text("user"),),
        body: Center(child:TextButton(onPressed: () {
          controller.signOut();
        }, child: const Text("signOut"),),
        ));
  }
}