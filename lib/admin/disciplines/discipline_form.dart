import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/api_service.dart';

class DisciplineForm extends StatefulWidget {
  final Map? discipline;

  const DisciplineForm({super.key, this.discipline});

  @override
  State<DisciplineForm> createState() => _DisciplineFormState();
}

class _DisciplineFormState extends State<DisciplineForm> {
  final _nomController = TextEditingController();
  final _prixController = TextEditingController();
  final ImagePicker _picker = ImagePicker(); // ← instance unique

  File? _image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.discipline != null) {
      _nomController.text = widget.discipline!['nom']?.toString() ?? '';
      _prixController.text = widget.discipline!['prix']?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prixController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        // optionnel : imageQuality: 70,
        // requestFullMetadata: false,
      );

      if (pickedFile == null) {
        // utilisateur a annulé
      } else if (mounted) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la sélection : $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      debugPrint("ImagePicker error: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _save() async {
    if (_isLoading) return;

    if (_nomController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Le nom est obligatoire")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final data = {
        "nom": _nomController.text.trim(),
        "prix": _prixController.text.trim(),
      };

      if (widget.discipline == null) {
        // CREATE
        await ApiService.multipart('/disciplines', data, _image);
      } else {
        // UPDATE
        await ApiService.multipart(
          '/disciplines/${widget.discipline!['id']}',
          data,
          _image,
          isUpdate: true,
        );
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur lors de l'enregistrement : $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.discipline == null ? "Ajouter discipline" : "Modifier discipline",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),

              // Photo
              Center(
                child: GestureDetector(
                  onTap: _isLoading ? null : _pickImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage:
                            _image != null ? FileImage(_image!) : null,
                        child: _image == null
                            ? const Icon(Icons.camera_alt, size: 40)
                            : null,
                      ),
                      if (_isLoading)
                        const Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.white,
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2.5),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              TextField(
                controller: _nomController,
                decoration: const InputDecoration(
                  labelText: "Nom de la discipline",
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _prixController,
                decoration: const InputDecoration(
                  labelText: "Prix",
                  border: OutlineInputBorder(),
                  prefixText: "DA  ",
                ),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 40),

              ElevatedButton.icon(
                onPressed: _isLoading ? null : _save,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(_isLoading ? "Enregistrement..." : "Enregistrer"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}