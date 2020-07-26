import 'package:flutter/material.dart';

class MemberShip extends StatelessWidget {
  static const String PATH = '/membership';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Become a member')),
      body: Container(child: Center(child: Text('Member plan comes here'))),
    );
  }
}
