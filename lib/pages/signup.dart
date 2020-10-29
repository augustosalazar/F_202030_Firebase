import 'package:F_202030_Firebase/backend/firebase_auth.dart';
import 'package:F_202030_Firebase/providers/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInView extends StatefulWidget {
  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _formKey = GlobalKey<FormState>();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign Up"),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Sign Up Information",
                    style: TextStyle(fontSize: 20),
                  ),
                  TextFormField(
                    controller: this.controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: "Email address"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter email address";
                      } else if (!value.contains('@')) {
                        return "Enter valid email address";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: this.controllerPassword,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Password"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter password";
                      } else if (value.length < 6) {
                        return "Password should have at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    onPressed: () {
                      final form = _formKey.currentState;
                      form.save();
                      if (_formKey.currentState.validate()) {
                        _signUp(context, controllerEmail.text,
                            controllerPassword.text, "Augusto");
                      }
                    },
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    child: Text('Submit'),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  _signUp(BuildContext context, String email, String password, String name) {
    signUpWithFirebase(email, password, name).then((user) {
      print(user);
      _buildDialog(context, "Sign Up", "Sign Up OK").then((value) {
        _formKey.currentState.reset();
        Navigator.of(context).pop();
      });
    }).catchError((error) {
      _buildDialog(context, "Sign Up", error.toString());
    });
  }

  Future<void> _buildDialog(BuildContext context, _title, _message) {
    return showDialog(
      builder: (context) {
        return AlertDialog(
          title: Text(_title),
          content: Text(_message),
          actions: <Widget>[
            FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
      context: context,
    );
  }
}
