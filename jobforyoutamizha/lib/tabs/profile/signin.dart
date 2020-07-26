import 'package:flutter/material.dart';

class Signin extends StatelessWidget {
  static const String PATH = '/signin';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign in')),
      body: Container(child: Center(child: Text('Sign in page comes here'))),
    );
  }
}
