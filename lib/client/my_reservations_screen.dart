import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/api_service.dart';
import '../../widgets/status_badge.dart';

class MyReservationsScreen extends StatefulWidget {
  @override
  State<MyReservationsScreen> createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen> {
  List reservations = [];
  bool loading = true;

  Future load() async {
    setState(() => loading = true);

    try {
      final res = await ApiService.get('/my-reservations');

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        reservations = data['reservations'] ?? [];
      } else {
        reservations = [];
      }
    } catch (e) {
      reservations = [];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur lors du chargement : $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mes réservations")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : reservations.isEmpty
              ? const Center(child: Text("Aucune réservation"))
              : ListView.builder(
                  itemCount: reservations.length,
                  itemBuilder: (_, i) {
                    final r = reservations[i];

                    final abonnement = r['abonnement'] ?? {};
                    final discipline = abonnement['discipline'] ?? {};
                    final coach = r['coach']; // ✅ أخذ المدرب من reservation مباشرة

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        title: Text(
                          abonnement['nom'] ?? 'Abonnement inconnu',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              "Discipline: ${discipline['nom'] ?? '-'}",
                              style: const TextStyle(fontSize: 12),
                            ),
                            if (coach != null)
                              Text(
                                "Coach: ${coach['name'] ?? '-'}",
                                style: const TextStyle(fontSize: 12),
                              ),
                            const SizedBox(height: 4),
                            StatusBadge(status: r['status']),
                          ],
                        ),
                        trailing: r['status'] == 'en attente'
                            ? IconButton(
                                icon: const Icon(Icons.cancel,
                                    color: Colors.red),
                                onPressed: () async {
                                  await ApiService.put(
                                    '/reservations/${r['id']}/cancel',
                                    {},
                                  );
                                  load();
                                },
                              )
                            : null,
                      ),
                    );
                  },
                ),
    );
  }
}
