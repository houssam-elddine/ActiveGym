import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/api_constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool isLoading = false;

  void checkIn() async {
    setState(() => isLoading = true);

    final response = await http.post(
      Uri.parse(ApiConstants.checkIn),
      headers: {
        'Accept': 'application/json',
        // هنا يمكن تضيف Authorization: Bearer token لو مستخدم Sanctum
      },
      body: {
        'client_id': '1', // استبدل بالـ client_id الفعلي
      },
    );

    setState(() => isLoading = false);

    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: data['message']);
    } else {
      Fluttertoast.showToast(msg: data['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : ElevatedButton.icon(
                onPressed: checkIn,
                icon: Icon(Icons.check),
                label: Text("Check In"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  backgroundColor: Colors.deepPurple,
                ),
              ),
      ),
    );
  }
}
