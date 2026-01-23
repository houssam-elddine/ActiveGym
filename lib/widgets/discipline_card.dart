import 'package:flutter/material.dart';

class DisciplineCard extends StatelessWidget {
  final Map<String, dynamic> discipline;
  final VoidCallback onTap;
  final VoidCallback? onCoachesTap; // ✅ أصبح اختياري

  const DisciplineCard({
    super.key,
    required this.discipline,
    required this.onTap,
    this.onCoachesTap, // اختياري
  });

  @override
  Widget build(BuildContext context) {
    final List abonnements = discipline['abonnements'] ?? [];
    final List coachs = discipline['coachs'] ?? [];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🏋️ Nom de la discipline
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: discipline['img'] != null
                      ? NetworkImage(
                          'https://10fd7c24c102.ngrok-free.app/storage/${discipline['img']}')
                      : null,
                  child: discipline['img'] == null
                      ? const Icon(Icons.fitness_center)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    discipline['nom'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "${discipline['prix']} DA",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// 📦 Abonnements
            Text(
              "Abonnements (${abonnements.length})",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            abonnements.isEmpty
                ? const Text(
                    "Aucun abonnement",
                    style: TextStyle(color: Colors.grey),
                  )
                : Wrap(
                    spacing: 8,
                    children: abonnements.map<Widget>((a) {
                      return Chip(
                        label: Text("${a['nom']} - ${a['prix']} DA"),
                        backgroundColor: Colors.blue.shade50,
                      );
                    }).toList(),
                  ),

            const SizedBox(height: 12),

            /// 🧑‍🏫 Coachs (affichage seulement)
            Text(
              "Coachs (${coachs.length})",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            coachs.isEmpty
                ? const Text(
                    "Aucun coach disponible",
                    style: TextStyle(color: Colors.grey),
                  )
                : SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: coachs.length,
                      itemBuilder: (context, index) {
                        final c = coachs[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundImage: c['img'] != null
                                    ? NetworkImage(
                                        'https://10fd7c24c102.ngrok-free.app/storage/${c['img']}')
                                    : null,
                                child: c['img'] == null
                                    ? const Icon(Icons.person, size: 18)
                                    : null,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                c['name'],
                                style: const TextStyle(fontSize: 10),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

            const SizedBox(height: 8),

            /// 👉 Bouton Réserver
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onTap,
                child: const Text("Réserver"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
