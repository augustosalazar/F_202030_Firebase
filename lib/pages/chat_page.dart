import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  void _sendMsg() {}

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
