import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Model/User.dart';
import '../../main.dart';
import '../api/apis.dart';
import '../widgets/chat_user_card.dart';


//home screen -- where all available contacts are shown
class OnlineScreen extends StatefulWidget {
  const OnlineScreen({super.key});

  @override
  State<OnlineScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<OnlineScreen> {
  // for storing all users
  List<UserModel> _list = [];

  // for storing searched items
  final List<UserModel> _searchList = [];
  // for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
    //exit full-screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.white));

    //for updating user active status according to lifecycle events
    //resume -- active or online
    //pause  -- inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return GestureDetector(
      //for hiding keyboard when a tap is detected on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //if search is on & back button is pressed then close search
        //or else simple close current screen on back button click
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          //app bar
          appBar: AppBar(
            leading: const Icon(CupertinoIcons.conversation_bubble),
            title: _isSearching
                ? TextField(
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: 'Name, Email, ...'),
              autofocus: true,
              style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
              //when search text changes then updated search list
              onChanged: (val) {
                //search logic
                _searchList.clear();

                for (var i in _list) {
                  if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                      i.email.toLowerCase().contains(val.toLowerCase())) {
                    _searchList.add(i);
                    setState(() {
                      _searchList;
                    });
                  }
                }
              },
            )
                : const Text('We Chat'),
            actions: [
              //search user button
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(_isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search)),

              //more features button

          ]),

          //body
          body:StreamBuilder(
                  stream: APIs.getAllDriver_isOnline(),

                  //get only those user, who's ids are provided
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                    //if data is loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:

                      //if some or all data is loaded then show it
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        _list = data?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];

                        if (_list.isNotEmpty) {
                          return ListView.builder(
                              itemCount: _isSearching
                                  ? _searchList.length
                                  : _list.length,
                              padding: EdgeInsets.only(top: mq.height * .01),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                if (_list[index].activation==true) {
                                  return ChatUserCardOnline(user: _isSearching
                                      ? _searchList[index]
                                      : _list[index]);
                                }
                                else{
                                  return const Center(
                                    child: Text('No Driver Found!',
                                        style: TextStyle(fontSize: 20)),
                                  );
                                }
                              });
                        } else{
                          return const Center(
                            child: Text('No Driver Found!',
                                style: TextStyle(fontSize: 20)),
                          );
                        }
                    }
                  },



          ),
        ),
      ),
    );
  }
}
