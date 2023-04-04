import 'package:flutter/material.dart';

class  LoginHeaderWidget extends StatelessWidget {
  const  LoginHeaderWidget({Key? key, required this.image, required this.title, required this.subtitle}) : super(key: key);
final String image;
final String title;
final String subtitle;
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(

       child: Image(image: AssetImage(image ),height: size.height*0.2,)),
        Center(child: Text(title,style: Theme.of(context).textTheme.headline2)),
        Center(child: Text(subtitle,style: Theme.of(context).textTheme.bodyText1))

      ],
    );
  }
}
