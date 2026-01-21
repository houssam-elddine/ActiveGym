import 'package:flutter/material.dart';
import '../../core/api_service.dart';

class ReservationScreen extends StatefulWidget {
  final Map abonnement;

  ReservationScreen({required this.abonnement});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final phone = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Réservation")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.abonnement['nom'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "${widget.abonnement['prix']} DA / mois",
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: phone,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Numéro de téléphone",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 25),
            loading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text("Confirmer la réservation"),
                    onPressed: () async {
                      if (phone.text.isEmpty) return;

                      setState(() => loading = true);

                      final res =
                          await ApiService.post('/reservations', {
                        "abonnement_id": widget.abonnement['id'],
                        "numer_telephone": phone.text,
                      });

                      setState(() => loading = false);

                      if (res.statusCode == 201 ||
                          res.statusCode == 200) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Réservation envoyée ✅"),
                          ),
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
