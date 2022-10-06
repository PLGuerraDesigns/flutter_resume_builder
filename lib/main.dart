import 'package:flutter/material.dart';
import 'package:flutter_resume_builder/pages/resume_builder_split_view.dart';

void main() {
  runApp(const FlutterResumeBuilder());
}

class FlutterResumeBuilder extends StatelessWidget {
  const FlutterResumeBuilder({Key? key}) : super(key: key);

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Resume Builder',
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      home: const ResumeBuilderSplitView(),
    );
  }
}
