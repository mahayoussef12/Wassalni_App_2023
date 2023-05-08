import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Session_User.dart';
import 'comment_service.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({Key? key}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final _commentController = TextEditingController();
  double _rating = 0.0;
  final Controller_Feedback controller_feedback =
      Get.put(Controller_Feedback());
  List<Comment> _list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Commentaires'),
        ),
        drawer: Drawer_User(),

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            Text(
              'Notez notre service',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _rating = 1.0;
                    });
                  },
                  icon: Icon(Icons.star,
                      color: _rating >= 1.0 ? Colors.amber : Colors.grey),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _rating = 2.0;
                    });
                  },
                  icon: Icon(Icons.star,
                      color: _rating >= 2.0 ? Colors.amber : Colors.grey),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _rating = 3.0;
                    });
                  },
                  icon: Icon(Icons.star,
                      color: _rating >= 3.0 ? Colors.amber : Colors.grey),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _rating = 4.0;
                    });
                  },
                  icon: Icon(Icons.star,
                      color: _rating >= 4.0 ? Colors.amber : Colors.grey),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _rating = 5.0;
                    });
                  },
                  icon: Icon(Icons.star,
                      color: _rating >= 5.0 ? Colors.amber : Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Ajouter un commentaire',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_commentController.text.isNotEmpty) {
                  DocumentReference docRef = await FirebaseFirestore.instance
                      .collection('comments')
                      .add({
                    'text': _commentController.text.trim(),
                    'rating': _rating,
                    'idUser': FirebaseAuth.instance.currentUser!.uid
                  });
                  String taskId = docRef.id;
                  await FirebaseFirestore.instance
                      .collection('comments')
                      .doc(taskId)
                      .update(
                    {'id': taskId},
                  );
                  clearAll();
                }
              },
              child: const Text('Ajouter'),
            ),
            const SizedBox(width: 2),
            Expanded(
                child: StreamBuilder(
                    stream: Controller_Feedback.getComments(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();
                        //if some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list = data
                                  ?.map((e) => Comment.fromJson(e.data()))
                                  .toList() ??
                              [];
                          if (_list.isNotEmpty) {
                            return ListView.builder(
                                itemCount: _list.length,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  controller_feedback.index(_list[index].id);
                                  return Dismissible(
                                      key: UniqueKey(),
                                      onDismissed: (direction) {
                                        controller_feedback.deleteComment(
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
                                      child: Card(
                                        child: ListTile(
                                          title: Text(_list[index].text),
                                          subtitle: Row(
                                            children: [
                                              const Icon(Icons.star,
                                                  color: Colors.amber),
                                              Text(_list[index]
                                                  .rating
                                                  .toString()),
                                            ],
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () async {
                                              final editedComment =
                                                  await showDialog<Comment>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  controller_feedback.index(_list[index].id);
                                                  String commentText =
                                                      _list[index].text;
                                                  double rating =
                                                      _list[index].rating;
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Modifier le commentaire'),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        TextField(
                                                          controller: TextEditingController(
                                                                  text:
                                                                      commentText),
                                                          onChanged: (value) {
                                                            commentText = value;
                                                          },
                                                          maxLines: null,
                                                          decoration:
                                                              const InputDecoration(
                                                            hintText:
                                                                'Ajouter un commentaire',
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 16),
                                                        const Text(
                                                          'Notez notre service',
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                        SizedBox(height: 8),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            IconButton(
                                                              onPressed: () {

                                                              },
                                                              icon: Icon(Icons.star,
                                                                  color: rating >= 1.0 ? Colors.amber : Colors.grey),
                                                            ),
                                                            IconButton(
                                                              onPressed: () {

                                                              },
                                                              icon: Icon(Icons.star,
                                                                  color: rating >= 2.0 ? Colors.amber : Colors.grey),
                                                            ),
                                                            IconButton(
                                                              onPressed: () {

                                                              },
                                                              icon: Icon(Icons.star,
                                                                  color: rating >= 3.0 ? Colors.amber : Colors.grey),
                                                            ),
                                                            IconButton(
                                                              onPressed: () {

                                                              },
                                                              icon: Icon(Icons.star,
                                                                  color: rating >= 4.0 ? Colors.amber : Colors.grey),
                                                            ),
                                                            IconButton(
                                                              onPressed: () {

                                                              },
                                                              icon: Icon(Icons.star,
                                                                  color: rating >= 5.0 ? Colors.amber : Colors.grey),
                                                            ),
                                                          ],
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
                                                          final edited = Comment(
                                                              text: commentText,
                                                              rating: rating,
                                                              idUser: FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid,
                                                              id: controller_feedback
                                                                  .index
                                                                  .toString());
                                                          controller_feedback
                                                              .updateComment(
                                                                  controller_feedback
                                                                      .index
                                                                      .toString(),
                                                                  edited);
                                                          Navigator.of(context)
                                                              .pop(edited);
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
                                        ),
                                      ));
                                });
                          } else {
                            return const Center(
                              child: Text("Found Comments"),
                            );
                          }
                      }
                    }))
          ]),
        ));
  }

  clearAll() {
    setState(() {
      _commentController.clear();
      _rating = 0.0;
    });
  }
}
