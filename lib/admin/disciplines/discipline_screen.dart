import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/api_service.dart';
import 'discipline_form.dart';

class DisciplineScreen extends StatefulWidget {
  @override
  _DisciplineScreenState createState() => _DisciplineScreenState();
}

class _DisciplineScreenState extends State<DisciplineScreen> {
  List disciplines = [];

  load() async {
    final res = await ApiService.get('/disciplines');
    disciplines = jsonDecode(res.body);
    setState(() {});
  }

  delete(id) async {
    await ApiService.delete('/disciplines/$id');
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
        title: Text("Disciplines"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final r = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DisciplineForm()),
              );
              if (r == true) load();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: disciplines.length,
        itemBuilder: (_, i) {
          final d = disciplines[i];
          return ListTile(
            title: Text(d['nom']),
            subtitle: Text("${d['prix']} DA"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    final r = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DisciplineForm(discipline: d),
                      ),
                    );
                    if (r == true) load();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => delete(d['id']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
