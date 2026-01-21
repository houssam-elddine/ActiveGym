import 'package:flutter/material.dart';
import 'disciplines_screen.dart';
import 'my_reservations_screen.dart';

class ClientHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Espace Client")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.fitness_center),
              title: Text("Disciplines"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DisciplinesScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.bookmark),
              title: Text("Mes réservations"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MyReservationsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
