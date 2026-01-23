import 'package:flutter/material.dart';
import '../core/api_service.dart';
import '../auth/auth_service.dart';
import '../auth/login_screen.dart';
import 'disciplines_screen.dart';
import 'my_reservations_screen.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    // (اختياري) نداء API logout
    try {
      await ApiService.post('/logout', {});
    } catch (_) {}

    // حذف التوكن محلياً
    await AuthService.logout();

    // حذف كل الشاشات والرجوع للـ Login
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) =>  LoginScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'خروج',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _logout(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مساحة الزبون'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: 'تسجيل الخروج',
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.fitness_center,
                      size: 64,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'مرحباً بك في مساحتك الخاصة',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'اختر ما تريد القيام به الآن',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            _buildOptionTile(
              context,
              icon: Icons.fitness_center,
              title: 'التخصصات',
              subtitle: 'اكتشف التخصصات الرياضية المتاحة',
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DisciplinesScreen()),
                );
              },
            ),

            const SizedBox(height: 16),

            _buildOptionTile(
              context,
              icon: Icons.bookmark_added,
              title: 'حجوزاتي',
              subtitle: 'تابع حجوزاتك',
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MyReservationsScreen(),
                  ),
                );
              },
            ),

            const Spacer(),

            Center(
              child: Text(
                'نسخة التطبيق • 1.0.0',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          radius: 28,
          child: Icon(icon, color: color, size: 32),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        subtitle: Text(subtitle),
        trailing:
            const Icon(Icons.arrow_forward_ios_rounded, size: 18),
        onTap: onTap,
      ),
    );
  }
}
