import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Firebase/AuthentificationController.dart';

class ValidateLogin extends GetxController{
  final GlobalKey<FormState> loginFormKey=GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController Auth_controller=Get.put(AuthController());

  String? validateEmail(String value){
    if(!GetUtils.isEmail(value)){
      return "email invalid";
    }

    return null;
  }
  String? validatePassword(String value){

    if(value.length<6){
      return "Password must be of 6 characters";
    }
    return null;
  }


  bool checkLogin(){
    return loginFormKey.currentState!.validate();
  }


}