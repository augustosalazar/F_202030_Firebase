import 'package:F_202030_Firebase/backend/firebase_real_time.dart';
import 'package:F_202030_Firebase/models/message.dart';
import 'package:F_202030_Firebase/providers/authProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> messages = List();
  String _uid;
  void _sendMsg() {
    sendChatMsg("My Text");
  }

  @override
  void initState() {
    super.initState();
    print("initState");
    //_uid = Provider.of<AuthProvider>(context, listen: false).getUID();
    //print("initState for user " + _uid);
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
    setState(() {
      messages.add(Message.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    print("Somethig changed");
  }

  Widget _list() {
    String myUID = Provider.of<AuthProvider>(context, listen: false).getUID();
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, posicion) {
        var element = messages[posicion];
        return _item(element, posicion, myUID);
      },
    );
  }

  Widget _item(Message element, int posicion, String myUID) {
    return Card(
        margin: EdgeInsets.all(4.0),
        color: myUID == element.user ? Colors.yellow[200] : Colors.green[200],
        child: ListTile(
          contentPadding: EdgeInsets.all(10.0),
          title: _itemTitle(element),
        ));
  }

  Widget _itemTitle(Message item) {
    return Text(item.text,
        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _list(),
      floatingActionButton: new FloatingActionButton(
          onPressed: _sendMsg, tooltip: 'Add task', child: new Icon(Icons.add)),
    );
  }
}
