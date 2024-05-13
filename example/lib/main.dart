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

class DiagramPage extends StatefulWidget {
  const DiagramPage({super.key});

  @override
  State<StatefulWidget> createState() => DiagramPageState();
}

class DiagramPageState extends State<DiagramPage> {
  final DiagramController _controller = DiagramController();
  final DebugNotifier _debugNotifier = DebugNotifier();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      DebugWidget(controller: _controller, debugNotifier: _debugNotifier),
      Expanded(
          child:
              Diagram(controller: _controller, debugNotifier: _debugNotifier))
    ]));
  }
}

class DebugWidget extends StatelessWidget {
  const DebugWidget(
      {super.key, required this.controller, required this.debugNotifier});

  final DiagramController controller;
  final DebugNotifier debugNotifier;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: debugNotifier,
        builder: (context, child) =>
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('nodes: ${controller.count}'),
              Text('visible nodes: ${debugNotifier.visibleNodes}')
            ]));
  }
}
