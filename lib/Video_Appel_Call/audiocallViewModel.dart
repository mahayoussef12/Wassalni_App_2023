
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wassalni/Video_Appel_Call/constant.dart';

class audicallViewMode extends GetxController{

late int remoteUid=0;
late RtcEngine rtcEngine;

  @override
  void onInit() {
  super.onInit();
  intAgora();
  }

  @override
  void onClose() {
    super.onClose();
    rtcEngine.disableAudio();

  }

  @override
  void onReady() {
  super.onReady();
  }
  intAgora() async {
    await[Permission.camera,Permission.microphone].request();
    rtcEngine= await RtcEngine.create(appId);
    rtcEngine.enableAudio();
    rtcEngine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (channel,uid,elapsed){
          print("User id id ${uid}");
        },
        userJoined: (uid,elapsed){
          print("Remote User id id ${uid}");
          remoteUid=uid;
          update();
        },
        userOffline:  (uid,elapsed){
          print("Remote User id id ${uid} is Left ");
          remoteUid=0;
          update();
          Get.back();
        },
      )
    );
  }
}