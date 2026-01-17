import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/api_constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SubscriptionsScreen extends StatefulWidget {
  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  bool isLoading = true;
  List subscriptions = [];

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
    } else {
      Fluttertoast.showToast(msg: "Failed to fetch subscriptions");
      setState(() => isLoading = false);
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
      appBar: AppBar(
        title: Text("Subscriptions"),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: subscriptions.length,
              itemBuilder: (context, index) {
                final sub = subscriptions[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  child: ListTile(
                    title: Text(sub['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Text(
                        "${sub['duration_days']} days - \$${sub['price']}"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                );
              },
            ),
    );
  }
}
