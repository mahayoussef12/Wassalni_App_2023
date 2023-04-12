import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wassalni/Video_Appel_Call/audiocallViewModel.dart';

class audio_call extends GetWidget<audicallViewMode> {


  @override
  Widget build(BuildContext context) {
    return GetBuilder<audicallViewMode>(
        init: audicallViewMode(),
        builder: (controller)=>
            Scaffold(
              body: Stack(
                children: [
                  Center(
                    child: controller.remoteUid != 0 ?Text("deja connecteé"):Text("Appel en cours"),),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: IconButton(onPressed: () { Get.back(); }, icon: Icon(Icons.call_end_sharp),
                      
                    ),

                  )
                ],
              ),

            )

    );
  }
}
