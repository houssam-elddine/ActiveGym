import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/api_service.dart';
import '../../core/config.dart';

class CoachesScreen extends StatefulWidget {
  final Map discipline;

  CoachesScreen({required this.discipline});

  @override
  State<CoachesScreen> createState() => _CoachesScreenState();
}

class _CoachesScreenState extends State<CoachesScreen> {
  List coaches = [];
  bool loading = true;

  Future load() async {
    final res = await ApiService.get('/disciplines');
    if (res.statusCode == 200) {
      final disciplines = jsonDecode(res.body);
      final d = disciplines.firstWhere(
        (e) => e['id'] == widget.discipline['id'],
      );
      coaches = d['coaches'] ?? [];
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
      appBar: AppBar(title: Text("Coaches")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : coaches.isEmpty
              ? Center(child: Text("Aucun coach"))
              : ListView.builder(
                  itemCount: coaches.length,
                  itemBuilder: (_, i) {
                    final c = coaches[i];
                    final imageUrl = c['img'] != null
                        ? Config.baseUrl.replaceAll('/api', '') +
                            '/storage/' +
                            c['img']
                        : null;

                    return Card(
                      margin:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 110,
                            height: 110,
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
                            child: imageUrl == null
                                ? Icon(Icons.person, size: 50)
                                : null,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c['name'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    c['description'] ?? '',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
