import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/api_constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddClientScreen extends StatefulWidget {
  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  bool isLoading = false;

  void addClient() async {
    setState(() => isLoading = true);

    final response = await http.post(
      Uri.parse(ApiConstants.clients),
      headers: {'Accept': 'application/json'},
      body: {
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'birth_date': birthController.text,
      },
    );

    setState(() => isLoading = false);
    final data = json.decode(response.body);

    if (response.statusCode == 201) {
      Fluttertoast.showToast(msg: data['message']);
      Navigator.pop(context, true); // رجوع مع refresh
    } else {
      Fluttertoast.showToast(msg: data['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Client"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            TextField(
              controller: birthController,
              decoration: InputDecoration(labelText: "Birth Date (YYYY-MM-DD)"),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: addClient,
                    child: Text("Add Client"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
