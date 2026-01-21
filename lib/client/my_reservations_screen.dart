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
    final res = await ApiService.get('/my-reservations');
    if (res.statusCode == 200) {
      reservations = jsonDecode(res.body);
    }
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mes réservations")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : reservations.isEmpty
              ? Center(child: Text("Aucune réservation"))
              : ListView.builder(
                  itemCount: reservations.length,
                  itemBuilder: (_, i) {
                    final r = reservations[i];
                    return Card(
                      margin:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        title: Text(
                          r['abonnement']['nom'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: StatusBadge(status: r['status']),
                        ),
                        trailing: r['status'] == 'en attente'
                            ? IconButton(
                                icon: Icon(Icons.cancel, color: Colors.red),
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
