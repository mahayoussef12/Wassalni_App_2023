import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wassalni/Firebase/AuthentificationController.dart';
import 'package:wassalni/Singup/ValidationSiginup.dart';

import '../Login/Login.dart';
import 'LoginHeaderWidget.dart';

class Siginup_Screen extends StatefulWidget {
  const Siginup_Screen({Key? key}) : super(key: key);

  @override
  State<Siginup_Screen> createState() => _Siginup_ScreenState();
}

class _Siginup_ScreenState extends State<Siginup_Screen> {
  final ValidateScreen controller=Get.put(ValidateScreen());
  final AuthController Auth_controller=Get.put(AuthController());
  final List<String> genderItems = [
    'User',
    'Driver',
  ];
  var rool ;
  var email="";
  var password="";
  var name="";
  var number="";
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child:Scaffold(
      body:SingleChildScrollView(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LoginHeaderWidget(image: 'images/taxi1.png', title: 'Get On Board ', subtitle: 'Create your profile to start your journey',),
            Container(padding:EdgeInsets.symmetric(vertical: 20.0,),
              child: Form(
                key:controller.SiginFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      label:Text("Name"),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person,color: Colors.black,),
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0,color: Colors.yellow)
                      )
                    ),
                    controller: controller.nameController,
                    onSaved: (value){
                     name=value!;
                    },
                    validator: (value){
                      return controller.validateName(value!);
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    decoration: const InputDecoration(
                        label:Text("Email"),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email,color: Colors.black,),
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0,color: Colors.yellow)
                        )

                    ),
                    controller: controller.emailController,
                    onSaved: (value){
                      email=value!;
                    },
                    validator: (value){
                      return controller.validateEmail(value!);
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    decoration: const InputDecoration(
                        label:Text("Number"),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone,color: Colors.black,),
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0,color: Colors.yellow)
                        )
                    ),
                    controller: controller.numberController,
                    onSaved: (value){
                      number=value!;
                    },
                    validator: (value){
                      return controller.validateNumber(value!);
                    },
                  ),
                  const SizedBox(height: 10,), TextFormField(
                    decoration: const InputDecoration(
                        label:Text("Password"),

                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock_clock,color: Colors.black,),
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0,color: Colors.yellow)
                        )
                    ),
                    obscureText: true,
                    controller: controller.passwordController,
                    onSaved: (value){
                      password=value!;
                    },
                    validator: (value){
                      return controller.validatePassword(value!);
                    },
                  ),
                  const SizedBox(height: 10,),
                  DropdownButtonFormField2(
                    decoration: InputDecoration(
                      //Add isDense true and zero Padding.
                      //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      //Add more decoration as you want here
                      //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                    ),
                    isExpanded: true,
                    hint: const Text(
                      'Select Your Role',
                      style: TextStyle(fontSize: 14),
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black45,
                    ),
                    iconSize: 30,
                    buttonHeight: 60,
                    buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    items: genderItems
                        .map((item) =>
                        DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select Role.';
                      }
                    },
                      onChanged: (newvalue) {
                        //Do something when changing the item if you want.
                        setState(() {
                          rool=newvalue!;
                         // print(rool);
                        });

                      },

                  ),
                  const SizedBox(height: 10,),
                  SizedBox(
                    width: double.infinity,
                  child:ElevatedButton(
                      onPressed: (){
                    if(controller.checkLogin()==true){
                    // print(rool);
                      Auth_controller.signUp(controller.nameController.text.trim(),controller.emailController.text.trim(),
                         controller.numberController.text.trim(),controller.passwordController.text.trim(),rool);}
                    }

                      , child: Text("Signup"),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(),
                      foregroundColor: Colors.white,
                      side: BorderSide(
                          color: Colors.black
                      ),
                  )),
                  ),
                  const SizedBox(height: 20,),
                  Center(child: Text("or".toUpperCase())),
                  const SizedBox(height: 10,),
                  Center(child:
                  TextButton(onPressed:(){
                    Get.to(Login());
                  }, child: Text("Already have an  account")))
                ],
              ),

              ),
            )
          ],
        ),
      )
    ));
  }
}
