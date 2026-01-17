import 'package:ActiveGym/admin/abonnements/abonnement_screen.dart';
import 'package:ActiveGym/admin/coaches/coach_screen.dart';
import 'package:ActiveGym/admin/reservations/reservation_admin_screen.dart';
import 'package:flutter/material.dart';
import 'disciplines/discipline_screen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tableau de bord Admin")),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(20),
        children: [
          _item(context, "Disciplines", Icons.fitness_center,
              DisciplineScreen()),
          _item(context, "Coachs", Icons.people, CoachScreen()),
          _item(context, "Abonnements", Icons.card_membership, AbonnementScreen()),
          _item(context, "Réservations", Icons.event, ReservationAdminScreen()),
        ],
      ),
    );
  }

  Widget _item(
      BuildContext context, String title, IconData icon, Widget page) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => page)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            SizedBox(height: 10),
            Text(title),
          ],
        ),
      ),
    );
  }
}
