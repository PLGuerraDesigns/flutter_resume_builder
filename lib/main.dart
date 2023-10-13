import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    return MaterialApp.router(
      title: Strings.flutterResumeBuilder,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      routerConfig: GoRouter(
        routes: <RouteBase>[
          GoRoute(
            path: '/',
            builder: (BuildContext context, GoRouterState state) {
              return const SplitScreen();
            },
          ),
        ],
      ),
    );
  }
}
