import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Firebase/AuthentificationController.dart';
import 'ValidationLogin.dart';
import 'loginWidget.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var email="";
    var password="";
    final AuthController Auth_controller=Get.put(AuthController());
    final ValidateLogin controller = Get.put(ValidateLogin());
    return SafeArea(child: Scaffold(
        body:SingleChildScrollView(
        padding: EdgeInsets.all(30.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    LoginWidget(),
    Container(padding:EdgeInsets.symmetric(vertical: 20.0,),
    child: Form(
    key:controller.loginFormKey,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
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
      SizedBox(
        width: double.infinity,
        child:ElevatedButton(
            onPressed: (){
              if(controller.checkLogin()==true){
                // print(rool);
                Auth_controller.signIn(controller.emailController.text.trim(),controller.passwordController.text.trim());}
            }
            , child: Text("Login")),
      ),

    ])))]))));
  }
}
