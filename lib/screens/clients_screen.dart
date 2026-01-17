import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/api_constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'add_client_screen.dart'; // شاشة لإضافة عميل جديد

class ClientsScreen extends StatefulWidget {
  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  bool isLoading = true;
  List clients = [];

  void fetchClients() async {
    setState(() => isLoading = true);
    final response = await http.get(
      Uri.parse(ApiConstants.clients),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        clients = data['data'] ?? [];
        isLoading = false;
      });
    } else {
      Fluttertoast.showToast(msg: "Failed to fetch clients");
      setState(() => isLoading = false);
    }
  }

  void deleteClient(int clientId) async {
    final response = await http.delete(
      Uri.parse("${ApiConstants.clients}/$clientId"),
      headers: {'Accept': 'application/json'},
    );

    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: data['message']);
      fetchClients(); // تحديث القائمة بعد الحذف
    } else {
      Fluttertoast.showToast(msg: data['message']);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchClients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clients"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              // فتح شاشة إضافة عميل
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddClientScreen()),
              );
              if (result == true) fetchClients(); // تحديث القائمة بعد الإضافة
            },
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : clients.isEmpty
              ? Center(child: Text("No clients found"))
              : ListView.builder(
                  itemCount: clients.length,
                  itemBuilder: (context, index) {
                    final client = clients[index]['user'];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 4,
                      child: ListTile(
                        leading: Icon(Icons.person, color: Colors.deepPurple),
                        title: Text(client['name']),
                        subtitle: Text(client['email']),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // تأكيد قبل الحذف
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text("Delete Client"),
                                content: Text(
                                    "Are you sure you want to delete ${client['name']}?"),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Cancel")),
                                  TextButton(
                                      onPressed: () {
                                        deleteClient(clients[index]['id']);
                                        Navigator.pop(context);
                                      },
                                      child: Text("Delete", style: TextStyle(color: Colors.red))),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
