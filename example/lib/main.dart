import 'package:flutter/material.dart';
import 'package:receive_sharing/receive_sharing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _received;

  @override
  void initState() {
    super.initState();
    ReceiveSharing.receive()
        .listen((event) => setState(() => _received = event["text"]));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              if (_received != null) Text('Received: $_received\n'),
            ],
          ),
        ),
      ),
    );
  }
}
