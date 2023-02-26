
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
  var verificationId = ''.obs;
  var phone=''.obs;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }
  _setInitialScreen(User? user) {
    if (user != null) {
      _db.collection('users')
          .doc(user.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          if (documentSnapshot.get('role') == "User") {
            Get.offAll(Session_User());
          } else {
            Get.offAll(Session_Driver());
          }
        }
      });
    }}

  void signUp(String name, String email, String number, String password,
      String role,) async {
    await auth.createUserWithEmailAndPassword(
        email: email, password: password).then((result) async {
      UserModel newUser = UserModel(
          name: name,
          email: email,
          number: number,
          password: password,
          role: role,
          activation: true);
      _createUserFirestore(newUser);
      Get.offAll(Login());

    })
        .catchError((e) {});
  }

  void _createUserFirestore(UserModel user) {
    var users = auth.currentUser;
    _db.collection('users').doc(users!.uid).set(user.toJson());

    Get.snackbar(
      "Add",
      "Added successfully",
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
      isDismissible: true,
      backgroundColor: Colors.green.shade200
    );

  }

  void route() {
    _db.collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('role') == "User") {
          Get.offAll(Session_User());
        } else {
          Get.offAll(Session_Driver());
        }
      } else {
        Get.snackbar(
          "unsuccessful",
          "Document does not exist on the database",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.red.shade200,
          isDismissible: true,
        );
      }
    });
  }

  void signIn(String email, String password) async {
    try {
      try {
        await auth.signInWithEmailAndPassword(email: email, password: password)
            .then((value) => route());
      } catch (firebaseAuthException) {}
      route();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        Get.snackbar(
          "unsuccessful",
          "No user found for that email.",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red.shade200,
          isDismissible: true,
        );
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        Get.snackbar(
          "unsuccessful",
          "Wrong password provided for that user.",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red.shade200,
          isDismissible: true,
        );
      }
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
    ));}
  void signOut() async {
    await auth.signOut().then((value) => Get.offAll(Login()));
  }

}

