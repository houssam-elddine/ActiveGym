import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/api_service.dart';

class DisciplineScreen extends StatefulWidget {
  @override
  _DisciplineScreenState createState() => _DisciplineScreenState();
}

class _DisciplineScreenState extends State<DisciplineScreen> {
  List disciplines = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {
    final res = await ApiService.get('/disciplines');
    setState(() {
      disciplines = jsonDecode(res.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestion des disciplines")),
      body: ListView.builder(
        itemCount: disciplines.length,
        itemBuilder: (_, i) => ListTile(
          title: Text(disciplines[i]['nom']),
          subtitle: Text("Prix: ${disciplines[i]['prix']} DA"),
        ),
      ),
    );
  }
}
