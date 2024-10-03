import 'package:flutter/material.dart';

void main() => runApp(stateless());

class stateless extends StatelessWidget {
  stateless({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Scaffold(
        appBar: AppBar(
          title: Text("Stateful Widgets Flutter - 3.1"),
          centerTitle: true,
        ),
        body:stateful(),
      ),
    );
  }
}

class stateful  extends StatefulWidget {
  const stateful ({super.key});

  @override
  State<stateful> createState() => _stateful();
}

class _stateful extends State<stateful> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
