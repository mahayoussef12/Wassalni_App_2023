import 'package:flutter/material.dart';

class btnForget extends StatelessWidget {
  const btnForget({
    super.key, required this.iconData, required this.title, required this.subtitle, required this.onTap,
  });
  final IconData iconData;
  final String title,subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(30.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey.shade200,
        ),
        child: Row(
          children: [
            Icon(iconData,size: 60.0,),
            const SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,style:Theme.of(context).textTheme.headline6 ,),
                Text(subtitle,style:Theme.of(context).textTheme.bodyText2 ,)
              ],
            )
          ],
        ),
      ),
    );
  }
}
