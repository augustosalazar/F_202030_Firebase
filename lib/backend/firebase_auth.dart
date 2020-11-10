import 'dart:async';
import 'package:F_202030_Firebase/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final db = Firestore.instance;
User currentSignedInUser;

get _getFirebaseUID async {
  final FirebaseUser user = await _auth.currentUser();
  final uid = user.uid;
  return uid;
}

Future<String> signInWithFirebase(email, password) async {
  var fbuser;
  try {
    fbuser = (await _auth.signInWithEmailAndPassword(
        email: email, password: password));
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    print("OK " + uid);
    return Future.value(uid);
  } catch (error) {
    print('ERRORS');
    print(error.message.toString());
    print(error.code.toString());
    return Future.error(error.message.toString());
  }
}

Future<String> signUpWithFirebase(email, password, name) async {
  var fbUser;
  try {
    fbUser = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  } catch (error) {
    print('ERRORS');
    print(error.message.toString());
    print(error.code.toString());
    throw Exception(error.message.toString());
  }
  final FirebaseUser user = await _auth.currentUser();
  final uid = user.uid;
  print('signUpWithFirebase Ok with uid ' + uid);

  currentSignedInUser = User(email: email, name: name, uid: uid);

  await db
      .collection('users')
      .document(uid)
      .setData(currentSignedInUser.toMap());

  return Future.value("OK");
}

Future<bool> signOutFirebase() async {
  currentSignedInUser = null;
  await _auth.signOut();
  return true;
}
