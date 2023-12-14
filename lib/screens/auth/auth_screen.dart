import 'package:coinxfiat/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routes/route_index.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen(
      {super.key, required this.returnExpected, required this.login});
  final bool returnExpected;
  final bool login;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.login ? 'Login' : 'Register'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            appStore.setLoggedIn(true);
            context.goNamed(Routes.dashboard);
          },
          child: Text(widget.login ? 'Login' : 'Register'),
        ),
      ),
    );
  }
}
