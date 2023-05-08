import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wassalni/Firebase/AuthentificationController.dart';
import 'package:wassalni/Session_User/UpdateScreen.dart';

import 'package:wassalni/Session_User/UserAdresse.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:wassalni/Constants.dart';
import 'dart:convert';
import '../message/mainScreenChat.dart';
import 'ReservationListScreen.dart';
import 'commentSceen.dart';
class Session_User extends StatefulWidget {
  const Session_User({Key? key}) : super(key: key);

  @override
  _Session_UserState createState() => _Session_UserState();
}

class _Session_UserState extends State<Session_User> {

  Map<String, dynamic>? paymentIntent;
  @override
  init() async {
    // listen for user to click on notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      String? title = remoteMessage.notification!.title;
      String? description = remoteMessage.notification!.body;
      //im gonna have an alertdialog when clicking from push notification
      AwesomeDialog(
        context: context,
        dialogType: DialogType.question,
        animType: AnimType.rightSlide,
        title: title,
        desc:description,
        btnCancelOnPress: (){
          Navigator.pop(context);
        },
        btnOkOnPress: () async {
          await makePayment();
        },
      ).show();
    });
  }

  void initState() {
    super.initState();
    init();
  }
  @override
  Widget build(BuildContext context){
    final AuthController controller=Get.put(AuthController());
    return Scaffold(
        appBar: AppBar(
          title: const Text("User"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  controller.signOut();
                }),

          ],
        ),
        drawer: Container(
          color: Colors.white,
          width: 255.0,
          child: Drawer(

            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                const DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.white, Colors.grey]),
                  ), child:CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                        "https://media.tenor.com/u0YeDNfyHWkAAAAi/cab-traffic.gif")),
                ),
                ListTile(
                    title:  Center(child:Text("${controller.user}"))),


                ListTile(
                  leading: const Icon(Icons.verified_user),
                  title: const Text('Profile'),
                  onTap: () => {Get.to(ProfileUpdateScreen())},
                ),
                ListTile(
                  leading: Icon(Get.isDarkMode ?Icons.light_mode_outlined : Icons.dark_mode),
                  title: Text("Mode Sombre"),
                  onTap: () => {  Get.changeTheme(Get.isDarkMode? ThemeData.light():ThemeData.dark())},
                ),
                ListTile(
                  leading: Icon(Icons.messenger_rounded),
                  title: Text('chats'),
                  onTap: () => {Get.to(mainScreen())},
                ),
                ListTile(
                  leading: Icon(Icons.border_color),
                  title: Text('feedback'),
                  onTap: (){
                    Get.to(CommentPage());
                  },
                ),
                ListTile(
                    leading: Icon(Icons.money),
                    title: Text('Make Payment'),
                    onTap : () async {
                      await makePayment();}
                ),
                ListTile(
                    leading: Icon(Icons.taxi_alert),
                    title: Text('Taxi Reservation '),
                    onTap : ()  {Get.to(ReservationlistScreen());}
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                  onTap: () => {Navigator.of(context).pop()},
                ),
              ],
            ),

          ),
        ),

        body://const CustomMarkerInfoWindowScreen());
        CurrentLocationScreenUser());
  }
  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('3', 'eur');
      //Payment Sheet
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent!['client_secret'],
              // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
              // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
              style: ThemeMode.dark,
              merchantDisplayName: 'Adnan')).then((value) {});


      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet(
      ).then((value) {
        showDialog(
            context: context,
            builder: (_) =>
                AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.check_circle, color: Colors.green,),
                          Text("Payment Successfull"),
                        ],
                      ),
                    ],
                  ),
                ));
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));

        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) =>
          const AlertDialog(
            content: Text("Cancelled "),
          ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $SECRET_KEY',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }
}