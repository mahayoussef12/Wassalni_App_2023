

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wassalni/Model/booking.dart';
import 'package:wassalni/Session_Driver/ControllerReservation.dart';
import 'package:wassalni/Session_Driver/Session_Driver.dart';



class ReservationlistScreenDriver extends StatelessWidget {
  final Controller_reservation controller_reservation = Get.put(Controller_reservation());
  List<booking> _list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Reservation "),backgroundColor: Colors.yellowAccent,),
        drawer: session(),
        body:
        Center(child:
          StreamBuilder(
                stream: Controller_reservation.getReservation(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                  //if data is loading
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Text("nn");
                  //if some or all data is loaded then show it
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      _list = data?.map((e) => booking.fromJson(e.data()))
                          .toList() ?? [];
                      if (_list.isNotEmpty) {
                        return ListView.builder(
                            itemCount: _list.length,
                            itemBuilder: (BuildContext context, int index) {
                              Controller_reservation.index(_list[index].id);
                              return Dismissible(
                                  key: UniqueKey(),
                                  onDismissed: (direction) {
                                    Controller_reservation.deleteDestination(
                                        Controller_reservation.index
                                            .toString());
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Le reservation a été supprimé'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },

                               child:Card(
                                 child: Column(
                                     mainAxisSize: MainAxisSize.min,
                                     children: <Widget>[
                                 ListTile(
                                    leading: Icon(Icons.taxi_alert_sharp),
                                    title: Text(_list[index].destination),
                                    subtitle: Text(_list[index].acceptation==true?"Accepter":"En attend", style: TextStyle(
                                        color: _list[index].acceptation == true
                                            ? Colors.green
                                            : Colors.red),),
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        TextButton(
                                          child:  Text(_list[index].acceptation==true?"Refuser":"Accepter", style: TextStyle(
                                              color: _list[index].acceptation == true
                                                  ?  Colors.red
                                                  : Colors.green),),
                                          onPressed: () {controller_reservation.accepter(_list[index].id);},
                                        ),
                                        const SizedBox(width: 8),
                                        const SizedBox(width: 8),
                               ])])));
                            });
                      }
                      else {

                        return Center(child: Column(
                          children: [
                            const SizedBox(height: 300,),
                            Image.asset('images/noresult.png',height:100),
                            const SizedBox(height: 20,),
                            Text("No result .. 👋")
                          ],
                        ),);
                      }
                  }
                })));
  }}