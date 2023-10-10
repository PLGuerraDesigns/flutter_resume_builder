import 'package:flutter/material.dart';
import 'constants/strings.dart';
import 'pages/split_view.dart';

void main() {
  runApp(const FlutterResumeBuilder());
}

class FlutterResumeBuilder extends StatelessWidget {
  const FlutterResumeBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.flutterResumeBuilder,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const SplitView(),
    );
  }
}
