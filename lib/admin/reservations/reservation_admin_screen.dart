import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/api_service.dart';

class ReservationAdminScreen extends StatefulWidget {
  @override
  _ReservationAdminScreenState createState() =>
      _ReservationAdminScreenState();
}

class _ReservationAdminScreenState extends State<ReservationAdminScreen> {
  List reservations = [];

  load() async {
    final res = await ApiService.get('/reservations');
    reservations = jsonDecode(res.body);
    setState(() {});
  }

  updateStatus(id, status) async {
    await ApiService.put('/reservations/$id/status', {
      "status": status,
    });
    load();
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Réservations")),
      body: ListView.builder(
        itemCount: reservations.length,
        itemBuilder: (_, i) {
          final r = reservations[i];
          return Card(
            child: ListTile(
              title: Text(r['client']['name']),
              subtitle: Text(
                  "Abonnement: ${r['abonnement']['nom']} | ${r['status']}"),
              trailing: PopupMenuButton<String>(
                onSelected: (v) => updateStatus(r['id'], v),
                itemBuilder: (_) => [
                  PopupMenuItem(
                      value: "confirmer", child: Text("Confirmer")),
                  PopupMenuItem(
                      value: "annuler", child: Text("Annuler")),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
