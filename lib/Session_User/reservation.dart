
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Controller.dart';


class Reservation extends StatelessWidget {
  const Reservation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AdresseController controller = Get.put(AdresseController());
    return Scaffold(
      appBar: AppBar(title: const Text('Reservation Formee')),
        /*body:controller.bookingData.length==null?const CircularProgressIndicator():ListView.builder(
            itemCount: controller.bookingData.length==null?0:controller.bookingData.length,
            itemBuilder: (con, index) {
              return ListTile(
                *//*leading: CircleAvatar(
                backgroundImage: NetworkImage(data['position'])
            ),*//*
                title: Text('${controller.bookingData[index].age}'),
                //subtitle: Text(products.age),

              );
            })*/
    );
  }

}