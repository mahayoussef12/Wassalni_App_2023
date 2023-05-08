import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ValidateScreen extends GetxController{
  final GlobalKey<FormState> SiginFormKey=GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  var isLoading = false.obs;
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
  String? validateNumber(String value){

    if(value.length==11){
      return "Number must be equals to 8 characters";
    }
    else if(value.isEmpty) {
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


  checkLogin(){
    isLoading.value = true;
  SiginFormKey.currentState!.validate();
  }


}