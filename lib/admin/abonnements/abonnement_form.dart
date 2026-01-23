import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/api_service.dart';

class AbonnementForm extends StatefulWidget {
  final Map? abonnement;

  const AbonnementForm({super.key, this.abonnement});

  @override
  State<AbonnementForm> createState() => _AbonnementFormState();
}

class _AbonnementFormState extends State<AbonnementForm> {
  final TextEditingController nom = TextEditingController();
  final TextEditingController prix = TextEditingController();

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

  /// تحميل disciplines
  Future<void> loadDisciplines() async {
    try {
      final res = await ApiService.get('/disciplines');
      final data = jsonDecode(res.body);

      if (!mounted) return; // ✅ حماية مهمة

      disciplines = data['disciplines'];
      setState(() {});
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("خطأ في تحميل disciplines")),
      );
    }
  }

  /// حفظ abonnement
  Future<void> save() async {
    if (disciplineId == null) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("اختر discipline")),
      );
      return;
    }

    final data = {
      "nom": nom.text.trim(),
      "prix": double.tryParse(prix.text) ?? 0,
      "discipline_id": disciplineId,
    };

    try {
      if (widget.abonnement == null) {
        await ApiService.post('/abonnements', data);
      } else {
        await ApiService.put(
          '/abonnements/${widget.abonnement!['id']}',
          data,
        );
      }

      if (!mounted) return; // ✅ قبل Navigator

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("فشل حفظ abonnement")),
      );
    }
  }

  @override
  void dispose() {
    nom.dispose();
    prix.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.abonnement == null
              ? "Ajouter un abonnement"
              : "Modifier l'abonnement",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nom,
              decoration: const InputDecoration(labelText: "Nom"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: prix,
              decoration: const InputDecoration(labelText: "Prix"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),

            /// Dropdown disciplines
            DropdownButtonFormField<int>(
              value: disciplineId,
              hint: const Text("Choisir une discipline"),
              items: disciplines.map<DropdownMenuItem<int>>((d) {
                return DropdownMenuItem<int>(
                  value: d['id'],
                  child: Text(d['nom']),
                );
              }).toList(),
              onChanged: (v) {
                if (!mounted) return;
                setState(() => disciplineId = v);
              },
            ),

            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: save,
                child: const Text("Enregistrer"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
