import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/api_service.dart';
import 'coach_form.dart';

class CoachScreen extends StatefulWidget {
  const CoachScreen({super.key});

  @override
  State<CoachScreen> createState() => _CoachScreenState();
}

class _CoachScreenState extends State<CoachScreen> {
  List<dynamic> coaches = [];
  bool isLoading = true;
  String? errorMessage;

  // غيّر هذا إلى IP جهازك الحقيقي (مثال)
  // static const String baseUrl = 'http://192.168.1.100:8000';
  static const String baseUrl = 'https://10fd7c24c102.ngrok-free.app'; // احتفظ به للاختبار السريع

  Future<void> load() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final res = await ApiService.get('/coaches');
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        setState(() {
          coaches = data['coaches'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'فشل جلب البيانات: ${res.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'حدث خطأ: $e';
        isLoading = false;
      });
    }
  }

  Future<void> delete(int id) async {
    try {
      await ApiService.delete('/coaches/$id');
      await load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل الحذف: $e')),
        );
      }
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
        title: const Text("Gestion des coachs"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) =>  CoachForm()),
              );
              if (result == true && mounted) {
                load();
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(errorMessage!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: load,
                        child: const Text("إعادة المحاولة"),
                      ),
                    ],
                  ),
                )
              : coaches.isEmpty
                  ? const Center(child: Text("لا يوجد مدربين بعد"))
                  : RefreshIndicator(
                      onRefresh: load,
                      child: ListView.builder(
                        itemCount: coaches.length,
                        itemBuilder: (context, index) {
                          final coach = coaches[index];
                          final imgPath = coach['img'] as String?;
                          final imgUrl = imgPath != null ? '$baseUrl/storage/$imgPath' : null;

                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: ListTile(
                              leading: imgUrl != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        imgUrl,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return const SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          print("خطأ تحميل صورة المدرب: $error → $imgUrl");
                                          return const Icon(Icons.person, size: 50, color: Colors.grey);
                                        },
                                      ),
                                    )
                                  : const Icon(Icons.person, size: 50),
                              title: Text(coach['name']?.toString() ?? 'غير معروف'),
                              subtitle: Text(
                                coach['discipline']?['nom']?.toString() ?? 'لا يوجد اختصاص',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CoachForm(coach: coach),
                                        ),
                                      );
                                      if (result == true && mounted) {
                                        load();
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => delete(coach['id']),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}