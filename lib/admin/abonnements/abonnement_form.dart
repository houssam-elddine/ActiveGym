import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/api_service.dart';

class AbonnementForm extends StatefulWidget {
  final Map? abonnement;
  AbonnementForm({this.abonnement});

  @override
  _AbonnementFormState createState() => _AbonnementFormState();
}

class _AbonnementFormState extends State<AbonnementForm> {
  final nom = TextEditingController();
  final prix = TextEditingController();
  int? disciplineId;

  List disciplines = [];

  @override
  void initState() {
    super.initState();
    loadDisciplines();

    if (widget.abonnement != null) {
      nom.text = widget.abonnement!['nom'];
      prix.text = widget.abonnement!['prix'].toString();
      disciplineId = widget.abonnement!['discipline']['id'];
    }
  }

  loadDisciplines() async {
    final res = await ApiService.get('/disciplines');
    disciplines = jsonDecode(res.body);
    setState(() {});
  }

  save() async {
    final data = {
      "nom": nom.text,
      "prix": double.parse(prix.text),
      "discipline_id": disciplineId,
    };

    if (widget.abonnement == null) {
      await ApiService.post('/abonnements', data);
    } else {
      await ApiService.put(
        '/abonnements/${widget.abonnement!['id']}',
        data,
      );
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.abonnement == null
            ? "Ajouter un abonnement"
            : "Modifier l'abonnement"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nom,
              decoration: InputDecoration(labelText: "Nom"),
            ),
            TextField(
              controller: prix,
              decoration: InputDecoration(labelText: "Prix"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 15),
            DropdownButtonFormField<int>(
              value: disciplineId,
              hint: Text("Choisir une discipline"),
              items: disciplines.map<DropdownMenuItem<int>>((d) {
                return DropdownMenuItem(
                  value: d['id'],
                  child: Text(d['nom']),
                );
              }).toList(),
              onChanged: (v) => setState(() => disciplineId = v),
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: save,
              child: Text("Enregistrer"),
            ),
          ],
        ),
      ),
    );
  }
}
