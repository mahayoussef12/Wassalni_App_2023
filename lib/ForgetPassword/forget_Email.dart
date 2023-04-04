import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wassalni/ForgetPassword/Validation_forget.dart';


import '../Firebase/AuthentificationController.dart';
import '../Singup/LoginHeaderWidget.dart';

class Forget_Email extends StatelessWidget {
  const Forget_Email({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController controller=Get.put(AuthController());
   final validate_forget validate=Get.put(validate_forget());
 return SafeArea(child: Scaffold(
    body:SingleChildScrollView(
    padding: const EdgeInsets.all(30.0),

     child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         const SizedBox(height: 50,),
         const LoginHeaderWidget(image: 'images/locker.jpg', title: 'Forget Password !!', subtitle: 'Forget password is waiting fo you  ',),
        const SizedBox(height: 30,),
         Form(key:validate.ForgetFormKey,
             autovalidateMode: AutovalidateMode.onUserInteraction,
             child: Column(
           children: [TextFormField(
             controller: validate.emailController,
            decoration: const InputDecoration(
             label:Text("Email"),
             border: OutlineInputBorder(),
             prefixIcon: Icon(Icons.email_outlined,color: Colors.black,),
             labelStyle: TextStyle(color: Colors.black),
             focusedBorder: OutlineInputBorder(
                 borderSide: BorderSide(width: 2.0,color: Colors.yellow)
             )
         ),
           ),
             const SizedBox(height: 20,),
             SizedBox(
                 width: double.infinity,
                 child:ElevatedButton(
                     onPressed: (){
                       if (validate.checkLogin()){

                       controller.resetPassword(email: validate.emailController.text.trim());

                     }},
                     style: ElevatedButton.styleFrom(
                       elevation: 0,
                       backgroundColor: Colors.black,
                       shape: const RoundedRectangleBorder(),
                       foregroundColor: Colors.white,
                       side: const BorderSide(
                           color: Colors.black
                       ),), child: Text("Next"))
             ),

           ],
         ))


  ]))));}
}
