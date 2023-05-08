import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wassalni/ForgetPassword/forget_Email.dart';
import 'package:wassalni/Singup/Screen_Signup.dart';

import '../Firebase/AuthentificationController.dart';
import '../ForgetPassword/btnForget.dart';
import '../Singup/LoginHeaderWidget.dart';
import '../chatBot/chatbody.dart';
import 'ValidationLogin.dart';


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
    padding: const EdgeInsets.all(30.0),

    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    LoginHeaderWidget(image: 'images/taxi1.png', title: 'Welcome!', subtitle: 'Wassalni is waiting for you',),
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
    },validator: (value){
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
              if(controller.checkLogin()){
                // print(rool);
                Auth_controller.signIn(controller.emailController.text.trim(),controller.passwordController.text.trim());}
              },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.black,
            shape: const RoundedRectangleBorder(),
            foregroundColor: Colors.white,
            side: const BorderSide(
                color: Colors.black
            ),), child: Text("Login"))
      ),
      const SizedBox(height: 10,),
      Align(
        alignment: Alignment.centerRight,
        child: TextButton(onPressed: () {
          showModalBottomSheet(context: context,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))
              ,builder: (context)=>Container(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Selection",style: Theme.of(context).textTheme.headline2,),
                Text("Select one of the option given below to reset your password",style: Theme.of(context).textTheme.bodyText2,),
              const SizedBox(height: 40,),
                btnForget(iconData: Icons.email_outlined, title: 'E-mail', subtitle: 'Reset password via E-mail', onTap: () { Get.to(Forget_Email()); },),

              ],
            ),
          ));
        }, child: Text("Forgot Password ?"),
          
        ),
      ),
      const SizedBox(height: 20,),
      Center(child: Text("or".toUpperCase())),
      const SizedBox(height: 10,),
      Center(child:
      TextButton(onPressed:(){
        Get.to(const Siginup_Screen());
      }, child: const Text("Don't have an account "))),
      ElevatedButton(onPressed:
          (){ Get.to(ChatPage());

      },
        style: ElevatedButton.styleFrom(
          primary: Colors.black,
          alignment: Alignment.bottomLeft,
        ),child:Icon(Icons.mark_unread_chat_alt),
      )

    ])))]))));
  }
}

