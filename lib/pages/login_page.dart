import 'package:F_202030_Firebase/backend/firebase_auth.dart';
import 'package:F_202030_Firebase/pages/signup_page.dart';
import 'package:F_202030_Firebase/providers/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Log In"),
        ),
        body: Center(
          child: Column(
            children: [
              Consumer<AuthProvider>(builder: (context, model, child) {
                return FlatButton(
                  onPressed: () async {
                    signOutFirebase();
                  },
                  child: Text('Logout'),
                );
              }),
              Consumer<AuthProvider>(builder: (context, model, child) {
                return FlatButton(
                  onPressed: () {
                    // setLoading(true);
                    _login(context, "a@a.com", "1234567", model);
                  },
                  child: Text('Login a@a.com'),
                );
              }),
              Consumer<AuthProvider>(builder: (context, model, child) {
                return FlatButton(
                  onPressed: () {
                    // setLoading(true);
                    _login(context, "b@b.com", "1234567", model);
                  },
                  child: Text('Login b@b.com'),
                );
              }),
              Consumer<AuthProvider>(builder: (context, model, child) {
                return FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SignInView()));
                  },
                  child: Text('Sign Up'),
                );
              })
            ],
          ),
        ));

    ;
  }

  _login(
      BuildContext context, String email, String password, AuthProvider model) {
    signInWithFirebase(email, password).then((user) {
      print(user);
      _buildDialog(context, "Login", "Login OK ");
      //model.setLogged();
      model.setLoggedIn(user);
    }).catchError((error) {
      _buildDialog(context, "Login", error.toString());
    });
  }

  _signUp(BuildContext context, String email, String password, String name,
      AuthProvider model) {
    signUpWithFirebase(email, password, name).then((user) {
      print(user);
      _buildDialog(context, "Login", "Login OK");
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
