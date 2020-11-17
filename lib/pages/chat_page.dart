import 'package:F_202030_Firebase/backend/firebase_real_time.dart';
import 'package:F_202030_Firebase/models/message.dart';
import 'package:F_202030_Firebase/providers/authProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> messages = List();
  ScrollController _scrollController;
  String _uid;
  void _sendMsg() {
    sendChatMsg("My Text " + messages.length.toString());
  }

  _scrollListener() {
    print("_scrollListener");
  }

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    _scrollController.addListener(_scrollListener);
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
    setState(() {
      messages.add(Message.fromSnapshot(event.snapshot));
    });
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  _onEntryChanged(Event event) {
    print("Somethig changed");
  }

  Widget _list() {
    String myUID = Provider.of<AuthProvider>(context, listen: false).getUID();
    Widget l = ListView.builder(
      controller: _scrollController,
      itemCount: messages.length,
      itemBuilder: (context, posicion) {
        var element = messages[posicion];
        return _item(element, posicion, myUID);
      },
    );
    return l;
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
    print("Building!!!");
    Widget s = Scaffold(
      body: _list(),
      floatingActionButton: new FloatingActionButton(
          onPressed: _sendMsg, tooltip: 'Add task', child: new Icon(Icons.add)),
    );
    return s;
  }
}
