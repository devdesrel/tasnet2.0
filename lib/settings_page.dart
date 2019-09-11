import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.cyan[200],
        body: Center(
          child: Text(
            'Settings',
            style: TextStyle(fontSize: 36.0),
          ),
        ));
  }
}
