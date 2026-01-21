import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/api_service.dart';
import 'reservation_screen.dart';

class AbonnementsScreen extends StatefulWidget {
  final Map discipline;

  AbonnementsScreen({required this.discipline});

  @override
  State<AbonnementsScreen> createState() => _AbonnementsScreenState();
}

class _AbonnementsScreenState extends State<AbonnementsScreen> {
  List abonnements = [];
  bool loading = true;

  Future load() async {
    final res = await ApiService.get(
      '/abonnements/discipline/${widget.discipline['id']}',
    );

    if (res.statusCode == 200) {
      abonnements = jsonDecode(res.body);
    }
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.discipline['nom'])),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: abonnements.length,
              itemBuilder: (_, i) {
                final a = abonnements[i];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(
                      a['nom'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("${a['prix']} DA / mois"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ReservationScreen(abonnement: a),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
