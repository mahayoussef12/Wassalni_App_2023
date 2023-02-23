
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../Model/User.dart';
import 'firebase.auth.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> firebaseUser;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? get user => firebaseUser.value?.email;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    //ever(firebaseUser, _setInitialScreen);
  }


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
      //postDetailsToFirestore(name, email, number, password, role);
        })
        .catchError((e) {});
  }
  void _createUserFirestore(UserModel user) {
    _db.collection('users').add(user.toJson());

    Get.snackbar(
      "Add",
      user.role,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 1),
      isDismissible: true,
    );
  }

  /*postDetailsToFirestore(String name, String email, String number,
      String password, String? selectedValue) async {
    var user = auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(user!.uid).set({
      'name': name,
      'email': email,
      'number': number,
      'password': password,
      "selectedValue": selectedValue
    });
    Get.snackbar(
      "Add",
      "Added product",
      icon: Icon(Icons.add_circle, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      borderRadius: 20,
      margin: EdgeInsets.all(15),
      colorText: Colors.white,
      duration: Duration(seconds: 1),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }*/


/*
void route() {
  User? user = FirebaseAuth.instance.currentUser;
  var kk = FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      if (documentSnapshot.get('rool') == "Teacher") {

        Get.to(Teacher());
      }else{
        Get.to(Student());
      }
    } else {
      print('Document does not exist on the database');
    }
  });
}

void signIn(String email, String password) async {

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      route();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

*/
}