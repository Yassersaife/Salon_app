import 'package:flutter/foundation.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? imageUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.imageUrl,
  });
}

class UserProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String _error = '';
  bool _isLoggedIn = false;

  // جلب البيانات
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isLoggedIn => _isLoggedIn;

  // للتجربة سنفترض أن المستخدم مسجل دخول مسبقاً
  UserProvider() {
    // محاكاة تسجيل دخول المستخدم
    _currentUser = User(
      id: 1,
      name: 'نانا',
      email: 'sara@example.com',
      phone: '055123456789',
      imageUrl: "assets/images/yasser.jpg",
    );
    _isLoggedIn = true;
  }

  // تسجيل الدخول
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // في بيئة الإنتاج، سنستدعي API حقيقي
      // مثال: final result = await ApiService().login(email, password);

      // محاكاة عملية تسجيل الدخول
      await Future.delayed(const Duration(seconds: 1));

      _currentUser = User(
        id: 1,
        name: 'نانا',
        email: email,
        phone: '055123456789',
        imageUrl: "assets/images/yasser.jpg",
      );

      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'فشل تسجيل الدخول. تحقق من بيانات الاعتماد.';
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
      // في بيئة الإنتاج، سنستدعي API حقيقي
      // مثال: await ApiService().logout();

      await Future.delayed(const Duration(milliseconds: 500));
      _currentUser = null;
      _isLoggedIn = false;
    } catch (e) {
      _error = 'حدث خطأ أثناء تسجيل الخروج';
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
      // في بيئة الإنتاج، سنستدعي API حقيقي
      // مثال: final result = await ApiService().updateProfile(userData);

      await Future.delayed(const Duration(seconds: 1));

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
      _error = 'حدث خطأ أثناء تحديث الملف الشخصي';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}