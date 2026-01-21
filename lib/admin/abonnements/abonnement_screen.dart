import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/api_service.dart';
import 'abonnement_form.dart';

class AbonnementScreen extends StatefulWidget {
  @override
  _AbonnementScreenState createState() => _AbonnementScreenState();
}

class _AbonnementScreenState extends State<AbonnementScreen> {
  List abonnements = [];

  load() async {
  final res = await ApiService.get('/abonnements');
    final data = jsonDecode(res.body);

  abonnements = data['abonnements']; // ✅ هنا الحل

    setState(() {});
  }

  delete(int id) async {
    await ApiService.delete('/abonnements/$id');
    load();
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestion des abonnements"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final r = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AbonnementForm()),
              );
              if (r == true) load();
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: abonnements.length,
        itemBuilder: (_, i) {
          final a = abonnements[i];
          return Card(
            child: ListTile(
              title: Text(a['nom']),
              subtitle: Text(
                "Prix: ${a['prix']} DA\nDiscipline: ${a['discipline']['nom']}",
              ),
              isThreeLine: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      final r = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AbonnementForm(abonnement: a),
                        ),
                      );
                      if (r == true) load();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => delete(a['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
