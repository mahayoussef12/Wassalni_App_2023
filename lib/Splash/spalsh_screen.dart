import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../decision/Screen_desc.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                screen()
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(
        children:[
          SizedBox(height: 50,),
          Image.asset("images/taxi.gif"),
          SizedBox(height: 40,),
          Text("Wassalni", style: GoogleFonts.lato(
            textStyle: TextStyle(color: Colors.black, letterSpacing: .10,fontSize: 38,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,),
          ),),
          SizedBox(height: 50,),
          CircularProgressIndicator(backgroundColor: Colors.black,)
        ]));
  }
}

