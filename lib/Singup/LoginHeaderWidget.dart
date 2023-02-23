import 'package:flutter/material.dart';

class  LoginHeaderWidget extends StatelessWidget {
  const  LoginHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(

       child: Image(image: AssetImage('images/taxi1.png'),height: size.height*0.2,)),
        Center(child: Text("Get On Board!",style: Theme.of(context).textTheme.headline2)),
        Center(child: Text("Create your profile to start your journey",style: Theme.of(context).textTheme.bodyText1))

      ],
    );
  }
}
