import 'package:flutter/material.dart';
import '../constants/api_constants.dart';
import 'clients_screen.dart';
import 'subscriptions_screen.dart';
import 'attendance_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String role;

  DashboardScreen({required this.role}); // role: 'admin' or 'client'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: role == 'admin'
            ? AdminDashboard()
            : ClientDashboard(),
      ),
    );
  }
}

// ====== Admin Dashboard ======
class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DashboardCard(
          title: "Clients",
          icon: Icons.people,
          onTap: () {
            Navigator.push(context, 
              MaterialPageRoute(builder: (_) => ClientsScreen()));
          },
        ),
        SizedBox(height: 20),
        DashboardCard(
          title: "Subscriptions",
          icon: Icons.card_membership,
          onTap: () {
            Navigator.push(context, 
              MaterialPageRoute(builder: (_) => SubscriptionsScreen()));
          },
        ),
      ],
    );
  }
}

// ====== Client Dashboard ======
class ClientDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DashboardCard(
          title: "Check In Attendance",
          icon: Icons.fitness_center,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => AttendanceScreen()));
          },
        ),
        SizedBox(height: 20),
        DashboardCard(
          title: "My Subscriptions",
          icon: Icons.card_membership,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => SubscriptionsScreen()));
          },
        ),
      ],
    );
  }
}

// ====== Card Widget ======
class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  DashboardCard({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          height: 120,
          child: Row(
            children: [
              Icon(icon, size: 50, color: Colors.deepPurple),
              SizedBox(width: 20),
              Text(title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
