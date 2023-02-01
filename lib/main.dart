import 'package:flutter/material.dart';
import 'package:flutter_resume_builder/constants/strings.dart';
import 'package:flutter_resume_builder/pages/split_view.dart';

void main() {
  runApp(const FlutterResumeBuilder());
}

class FlutterResumeBuilder extends StatelessWidget {
  const FlutterResumeBuilder({Key? key}) : super(key: key);

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.flutterResumeBuilder,
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      home: SplitView(),
    );
  }
}
