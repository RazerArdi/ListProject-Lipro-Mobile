import 'package:flutter/material.dart';

class AdminSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Settings'),
      ),
      body: Center(
        child: Text(
          'This is the Admin Settings page.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}