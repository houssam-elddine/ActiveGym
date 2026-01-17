import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/api_service.dart';
import 'coach_form.dart';

class CoachScreen extends StatefulWidget {
  @override
  _CoachScreenState createState() => _CoachScreenState();
}

class _CoachScreenState extends State<CoachScreen> {
  List coaches = [];

  load() async {
    final res = await ApiService.get('/coaches');
    coaches = jsonDecode(res.body);
    setState(() {});
  }

  delete(int id) async {
    await ApiService.delete('/coaches/$id');
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
        title: Text("Gestion des coachs"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final r = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CoachForm()),
              );
              if (r == true) load();
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: coaches.length,
        itemBuilder: (_, i) {
          final c = coaches[i];
          return Card(
            child: ListTile(
              leading: c['img'] != null
                  ? Image.network(
                      "http://10.0.2.2:8000/storage/${c['img']}",
                      width: 50,
                      fit: BoxFit.cover,
                    )
                  : Icon(Icons.person),
              title: Text(c['name']),
              subtitle: Text(c['discipline']['nom']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      final r = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CoachForm(coach: c),
                        ),
                      );
                      if (r == true) load();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => delete(c['id']),
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
