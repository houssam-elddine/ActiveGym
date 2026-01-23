import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/api_service.dart';

class ReservationScreen extends StatefulWidget {
  final Map<String, dynamic> abonnement;

  const ReservationScreen({
    super.key,
    required this.abonnement,
  });

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _loadingCoaches = false;

  List<Map<String, dynamic>> _coaches = [];
  Map<String, dynamic>? _selectedCoach;

  @override
  void initState() {
    super.initState();
    _loadCoaches();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  /// 🔹 تحميل coaches حسب discipline
  Future<void> _loadCoaches() async {
    final discipline = widget.abonnement['discipline'];
    if (discipline == null || discipline['id'] == null) return;

    final disciplineId = discipline['id'];
    setState(() => _loadingCoaches = true);

    try {
      final res = await ApiService.get('/coaches/discipline/$disciplineId');
      final data = jsonDecode(res.body);

      if (!mounted) return;

      if (data['coaches'] != null && data['coaches'] is List) {
        _coaches = List<Map<String, dynamic>>.from(data['coaches']);
      } else {
        _coaches = [];
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erreur lors du chargement des coachs"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _loadingCoaches = false);
    }
  }

  /// 🔹 إرسال réservation
  Future<void> _submitReservation() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final body = {
        "abonnement_id": widget.abonnement['id'],
        "numer_telephone": _phoneController.text.trim(),
      };

      if (_selectedCoach != null) {
        body["coach_id"] = _selectedCoach!['id'];
      }

      final response = await ApiService.post('/reservations', body);

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context, true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Réservation enregistrée avec succès ✓"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error['message'] ?? "Erreur serveur"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur de connexion : $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Réserver cet abonnement"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 Card abonnement
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.abonnement['nom'] ?? "",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${widget.abonnement['prix'] ?? 0} DA",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.teal.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                /// 🔹 Coaches dropdown
                Text(
                  "Coach (facultatif)",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),

                if (_loadingCoaches)
                  const Center(child: CircularProgressIndicator())
                else if (_coaches.isEmpty)
                  const Text(
                    "Aucun coach disponible pour cette discipline",
                    style: TextStyle(color: Colors.grey),
                  )
                else
                  DropdownButtonFormField<Map<String, dynamic>?>(
                    value: _selectedCoach,
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: [
                      const DropdownMenuItem<Map<String, dynamic>?>(
                        value: null,
                        child: Text("Sans coach particulier"),
                      ),
                      ..._coaches.map(
                        (coach) => DropdownMenuItem<Map<String, dynamic>>(
                          value: coach,
                          child: Text(coach['name'] ?? coach['nom'] ?? ""),
                        ),
                      ),
                    ],
                    onChanged: (v) {
                      setState(() => _selectedCoach = v);
                    },
                  ),

                const SizedBox(height: 32),

                /// 🔹 Phone
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Numéro de téléphone",
                    prefixIcon: const Icon(Icons.phone_android),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return "Numéro obligatoire";
                    }
                    if (v.trim().length < 9) {
                      return "Numéro invalide";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 40),

                /// 🔹 Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitReservation,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Confirmer la réservation"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
