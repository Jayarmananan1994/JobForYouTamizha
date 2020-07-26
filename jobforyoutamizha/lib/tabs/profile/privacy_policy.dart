import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  static const String PATH = '/privacy-policy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Privacy policy')),
      body: Container(
          child: Center(child: Text('Content for privacy policy comes here.'))),
    );
  }
}
