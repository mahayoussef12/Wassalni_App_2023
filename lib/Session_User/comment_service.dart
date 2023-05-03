import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
class Comment {
  late final String id;
  late final String idUser;
  late final String text;
  late final double rating;

  Comment( {required this.idUser, required this.text, required this.rating,  required this.id, });

  factory Comment.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return Comment(
        id: document.id, text: data['text'], rating: data['rating'], idUser: data['idUser']);

  }
  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    idUser=json['idUser'] ??'';
    text=json['text'] ?? '';
    rating=json['rating'] ?? '';
  }
}
class Controller_Feedback extends GetxController {
   List<Comment> comments = <Comment>[].obs;
   var index="".obs;
   static FirebaseFirestore firestore = FirebaseFirestore.instance;


   @override
    onInit() async {
     super.onInit();
   }
// Modifiez un commentaire dans la base de données
  Future<void> updateComment(String commentId, Comment comment) async {
    try {
      await FirebaseFirestore.instance
          .collection('comments')
          .doc(commentId)
          .update({'text': comment.text, 'rating': comment.rating}).then((value) =>
                print(commentId)
      );
    } catch (e) {
      print('Error updating comment in Firebase: $e');
    }
  }

// Supprimer un commentaire de la base de données
  Future<void> deleteComment(String commentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('comments')
          .doc(commentId)
          .delete();
    } catch (e) {
      print('Error deleting comment from Firebase: $e');
    }
  }

// Récupérez tous les commentaires de la base de données
/*  Future<void> getComments() async {
    final snapshot = await FirebaseFirestore.instance.collection('comments').where('idUser', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    final data = snapshot.docs.map((e) => Comment.fromSnapshot(e)).toList();
    comments.assignAll(data);
  }*/
// for getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getComments() {

    return firestore
        .collection('comments')
        .where('idUser', isEqualTo:FirebaseAuth.instance.currentUser!.uid ,)

        .snapshots();
  }
}