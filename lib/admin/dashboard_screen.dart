import 'package:flutter/material.dart';
import 'package:ActiveGym/admin/abonnements/abonnement_screen.dart';
import 'package:ActiveGym/admin/coaches/coach_screen.dart';
import 'package:ActiveGym/admin/reservations/reservation_admin_screen.dart';
import 'package:ActiveGym/admin/disciplines/discipline_screen.dart';
import '../../auth/login_screen.dart'; // ← غيّر المسار حسب مكان شاشة الـ Login
import '../auth/auth_service.dart'; // ← تأكد من المسار الصحيح

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await AuthService.logout();

    // الانتقال إلى شاشة الـ Login وحذف كل الشاشات السابقة
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  LoginScreen()),
        (route) => false, // حذف كل الشاشات السابقة
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tableau de bord Admin"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: 'تسجيل الخروج',
            onPressed: () async {
              // يمكن إضافة تأكيد قبل الخروج (اختياري)
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('تسجيل الخروج'),
                  content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('إلغاء'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('تأكيد', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await _logout(context);
              }
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(20),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _item(context, "Disciplines", Icons.fitness_center,  DisciplineScreen()),
          _item(context, "Coachs", Icons.people,  CoachScreen()),
          _item(context, "Abonnements", Icons.card_membership,  AbonnementScreen()),
          _item(context, "Réservations", Icons.event,  ReservationAdminScreen()),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, String title, IconData icon, Widget page) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).primaryColor),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}