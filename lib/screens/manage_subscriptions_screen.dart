import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/api_constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ManageSubscriptionsScreen extends StatefulWidget {
  @override
  State<ManageSubscriptionsScreen> createState() => _ManageSubscriptionsScreenState();
}

class _ManageSubscriptionsScreenState extends State<ManageSubscriptionsScreen> {
  List subscriptions = [];
  bool isLoading = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  void fetchSubscriptions() async {
    final response = await http.get(
      Uri.parse(ApiConstants.subscriptions),
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        subscriptions = data['data'] ?? [];
        isLoading = false;
      });
    }
  }

  void addSubscription() async {
    final response = await http.post(
      Uri.parse(ApiConstants.subscriptions),
      headers: {'Accept': 'application/json'},
      body: {
        'name': nameController.text,
        'duration_days': durationController.text,
        'price': priceController.text,
      },
    );
    final data = json.decode(response.body);
    if (response.statusCode == 201) {
      Fluttertoast.showToast(msg: data['message']);
      fetchSubscriptions();
      nameController.clear();
      durationController.clear();
      priceController.clear();
    } else {
      Fluttertoast.showToast(msg: data['message']);
    }
  }

  void deleteSubscription(int id) async {
    final response = await http.delete(
      Uri.parse("${ApiConstants.subscriptions}/$id"),
      headers: {'Accept': 'application/json'},
    );
    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: data['message']);
      fetchSubscriptions();
    } else {
      Fluttertoast.showToast(msg: data['message']);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Subscriptions"), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
            TextField(controller: durationController, decoration: InputDecoration(labelText: "Duration (days)")),
            TextField(controller: priceController, decoration: InputDecoration(labelText: "Price")),
            ElevatedButton(onPressed: addSubscription, child: Text("Add Subscription"), style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple)),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: subscriptions.length,
                itemBuilder: (context, index) {
                  final sub = subscriptions[index];
                  return Card(
                    child: ListTile(
                      title: Text(sub['name']),
                      subtitle: Text("${sub['duration_days']} days - \$${sub['price']}"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteSubscription(sub['id']),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
