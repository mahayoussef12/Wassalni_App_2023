import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'Firebase/AuthentificationController.dart';

import 'Session_User/Controller.dart';
import 'package:custom_info_window/custom_info_window.dart';

import 'Session_User/TaxiReservationWidget.dart';
class CurrentLocationScreenUser extends StatefulWidget {

  const CurrentLocationScreenUser ({Key? key, }) : super(key: key);

  @override
  _CurrentLocationScreenState createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreenUser> {

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState> ();
  CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
  final AdresseController controller_Adresse = Get.put(AdresseController());

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var address;
  final Completer<GoogleMapController> _controller = Completer();
  final AuthController Auth_controller = Get.put(AuthController());
  final Set<Marker> _markers = new Set();
  Future<Position> _getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {}).onError((error,
        stackTrace) {
      print(error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  static const CameraPosition _kGooglePlex =  CameraPosition(
    target: LatLng(33.6844, 73.0479),
    zoom: 10,
  );
  @override
  void initState() {
    // TODO: implement initState
    Auth_controller.activation();
    super.initState();

  }
  void dispose(){
   _markers.clear();
    super.dispose();

  }



  @override
  Widget build(BuildContext context) {
    print(_markers.length);
    return Scaffold(
      key: scaffoldKey,
        body:
        SafeArea(
          child: Stack(
              children: [
                GoogleMap(
                  onTap: (position) {
                    _customInfoWindowController.hideInfoWindow!();
                  },
                  onCameraMove: (position) {
                    _customInfoWindowController.onCameraMove!();
                  },
                  onMapCreated: (GoogleMapController controller) async {
                    _customInfoWindowController.googleMapController = controller;
                    _controller.complete(controller);
                  },
                  initialCameraPosition: _kGooglePlex,
                  mapType: MapType.normal,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  markers: getmarkers(),

                ),

            // button update
                CustomInfoWindow(
                  controller: _customInfoWindowController,
                  height: 200,
                  width: 300,
                  offset: 35,
                ),
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
                        BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
                          ImageConfiguration(), "images/location_user.png",
                        );
                        // ajouter marks en maps
                        _markers.add(
                            Marker( icon: markerbitmap,

                              markerId: const MarkerId('SomeeId'),
                              position: LatLng(value.latitude ,value.longitude),
                              onTap: () {
                                _customInfoWindowController.addInfoWindow!(
                                  Column(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blueAccent,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.account_circle,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                                const SizedBox(
                                                  width: 8.0,
                                                ),
                                                Text(
                                                  address,
                                                  style:
                                                  Theme.of(context).textTheme.headline6?.copyWith(
                                                    color: Colors.white,),)],),),),
                                      )],
                                  ),
                                  LatLng(value.latitude ,value.longitude),
                                );},));
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
                          address = add.locality.toString()+add.country.toString();

                        });
                      });
                    },
                    // Add your onPressed code here!
                    label: const Text('Current Location'),
                    icon: const Icon(Icons.location_on_rounded),
                    backgroundColor: Colors.blueAccent,

                  ),
                ),
                     ]),
        )
    );
  }
  Set<Marker> getmarkers() {
      for (var i in controller_Adresse.userData) {
        setState(() {
          _markers.add(
              Marker(
                  markerId: MarkerId("${i.name}"),
                  position: LatLng(i.latitude, i.longitude),
                  //icon: markerbitmap,
                  onTap: () {
                    _customInfoWindowController.addInfoWindow!(
                      Container(
                        width: 300,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 300,
                              height: 80,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        'https://img.freepik.com/photos-gratuite/voiture-taxi-lumieres-bokeh_181624-26108.jpg?w=740&t=st=1680129497~exp=1680130097~hmac=ac477f7b90d7b86a8e3b0e8f8a26969f809fdbc2f5f8435e084e5aded5466f39'),
                                    fit: BoxFit.fitWidth,
                                    filterQuality: FilterQuality.high),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                color: Colors.red,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      '${i.name}',
                                      maxLines: 1,
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(onPressed: () {
                                    Get.to(CompleteForm());
                                  }, child: Text("reservation")
                                    ,
                                    // widget.data!.date!,

                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: Center(child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      onPressed: () {}, icon: Icon(Icons.phone)),
                                  IconButton(
                                      onPressed: () {}, icon: Icon(Icons.message))
                                ],
                              )
                              ),

                            )
                          ],
                        ),
                      ),
                      LatLng(i.latitude, i.longitude),
                    );
                  }
              ));
        });
      }

      //add more markers here


    return _markers;
  }

}