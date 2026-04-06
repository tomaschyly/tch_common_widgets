import 'package:flutter/material.dart';

/// Run the example application.
void main() {
  runApp(const MyApp());
}

/// Root widget for the example app.
class MyApp extends StatelessWidget {
  /// Initialize [MyApp].
  const MyApp({super.key});

  /// Build the example app shell.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
      ),
    );
  }
}
