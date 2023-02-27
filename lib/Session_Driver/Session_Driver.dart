import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wassalni/Firebase/AuthentificationController.dart';

class Session_Driver extends StatelessWidget {
  const Session_Driver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController controller=Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(title: const Text("Driver"),),
      body: Center(child:TextButton(onPressed: () {
        controller.signOut();
      }, child: const Text("signOut"),),
    ));
  }
}
