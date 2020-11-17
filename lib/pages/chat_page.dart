import 'package:F_202030_Firebase/backend/firebase_real_time.dart';
import 'package:F_202030_Firebase/models/message.dart';
import 'package:F_202030_Firebase/providers/authProvider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> messages = List();
  ScrollController _scrollController;
  bool _needsScroll = false;

  static const List<String> _possibleMessages = [
    "Hi!",
    "Hello.",
    "Bye forever!",
    "I'd really like to talk to you.",
    "Have you heard the news?",
    "I see you're using our website. Can I annoy you with a chat bubble?",
    "I miss you.",
    "I never want to hear from you again.",
    "You up?",
    ":-)",
    "ok",
  ];
  final Random _random = Random();

  void _sendMsg() {
    sendChatMsg(_possibleMessages[_random.nextInt(_possibleMessages.length)]);
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
      _needsScroll = true;
    });
  }

  _onEntryChanged(Event event) {
    print("Somethig changed");
  }

  _scrollToEnd() async {
    if (_needsScroll) {
      _needsScroll = false;
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    }
  }

  Widget _list() {
    String myUID = Provider.of<AuthProvider>(context, listen: false).getUID();
    return ListView.builder(
      controller: _scrollController,
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
        color: myUID == element.user ? Colors.yellow[200] : Colors.grey[300],
        child: ListTile(
          contentPadding: EdgeInsets.all(10.0),
          title: _itemTitle(element, myUID == element.user),
        ));
  }

  Widget _itemTitle(Message item, bool own) {
    return Text(item.text,
        textAlign: own ? TextAlign.right : TextAlign.left,
        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold));
  }

  Widget _body() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(2.0),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [Expanded(flex: 4, child: _list()), _textInput()],
        ),
      ),
    );
  }

  Widget _textInput() {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.only(left: 5.0, top: 5.0),
              child: TextField(
                  decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Some text here',
              )),
            )),
        FlatButton(
          onPressed: _sendMsg,
          child: Text("Send"),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
    Widget s = Scaffold(
      body: _body(),
    );
    return s;
  }
}
