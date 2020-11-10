import 'package:F_202030_Firebase/backend/firebase_real_time.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  void _sendMsg() {
    sendChatMsg("My Text");
  }

  @override
  void initState() {
    super.initState();
    print("initState");
    final FirebaseDatabase database = FirebaseDatabase.instance;
    databaseReference
        .child("fluttermessages")
        .onChildChanged
        .listen(_onEntryChanged);
    databaseReference
        .child("fluttermessages")
        .onChildAdded
        .listen(_onEntryAdded);
  }

  _onEntryAdded(Event event) {
    print("Somethig was added");
  }

  _onEntryChanged(Event event) {
    print("Somethig changed");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text('Send'),
        onPressed: () {
          _sendMsg();
        },
      ),
    );
  }
}
