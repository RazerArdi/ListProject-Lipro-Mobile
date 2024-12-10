import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text(
          'Welcome to the Admin Dashboard',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
