
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:wassalni/Model/User.dart';

class AdresseController extends GetxController {

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
   List<UserModel> userData=<UserModel>[].obs;
  @override
  Future<void> onInit() async {
    super.onInit();
    ajouter();
  }

Future<void> ajouter() async {
    final snapshot=await _firebaseFirestore.collection("users").where("role",isEqualTo: "Driver").where("activation",isEqualTo: true).get();
    final  user= snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    userData.assignAll(user);
    for (var i in userData){
     return print(i.name);
    }
    }
  }



