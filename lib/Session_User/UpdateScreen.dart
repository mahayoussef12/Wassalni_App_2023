import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../Singup/LoginHeaderWidget.dart';
import '../Singup/ValidationSiginup.dart';
import 'Session_User.dart';

class ProfileUpdateScreen extends StatefulWidget {
  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final ValidateScreen controller = Get.put(ValidateScreen());

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    final User? user = _auth.currentUser;
    final DocumentSnapshot userData =
        await _firestore.collection('users').doc(user!.uid).get();
    setState(() {
      _nameController.text = userData['name'];
      _emailController.text = userData['email'];
      _phoneNumberController.text = userData['number'];
    });
  }

  void updateUserData() async {
    final User? user = _auth.currentUser;
    final DocumentReference userRef =
        _firestore.collection('users').doc(user!.uid);
    userRef.update({
      'name': _nameController.text,
      'email': _emailController.text,
      'number': _phoneNumberController.text
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Update Profile'),
        ),
        drawer: Drawer_User(),

        body: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const LoginHeaderWidget(
                    image: 'images/taxi_update.JPG',
                    title: 'Get On Board ',
                    subtitle: 'Update your profile to start your journey',
                  ),
                   Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                      ),
                    child: Form(
                      key: controller.SiginFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                  label: Text("Name"),
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  ),
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2.0, color: Colors.yellow))),
                              controller: _nameController,
                              validator: (value) {
                                return controller.validateName(value!);
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  label: Text("Email"),
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.black,
                                  ),
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2.0, color: Colors.yellow))),
                              controller: _emailController,
                              validator: (value) {
                                return controller.validateEmail(value!);
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  label: Text("Number"),
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: Colors.black,
                                  ),
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2.0, color: Colors.yellow))),
                              controller: _phoneNumberController,
                              validator: (value) {
                                return controller.validateNumber(value!);
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(),
                                  foregroundColor: Colors.white,
                                  side: BorderSide(
                                      color: Colors.black
                                  ),),
                                onPressed: () {
                                  updateUserData();
                                  Navigator.pop(context);  },
                                child: FittedBox(
                                  child: Obx(
                                        () => controller.isLoading.value

                                            ? Center(
                                      child: CircularProgressIndicator(color: Colors.white,),
                                    )
                                        : Text(
                                      'Update',
                                    ),
                                  ),
                                ),

                              ),
                            ),
                          ])))
            ])));
  }
}
