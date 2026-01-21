import 'package:flutter/material.dart';
import 'auth/auth_service.dart';
import 'auth/login_screen.dart';
import 'admin/dashboard_screen.dart';
import 'client/client_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 🔹 مهم جدًا
  await AuthService.loadToken();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final prefs = snapshot.data as SharedPreferences;
          final role = prefs.getString('role');

          if (role == 'admin') return DashboardScreen();
          if (role == 'client') return ClientHomeScreen();

          return LoginScreen();
        },
      ),
    );
  }
}
