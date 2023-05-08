import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wassalni/Model/booking.dart';

import 'comment_service.dart';

class ReservationlistScreen extends StatelessWidget {
  final Controller_Feedback controller_feedback = Get.put(Controller_Feedback());
  List<booking> _list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("User"),),
        body:
        Center(child:
        StreamBuilder(
                stream: Controller_Feedback.getReservation(),
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
                              controller_feedback.index(_list[index].id);
                              return Dismissible(
                                  key: UniqueKey(),
                                  onDismissed: (direction) {
                                    controller_feedback.deleteDestination(
                                        controller_feedback.index
                                            .toString());
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Le commentaire a été supprimé'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },

                               child:Card(
                                  child: ListTile(
                                    leading: Icon(Icons.taxi_alert_sharp),
                                    title: Text(_list[index].destination),
                                    subtitle: Text(_list[index].acceptation==true?"Accepter":"En attend", style: TextStyle(
                                        color: _list[index].acceptation == true
                                            ? Colors.green
                                            : Colors.red),),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () async {
                                        final editedComment =
                                        await showDialog<Comment>(
                                          context: context,
                                          builder:
                                              (BuildContext context) {
                                            controller_feedback.index(_list[index].id);
                                            String destination =
                                                _list[index].destination;

                                            return AlertDialog(
                                              title: const Text(
                                                  'Modifier Destination '),
                                              content: Column(
                                                mainAxisSize:
                                                MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    controller: TextEditingController(
                                                        text:
                                                        destination),
                                                    onChanged: (value) {
                                                      destination = value;
                                                    },
                                                    maxLines: null,
                                                    decoration:
                                                    const InputDecoration(
                                                      hintText:
                                                      'Ajouter une destination ',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop();
                                                  },
                                                  child: Text('Annuler'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    controller_feedback
                                                        .updateDestination(
                                                        controller_feedback
                                                            .index
                                                            .toString(),
                                                       destination);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child:
                                                  Text('Enregistrer'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        if (editedComment != null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Le commentaire a été modifié'),
                                              duration:
                                              Duration(seconds: 2),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  )));
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