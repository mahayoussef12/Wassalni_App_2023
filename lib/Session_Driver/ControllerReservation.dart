import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Controller_reservation extends GetxController {
  static var index = "".obs;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getReservation() {
    return firestore
        .collection('bookings')
        .where('idDriver', isEqualTo: FirebaseAuth.instance.currentUser!.uid,)
        .snapshots();
  }

  static Future<void> updateDestination(String commentId, String dest) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(commentId)
          .update({'destination': dest}).then((value) =>
          print(commentId)
      );
    } catch (e) {
      print('Error updating comment in Firebase: $e');
    }
  }

 static Future<void> deleteDestination(String card) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(card)
          .delete();
    } catch (e) {
      print('Error deleting comment from Firebase: $e');
    }
  }
  accepter(String? title)  async {
    final prefs = await SharedPreferences.getInstance();

    FirebaseFirestore.instance.collection('bookings')
        .doc(title)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        {
          if (documentSnapshot.get("acceptation") == false) {
            FirebaseFirestore.instance.collection('bookings')
                .doc(title).update({
              'acceptation': true,
            }).then((value) {
              prefs.setString("document",documentSnapshot.get("idUser"));
              print('Base Fireestore à jour');});

          }
          else if(documentSnapshot.get("acceptation") == true) {
            FirebaseFirestore.instance.collection('bookings')
                .doc(title).update({
              'acceptation': false,
            }).then((value) {
              prefs.setString("document",documentSnapshot.get("idUser"));
              print('Base Fireestore à jour');});

          }
        }
      }
    });
  }
}