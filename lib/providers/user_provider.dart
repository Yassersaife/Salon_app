// lib/providers/user_provider.dart
import 'package:flutter/foundation.dart';
import 'package:salon_booking_app/models/user.dart';
import 'package:salon_booking_app/services/auth_service.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String _error = '';
  bool _isLoggedIn = false;
  final AuthService _authService = AuthService();

  // جلب البيانات
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isLoggedIn => _isLoggedIn;

  UserProvider() {
    // التحقق من حالة تسجيل الدخول عند إنشاء المزود
    _checkLoginStatus();
  }

  // التحقق من حالة تسجيل الدخول
  Future<void> _checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      // التحقق مما إذا كان المستخدم مسجل دخول
      _isLoggedIn = await _authService.isLoggedIn();

      if (_isLoggedIn) {
        // جلب بيانات المستخدم الحالي
        _currentUser = await _authService.getCurrentUser();
      }

      _error = '';
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoggedIn = false;
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // تعيين معلومات المستخدم الحالي
  void setCurrentUser(User user) {
    _currentUser = user;
    _isLoggedIn = true;
    _error = '';
    notifyListeners();
  }

  // تسجيل الدخول
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _currentUser = await _authService.login(email, password);
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoggedIn = false;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // تسجيل مستخدم جديد
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
  }) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _currentUser = await _authService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
      );
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoggedIn = false;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // تسجيل الخروج
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _currentUser = null;
      _isLoggedIn = false;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // تحديث بيانات المستخدم
  Future<bool> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // هنا يمكن إضافة استدعاء API لتحديث البيانات في الباك إند
      // مثال: await _authService.updateProfile(userData);

      // تحديث البيانات محلياً
      _currentUser = User(
        id: _currentUser!.id,
        name: name,
        email: email,
        phone: phone,
        imageUrl: _currentUser!.imageUrl,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}