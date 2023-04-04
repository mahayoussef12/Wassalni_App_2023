import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Login/Login.dart';
import '../Singup/Screen_Signup.dart';

class screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Image(image: AssetImage('images/intro.jpg')),
            Column(
              children: [
                Text("Wassalni is waiting for you...",style: Theme.of(context).textTheme.headline3,),
                Text("Choose your destination Wassalni is waiting for you",style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,),],),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: (){
                  Get.to(Login());
                }, child: Text("Login".toUpperCase()),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(),
                    foregroundColor: Colors.black,
                    side: const BorderSide(
                      color: Colors.black),
                    padding: EdgeInsets.symmetric(vertical: 15.0)),)),
               const SizedBox(width: 10.0,),
               Expanded(child: ElevatedButton(onPressed: (){
                 Get.to(const Siginup_Screen());}, child: Text("signup".toUpperCase()),
                 style: ElevatedButton.styleFrom(
                   elevation: 0,
                   backgroundColor: Colors.black,
                     shape: const RoundedRectangleBorder(),
                     foregroundColor: Colors.white,
                     side: const BorderSide(
                         color: Colors.black),
                     padding: const EdgeInsets.symmetric(vertical: 15.0)),))],)],),
      ),
    );
  }
}