import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/api_service.dart';

class CoachForm extends StatefulWidget {
  final Map? coach;
  CoachForm({this.coach});

  @override
  _CoachFormState createState() => _CoachFormState();
}

class _CoachFormState extends State<CoachForm> {
  final name = TextEditingController();
  final description = TextEditingController();
  int? disciplineId;

  List disciplines = [];
  File? image;

  @override
  void initState() {
    super.initState();
    loadDisciplines();

    if (widget.coach != null) {
      name.text = widget.coach!['name'];
      description.text = widget.coach!['description'] ?? '';
      disciplineId = widget.coach!['discipline']['id'];
    }
  }

  // ✅ التصحيح هنا
  loadDisciplines() async {
    final res = await ApiService.get('/disciplines');
    final data = jsonDecode(res.body);

    disciplines = data['disciplines']; // ✅

    setState(() {});
  }

  pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      setState(() => image = File(picked.path));
    }
  }

  save() async {
    final fields = {
      "name": name.text,
      "description": description.text,
      "discipline_id": disciplineId.toString(),
    };

    if (widget.coach == null) {
      await ApiService.multipart('/coaches', fields, image, isUpdate: false);
    } else {
      await ApiService.multipart(
        '/coaches/${widget.coach!['id']}',
        fields,
        image,
        isUpdate: true,
      );
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.coach == null ? "Ajouter un coach" : "Modifier coach",
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                builder: (_) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(Icons.camera),
                      title: Text("Caméra"),
                      onTap: () {
                        pickImage(ImageSource.camera);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.image),
                      title: Text("Galerie"),
                      onTap: () {
                        pickImage(ImageSource.gallery);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: image != null
                    ? FileImage(image!)
                    : widget.coach?['img'] != null
                        ? NetworkImage(
                            "https://10fd7c24c102.ngrok-free.app/storage/${widget.coach!['img']}",
                          )
                        : null,
                child: image == null && widget.coach?['img'] == null
                    ? Icon(Icons.camera_alt)
                    : null,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: name,
              decoration: InputDecoration(labelText: "Nom"),
            ),
            TextField(
              controller: description,
              decoration: InputDecoration(labelText: "Description"),
            ),
            DropdownButtonFormField<int>(
              value: disciplineId,
              hint: Text("Choisir discipline"),
              items: disciplines.map<DropdownMenuItem<int>>((d) {
                return DropdownMenuItem(
                  value: d['id'],
                  child: Text(d['nom']),
                );
              }).toList(),
              onChanged: (v) => setState(() => disciplineId = v),
            ),
            SizedBox(height: 30),
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
