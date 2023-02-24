import 'package:flutter/material.dart';

class  LoginWidget extends StatelessWidget {
  const  LoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(

            child: Image(image: AssetImage('images/taxi1.png'),height: size.height*0.2,)),
        Center(child: Text("Welcome!",style: Theme.of(context).textTheme.headline2)),
        Center(child: Text("Wassalni is waiting for you",style: Theme.of(context).textTheme.bodyText1))

      ],
    );
  }
}
