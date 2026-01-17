import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/api_constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AssignSubscriptionScreen extends StatefulWidget {
  @override
  State<AssignSubscriptionScreen> createState() => _AssignSubscriptionScreenState();
}

class _AssignSubscriptionScreenState extends State<AssignSubscriptionScreen> {
  TextEditingController clientIdController = TextEditingController();
  TextEditingController subscriptionIdController = TextEditingController();
  TextEditingController startDateController = TextEditingController();

  void assignSubscription() async {
    final response = await http.post(
      Uri.parse(ApiConstants.assignSubscription),
      headers: {'Accept': 'application/json'},
      body: {
        'client_id': clientIdController.text,
        'subscription_id': subscriptionIdController.text,
        'start_date': startDateController.text,
      },
    );

    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: data['message']);
      clientIdController.clear();
      subscriptionIdController.clear();
      startDateController.clear();
    } else {
      Fluttertoast.showToast(msg: data['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Assign Subscription"), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: clientIdController, decoration: InputDecoration(labelText: "Client ID")),
            TextField(controller: subscriptionIdController, decoration: InputDecoration(labelText: "Subscription ID")),
            TextField(controller: startDateController, decoration: InputDecoration(labelText: "Start Date (YYYY-MM-DD)")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: assignSubscription,
              child: Text("Assign"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            ),
          ],
        ),
      ),
    );
  }
}
