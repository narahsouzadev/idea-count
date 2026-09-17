import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/counter_page.dart';
import 'theme/app_theme.dart';

/// Entry point of the application.
///
/// Every Flutter application starts its execution from this function.
/// It is responsible for initializing the main application widget.
void main() async {
  // Ensures initialization of Flutter bindings with the native platform
  WidgetsFlutterBinding.ensureInitialized();

  // Locks the application orientation exclusively to Portrait mode.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const IdeaCountApp());
}

/// Root widget of the application.
///
/// Its sole responsibility is to configure the application:
/// - name;
/// - global theme;
/// - initial screen.
///
/// No business rules should reside here.
class IdeaCountApp extends StatelessWidget {
  /// Default constructor.
  const IdeaCountApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Removes the "DEBUG" banner displayed during development.
      debugShowCheckedModeBanner: false,

      // Application name.
      title: 'Idea Count',

      // Global application theme.
      //
      // All visual configurations (colors, typography, and styles)
      // will be centralized in app_theme.dart.
      theme: AppTheme.lightTheme,

      // First screen displayed when the application starts.
      home: const CounterPage(),
    );
  }
}