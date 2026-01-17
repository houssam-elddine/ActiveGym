import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  File? image;

  @override
  void initState() {
    super.initState();
    if (widget.discipline != null) {
      nom.text = widget.discipline!['nom'];
      prix.text = widget.discipline!['prix'].toString();
    }
  }

  pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (picked != null) {
      setState(() => image = File(picked.path));
    }
  }

  save() async {
    final data = {
      "nom": nom.text,
      "prix": prix.text,
    };

    if (widget.discipline == null) {
      await ApiService.multipart('/disciplines', data, image);
    } else {
      await ApiService.multipart(
        '/disciplines/${widget.discipline!['id']}',
        data,
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
        title: Text(widget.discipline == null
            ? "Ajouter discipline"
            : "Modifier discipline"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 45,
                backgroundImage:
                    image != null ? FileImage(image!) : null,
                child: image == null
                    ? Icon(Icons.camera_alt)
                    : null,
              ),
            ),
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
