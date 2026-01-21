import 'dart:convert';
import 'package:flutter/material.dart';
import '../core/api_service.dart';
import 'abonnements_screen.dart';
import 'coaches_screen.dart';
import '../widgets/discipline_card.dart';

class DisciplinesScreen extends StatefulWidget {
  const DisciplinesScreen({super.key});

  @override
  State<DisciplinesScreen> createState() => _DisciplinesScreenState();
}

class _DisciplinesScreenState extends State<DisciplinesScreen> {
  List<dynamic> disciplines = [];
  bool loading = true;
  String? errorMessage;

  Future<void> load() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final res = await ApiService.get('/discipline');

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;

        setState(() {
          disciplines = data['disciplines'] as List<dynamic>? ?? [];
          loading = false;
        });
      } else {
        setState(() {
          errorMessage = 'فشل جلب الاختصاصات (${res.statusCode})';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'حدث خطأ: $e';
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Disciplines"),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: load,
                        child: const Text("إعادة المحاولة"),
                      ),
                    ],
                  ),
                )
              : disciplines.isEmpty
                  ? const Center(child: Text("لا توجد اختصاصات حالياً"))
                  : RefreshIndicator(
                      onRefresh: load,
                      child: ListView.builder(
                        itemCount: disciplines.length,
                        itemBuilder: (context, index) {
                          final d = disciplines[index];
                          return DisciplineCard(
                            discipline: d,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AbonnementsScreen(discipline: d),
                                ),
                              );
                            },
                            onCoachesTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CoachesScreen(discipline: d),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
    );
  }
}