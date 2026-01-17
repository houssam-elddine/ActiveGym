import 'package:flutter/material.dart';
import 'auth/login_screen.dart';

void main() {
  runApp(GymAdminApp());
}

class GymAdminApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ActiveGym',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
    );
  }
}
