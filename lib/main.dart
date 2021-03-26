import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cents',
      home: Scaffold(
          appBar: AppBar(title: Text("Cents")),
          body: Center(child: Text("Hello world!"))),
    );
  }
}
