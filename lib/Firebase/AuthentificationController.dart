
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wassalni/Login/Login.dart';
import '../Model/User.dart';
import '../Session_Driver/Session_Driver.dart';
import '../Session_User/Session_User.dart';
import 'firebase.auth.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> firebaseUser;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? get user => firebaseUser.value?.email;
  late bool number;
var label="".obs;



  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }
  _setInitialScreen(User? user) {
   route();
  }

  void signUp(String name, String email, String number, String password,
      String role,) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    await auth.createUserWithEmailAndPassword(
        email: email, password: password).then((result) async {
      UserModel newUser = UserModel(
          name: name,
          email: email,
          number: number,
          password: password,
          role: role,
          activation: true, latitude: 0, longitude: 0, image: 'https://www.mbaa.besancon.fr/wp-content/plugins/instagram-widget-by-wpzoom/assets/backend/img/user-avatar.jpg',
          id:  FirebaseAuth.instance.currentUser!.uid, pushToken: '', isOnline:false, lastActive: time);
      _createUserFirestore(newUser);


    })
        .catchError((e) {});
  }

  void _createUserFirestore(UserModel user) {
    var users = auth.currentUser;
    _db.collection('users').doc(users!.uid).set(user.toJson()).then((value) =>
        Get.snackbar(
            "Add",
            "Added successfully",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
            isDismissible: true,
            backgroundColor: Colors.green.shade200
        )
    );
    Get.offAll(const Login());


  }

  void route() {
    _db.collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('role') == "User") {
          Get.offAll(const Session_User());
        } else {
          Get.offAll(const Session_Driver());
        }
      } else {
        Get.snackbar(
          "unsuccessful",
          "Document does not exist on the database",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.red.shade200,

        );
      }
    });
  }

  void signIn(String email, String password) async {

      try {
        await auth.signInWithEmailAndPassword(email: email, password: password).then((value) => route());
      } catch (firebaseAuthException ) {
        Get.snackbar(
          "unsuccessful",
          "Document does not exist on the database",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.red.shade200,

        );

      }


  }

  Future<void> resetPassword({required String email}) async {
    await auth.sendPasswordResetEmail(email: email) .then((value) =>Get.snackbar(
      "successful",
      "Password Reset Email Sent ",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.green.shade200,
      isDismissible: true,
    ),

    );}
  void signOut() async {
    await auth.signOut().then((value) => Get.offAll(Login()));
  }
  updateStatus() async{
    _db.collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        {
         if(documentSnapshot.get("activation")==true){
            _db.collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid).update({
              'activation': false,
            }).then((value) {
              print('Base Firestore à jour');
              activation();
            });
          }
          else{
            _db.collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid).update({
              'activation': true,
            }).then((value) {
              print('Base Firestore à jour');
              activation();
            });
          }

        }
      };
    });

  }
 activation()async {
  _db.collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if( documentSnapshot.get("activation")==true){
     return label.value="Online";
    }
    else if( documentSnapshot.get("activation")==false) {
     return label.value="Offline";
    }
  });
}


}


