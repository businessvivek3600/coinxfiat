import 'package:flutter/material.dart';

///TODO: remaining pages
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
        title: const Text('My Holdings'),
      ),
      body: const Center(
        child: Text('My Holdings'),
      ),
    );
  }
}
