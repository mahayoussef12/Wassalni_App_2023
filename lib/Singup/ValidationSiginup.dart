import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ValidateScreen extends GetxController{
  final GlobalKey<FormState> loginFormKey=GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  var  role="".obs as String;

  String? validateEmail(String value){
    if(!GetUtils.isEmail(value)){
      return "email invalid";
    }
    else{
      return "Email required";
    }
    return null;
  }
  String? validatePassword(String value){

    if(value.length<6){
      return "Password must be of 6 characters";
    }
    else {
      return "Password required";
    }
    return null;
  }
  String? validateNumber(String value){

    if(value.length==7){
      return "Number must be equals to 8 characters";
    }
    else {
      return "Number required";
    }
    return null;
  }
  String? validateName(String value){
    if(value.isEmpty){
      return "Name required";
    }
    return null;
  }


  bool checkLogin(){
    return loginFormKey.currentState!.validate();
  }


}