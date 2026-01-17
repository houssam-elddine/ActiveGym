class ApiConstants {
  // رابط الـ API الرئيسي
  static const String baseUrl = "http://10.0.0.2:8000/api"; // مثلا http://127.0.0.1:8000/api

  // Auth
  static const String login = "$baseUrl/login";
  static const String register = "$baseUrl/register";
  static const String logout = "$baseUrl/logout";

  // Clients (Admin)
  static const String clients = "$baseUrl/clients";

  // Attendance (Client)
  static const String checkIn = "$baseUrl/attendance/check-in";

  // Subscriptions
  static const String subscriptions = "$baseUrl/subscriptions";
  static const String assignSubscription = "$baseUrl/subscriptions/assign";
}
