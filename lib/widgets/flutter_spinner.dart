import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// A spinner that uses the Flutter logo.
class FlutterSpinner extends StatelessWidget {
  const FlutterSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return const Opacity(
      opacity: 0.25,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: FlutterLogo(
              size: 75,
            ),
          ),
          SpinKitRing(
            color: Colors.blue,
            size: 95,
            lineWidth: 2,
          ),
        ],
      ),
    );
  }
}
