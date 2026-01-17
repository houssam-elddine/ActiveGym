import 'package:flutter/material.dart';
import '../../core/api_service.dart';

class DisciplineForm extends StatefulWidget {
  final Map? discipline;
  DisciplineForm({this.discipline});

  @override
  _DisciplineFormState createState() => _DisciplineFormState();
}

class _DisciplineFormState extends State<DisciplineForm> {
  final nom = TextEditingController();
  final prix = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.discipline != null) {
      nom.text = widget.discipline!['nom'];
      prix.text = widget.discipline!['prix'].toString();
    }
  }

  save() async {
    final data = {
      "nom": nom.text,
      "prix": double.parse(prix.text),
    };

    if (widget.discipline == null) {
      await ApiService.post('/disciplines', data);
    } else {
      await ApiService.put(
        '/disciplines/${widget.discipline!['id']}',
        data,
      );
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.discipline == null
            ? "Ajouter une discipline"
            : "Modifier discipline"),
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
            SizedBox(height: 20),
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
