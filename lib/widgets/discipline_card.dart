import 'package:flutter/material.dart';
import '../core/config.dart';

class DisciplineCard extends StatelessWidget {
  final Map discipline;
  final VoidCallback onTap;
  final VoidCallback onCoachesTap;

  DisciplineCard({
    required this.discipline,
    required this.onTap,
    required this.onCoachesTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = discipline['img'] != null
        ? Config.baseUrl.replaceAll('/api', '') +
            '/storage/' +
            discipline['img']
        : null;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              )
            : null,
        color: Colors.grey.shade300,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            Text(
              discipline['nom'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: onTap,
                  child: Text("Abonnements"),
                ),
                SizedBox(width: 10),
                OutlinedButton(
                  onPressed: onCoachesTap,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white),
                  ),
                  child: Text("Coaches"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
