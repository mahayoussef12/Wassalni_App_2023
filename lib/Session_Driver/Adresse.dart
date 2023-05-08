import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Firebase/AuthentificationController.dart';
class CurrentLocationScreen extends StatefulWidget {

  const CurrentLocationScreen({Key? key, }) : super(key: key);

  @override
  _CurrentLocationScreenState createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {

  late Rx<User?> firebaseUser;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? get user => firebaseUser.value?.email;
 var address;
  final Completer<GoogleMapController> _controller = Completer();
 final AuthController Auth_controller=Get.put(AuthController());

  Future<Position> _getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {
    }).onError((error, stackTrace){
      print(error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }


  final List<Marker> _markers =  <Marker>[];
  static const CameraPosition _kGooglePlex =  CameraPosition(
    target: LatLng(33.6844, 73.0479),
    zoom: 14,
  );


  List<Marker> list = const [

  ];

  @override
  void initState() {
    super.initState();
    _markers.addAll(list);
    Auth_controller.activation();
    //loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _kGooglePlex,
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              markers: Set<Marker>.of(_markers),
              onMapCreated: (GoogleMapController controller){
                _controller.complete(controller);
              },
            ),
            // button update status
            Obx(() =>Container(
                alignment: Alignment.topCenter,
                child: FloatingActionButton.extended(
                    backgroundColor: Auth_controller.label.value=="Online"?Colors.green:Colors.red,
                  onPressed: () {
                    Auth_controller.updateStatus();

                    // Respond to button press
                  },
                  label: Text(Auth_controller.label.value),
                )
            ),),
            // button current location
            Container(
              alignment: Alignment.bottomCenter,
               child: FloatingActionButton.extended(
                onPressed: (){
                  // localisation button
                  _getUserCurrentLocation().then((value) async {
                    // changement photo de localisation
                    BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
                      const ImageConfiguration(),
                      "images/taxi_location.png",
                    );
                      // ajouter marks en maps
                    _markers.add(
                        Marker(
                          markerId: const MarkerId('SomeeId'),
                          position: LatLng(value.latitude ,value.longitude),
                          infoWindow:  InfoWindow(
                              title:address
                          ),
                          icon: markerbitmap,
                        )
                    );
                    final GoogleMapController controller = await _controller.future;

                    CameraPosition _kGooglePlex =  CameraPosition(
                      target: LatLng(value.latitude ,value.longitude),
                      zoom: 14,
                    );
                    controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));

                    List<Placemark> placemarks = await placemarkFromCoordinates(value.latitude ,value.longitude);

                    // update lantitude+longitude
                    _db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get()
                    .then((DocumentSnapshot documentSnapshot) {

                                             _db.collection('users')
                                              .doc(FirebaseAuth.instance.currentUser!.uid).update({
                                                     'latitude': value.latitude,
                                                      'longitude':value.longitude,
                                             }).then((value) {
                                               print('Base Firestore à jour');
                                                                   });});
                      final add = placemarks.first;
                      // les infomation adress de localisation
                    setState(() {
                      address = add.locality.toString() +" "+add.country.toString()+add.street.toString()+add.isoCountryCode.toString()+
                          add.locality.toString()+add.name.toString()+add.postalCode.toString();

                    });

                  });
                },
                // Add your onPressed code here!
                label: const Text('Current Location'),
                 icon: const Icon(Icons.location_on_rounded),
                 backgroundColor:  Colors.black54,

            ),)




  ]),));
  }


}