// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:salon_booking_app/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:salon_booking_app/models/user.dart';

class AuthService {

  // الهيدرز المستخدمة في الطلبات
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // تخزين توكن المصادقة
  Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    _headers['Authorization'] = 'Bearer $token';
  }

  // استرجاع توكن المصادقة
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // حذف توكن المصادقة
  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _headers.remove('Authorization');
  }

  // تسجيل الدخول
  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/login'),
      headers: _headers,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // تخزين التوكن
      if (data['token'] != null) {
        await _storeToken(data['token']);
      }

      // إرجاع بيانات المستخدم
      return User(
        id: data['user']['id'],
        name: data['user']['name'],
        email: data['user']['email'],
        phone: data['user']['phone'] ?? '',
        imageUrl: data['user']['image_url'] ?? '',
      );
    } else {
      final Map<String, dynamic> errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'فشل تسجيل الدخول');
    }
  }

  // تسجيل مستخدم جديد
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/register'),
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'phone': phone,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      // تخزين التوكن
      if (data['token'] != null) {
        await _storeToken(data['token']);
      }

      // إرجاع بيانات المستخدم
      return User(
        id: data['user']['id'],
        name: data['user']['name'],
        email: data['user']['email'],
        phone: data['user']['phone'] ?? '',
        imageUrl: data['user']['image_url'] ?? '',
      );
    } else {
      final Map<String, dynamic> errorData = jsonDecode(response.body);
      print(errorData['message']);
      throw Exception( 'فشل التسجيل');
    }
  }

  // تسجيل الخروج
  Future<void> logout() async {
    final token = await getToken();

    if (token != null) {
      _headers['Authorization'] = 'Bearer $token';

      try {
        final response = await http.post(
          Uri.parse('${ApiConfig.baseUrl}/logout'),
          headers: _headers,
        ).timeout(const Duration(seconds: 5)); // ⏳ منع التعليق

        print('Logout response: ${response.statusCode}');
        if (response.statusCode == 200) {
          await _removeToken();
        } else {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          throw Exception(errorData['message'] ?? 'فشل تسجيل الخروج');
        }
      } catch (e) {
        print('Logout error: $e');
        await _removeToken();
        rethrow;
      }
    } else {
      print('No token found');
    }
  }

  // استرداد كلمة المرور
  Future<void> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/forgot-password'),
      headers: _headers,
      body: jsonEncode({
        'email': email,
      }),
    );

    if (response.statusCode != 200) {
      final Map<String, dynamic> errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'فشل إرسال رمز استعادة كلمة المرور');
    }
  }

  // إعادة تعيين كلمة المرور
  Future<void> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/reset-password'),
      headers: _headers,
      body: jsonEncode({
        'email': email,
        'token': token,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    if (response.statusCode != 200) {
      final Map<String, dynamic> errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'فشل إعادة تعيين كلمة المرور');
    }
  }

  // تحديث التوكن
  Future<void> refreshToken() async {
    final token = await getToken();
    if (token != null) {
      _headers['Authorization'] = 'Bearer $token';

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/refresh-token'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          await _storeToken(data['token']);
        }
      } else {
        await _removeToken();
        throw Exception('انتهت صلاحية الجلسة، يرجى تسجيل الدخول مرة أخرى');
      }
    }
  }

  // التحقق من حالة تسجيل الدخول
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // جلب بيانات المستخدم الحالي
  Future<User> getCurrentUser() async {
    final token = await getToken();
    if (token != null) {
      _headers['Authorization'] = 'Bearer $token';

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/user'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User(
          id: data['id'],
          name: data['name'],
          email: data['email'],
          phone: data['phone'] ?? '',
          imageUrl: data['image_url'] ?? '',
        );
      } else {
        await _removeToken();
        throw Exception('فشل جلب بيانات المستخدم');
      }
    } else {
      throw Exception('المستخدم غير مسجل دخول');
    }
  }
}