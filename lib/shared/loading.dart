import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: SpinKitChasingDots(color: Colors.blueGrey, size: 150.0),
    ));
  }
}
