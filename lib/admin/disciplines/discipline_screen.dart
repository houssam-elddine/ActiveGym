import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/api_service.dart';
import 'discipline_form.dart';

class DisciplineScreen extends StatefulWidget {
  @override
  _DisciplineScreenState createState() => _DisciplineScreenState();
}

class _DisciplineScreenState extends State<DisciplineScreen> {
  List<dynamic> disciplines = [];

  load() async {
    final res = await ApiService.get('/disciplines');
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    setState(() {
      disciplines = (data['disciplines'] ?? []) as List<dynamic>;
    });
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
            leading: d['img'] != null
    ? Image.network(
        'http://10.0.2.2:8000/storage/' + d['img'],
        width: 40,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print("Image load error: $error");          // ← سيطبع السبب الحقيقي في console
          print("Stack: $stackTrace");
          return const Icon(
            Icons.broken_image,
            size: 40,
            color: Colors.red,
          );
        },
      )
    : const Icon(Icons.image_not_supported, size: 40),
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
