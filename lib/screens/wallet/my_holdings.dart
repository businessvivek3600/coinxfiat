import 'package:flutter/material.dart';

class MyHoldingsPage extends StatefulWidget {
  const MyHoldingsPage({super.key});

  @override
  State<MyHoldingsPage> createState() => _MyHoldingsPageState();
}

class _MyHoldingsPageState extends State<MyHoldingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Holdings'),
      ),
      body: Center(
        child: Text('My Holdings'),
      ),
    );
  }
}
