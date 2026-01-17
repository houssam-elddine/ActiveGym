import 'package:flutter/material.dart';
import 'auth_service.dart';
import '../admin/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connexion Administrateur")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: password,
              decoration: InputDecoration(labelText: "Mot de passe"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            loading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    child: Text("Se connecter"),
                    onPressed: () async {
                      setState(() => loading = true);
                      final success = await AuthService.login(
                        email.text,
                        password.text,
                      );
                      setState(() => loading = false);

                      if (success) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => DashboardScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Accès refusé")),
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
