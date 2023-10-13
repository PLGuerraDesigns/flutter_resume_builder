import 'package:flutter/material.dart';
import 'common/strings.dart';
import 'screens/split_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: const SplitScreen(),
    );
  }
}
