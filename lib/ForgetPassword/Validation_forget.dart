import 'package:flutter/material.dart';
import 'package:get/get.dart';

class validate_forget extends GetxController{
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> ForgetFormKey=GlobalKey<FormState>();
  String? validateEmail(String value){
    if(!GetUtils.isEmail(value)){
      return "email invalid";
    }

    return null;
  }
  bool checkLogin(){
    return ForgetFormKey.currentState!.validate();
  }
}