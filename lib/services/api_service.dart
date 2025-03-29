import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:salon_booking_app/models/booking.dart';
import 'package:salon_booking_app/models/salon.dart';
import 'package:salon_booking_app/models/service.dart';

class ApiService {
  // قم بتغيير هذا الرابط إلى الخاص بك عند استخدام API حقيقي
  static const String baseUrl = 'https://your-api-url.com/api';

  // الهيدرز المستخدمة في الطلبات
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ضبط توكن المصادقة
  void setAuthToken(String token) {
    _headers['Authorization'] = 'Bearer $token';
  }

  // ------------- وظائف المستخدم -------------

  // تسجيل الدخول
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: _headers,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('فشل تسجيل الدخول: ${response.body}');
    }
  }

  // تسجيل مستخدم جديد
  Future<Map<String, dynamic>> register(
      String name,
      String email,
      String password,
      String phone,
      ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('فشل التسجيل: ${response.body}');
    }
  }

  // تسجيل الخروج
  Future<void> logout() async {
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('فشل تسجيل الخروج: ${response.body}');
    }
  }

  // ------------- وظائف الصالونات -------------

  // جلب قائمة الصالونات
  Future<List<Salon>> getSalons() async {
    final response = await http.get(
      Uri.parse('$baseUrl/salons'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => Salon.fromJson(json)).toList();
    } else {
      throw Exception('فشل جلب الصالونات: ${response.body}');
    }
  }

  // جلب الصالونات القريبة
  Future<List<Salon>> getNearbySalons(double latitude, double longitude, double radius) async {
    final response = await http.get(
      Uri.parse('$baseUrl/salons/nearby?latitude=$latitude&longitude=$longitude&radius=$radius'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => Salon.fromJson(json)).toList();
    } else {
      throw Exception('فشل جلب الصالونات القريبة: ${response.body}');
    }
  }

  // جلب تفاصيل صالون معين
  Future<Salon> getSalonDetails(int salonId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/salons/$salonId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return Salon.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('فشل جلب تفاصيل الصالون: ${response.body}');
    }
  }

  // البحث عن صالونات
  Future<List<Salon>> searchSalons(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/salons/search?query=$query'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => Salon.fromJson(json)).toList();
    } else {
      throw Exception('فشل البحث عن الصالونات: ${response.body}');
    }
  }

  // تبديل حالة المفضلة
  Future<void> toggleFavorite(int salonId, bool isFavorite) async {
    final response = await http.post(
      Uri.parse('$baseUrl/salons/$salonId/favorite'),
      headers: _headers,
      body: jsonEncode({
        'is_favorite': isFavorite,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('فشل تغيير حالة المفضلة: ${response.body}');
    }
  }

  // ------------- وظائف الحجوزات -------------

  // إنشاء حجز جديد
  Future<Booking> createBooking(Map<String, dynamic> bookingData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/bookings'),
      headers: _headers,
      body: jsonEncode(bookingData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Booking.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('فشل إنشاء الحجز: ${response.body}');
    }
  }

  // جلب حجوزات المستخدم
  Future<List<Booking>> getUserBookings() async {
    final response = await http.get(
      Uri.parse('$baseUrl/bookings'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('فشل جلب الحجوزات: ${response.body}');
    }
  }

  // إلغاء حجز
  Future<Booking> cancelBooking(int bookingId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/bookings/$bookingId/cancel'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return Booking.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('فشل إلغاء الحجز: ${response.body}');
    }
  }

  // ------------- وظائف الخدمات -------------

  // جلب فئات الخدمات
  Future<List<ServiceCategory>> getServiceCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/service-categories'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => ServiceCategory(
        id: json['id'],
        name: json['name'],
        imageUrl: json['image_url'] ?? '',
      )).toList();
    } else {
      throw Exception('فشل جلب فئات الخدمات: ${response.body}');
    }
  }
}