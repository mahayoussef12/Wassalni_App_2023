
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wassalni/Model/User.dart';
import 'package:wassalni/Session_User/push_notification_booking.dart';
import 'package:wassalni/Session_User/reservation.dart';

import '../Model/booking.dart';

class AdresseController extends GetxController {

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<UserModel> userData = <UserModel>[].obs;
  List<booking> bookingData = <booking>[].obs;

  @override
  Future<void> onInit() async {
    ajouter();
    get();
    super.onInit();
  }

  Future<void> ajouter() async {
    final snapshot = await _firebaseFirestore.collection("users").where(
        "role", isEqualTo: "Driver").where("activation", isEqualTo: true).get();
    final user = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    userData.assignAll(user);
  }

  Future<void> get() async {
    final snapshot = await _firebaseFirestore.collection("bookings").where(
        "idUser", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    final data = snapshot.docs.map((e) => booking.fromSnapshot(e)).toList();
    bookingData.assignAll(data);
  }

  accepter(String? title)  async {
    final prefs = await SharedPreferences.getInstance();

    _firebaseFirestore.collection('bookings')
        .doc(title)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        {
          if (documentSnapshot.get("acceptation") == false) {
            _firebaseFirestore.collection('bookings')
                .doc(title).update({
              'acceptation': true,
            }).then((value) {
              prefs.setString("document",documentSnapshot.get("idUser"));

             // Push.sendNotification(snapshot.get("pushToken"));
              print('Base Fireestore à jour');});

          }
        }
      }
    });
  }

}


