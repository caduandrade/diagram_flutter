import 'package:diagram/diagram.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DiagramApp());
}

class DiagramApp extends StatelessWidget {
  const DiagramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diagram',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const DiagramPage(),
    );
  }
}

class DiagramPage extends StatelessWidget {
  const DiagramPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Diagram());
  }
}
