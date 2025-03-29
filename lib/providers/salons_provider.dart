import 'package:flutter/foundation.dart';
import 'package:salon_booking_app/models/salon.dart';
import 'package:salon_booking_app/models/service.dart';
import 'package:salon_booking_app/services/api_service.dart';

class SalonsProvider with ChangeNotifier {
  List<Salon> _salons = [];
  List<ServiceCategory> _categories = [];
  Salon? _selectedSalon;
  bool _isLoading = false;
  String _error = '';

  // جلب البيانات
  List<Salon> get salons => _salons;
  List<ServiceCategory> get categories => _categories;
  Salon? get selectedSalon => _selectedSalon;
  bool get isLoading => _isLoading;
  String get error => _error;

  SalonsProvider() {
    // جلب البيانات عند إنشاء المزود
    fetchSalons();
    fetchCategories();
  }

  // جلب قائمة الصالونات
  Future<void> fetchSalons() async {
    _isLoading = true;
    notifyListeners();

    try {
      // في بيئة الإنتاج، سنستدعي API حقيقي
      // مثال: final result = await ApiService().getSalons();

      // استخدام بيانات وهمية للتجربة
      await Future.delayed(const Duration(seconds: 1));
      _salons = getMockSalons();
      _error = '';
    } catch (e) {
      _error = 'حدث خطأ أثناء جلب البيانات';
      print('Error fetching salons: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // جلب فئات الخدمات
  Future<void> fetchCategories() async {
    try {
      // في بيئة الإنتاج، سنستدعي API حقيقي
      // مثال: final result = await ApiService().getCategories();

      // استخدام بيانات وهمية للتجربة
      await Future.delayed(const Duration(milliseconds: 800));
      _categories = getMockCategories();
      notifyListeners();
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  // البحث عن صالونات
  Future<void> searchSalons(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      // في بيئة الإنتاج، سنستدعي API حقيقي
      // مثال: final result = await ApiService().searchSalons(query);

      // بحث بسيط في البيانات المحلية
      await Future.delayed(const Duration(milliseconds: 500));
      if (query.isEmpty) {
        _salons = getMockSalons();
      } else {
        _salons = getMockSalons().where((salon) =>
        salon.name.contains(query) ||
            salon.address.contains(query) ||
            salon.description.contains(query)
        ).toList();
      }
      _error = '';
    } catch (e) {
      _error = 'حدث خطأ أثناء البحث';
      print('Error searching salons: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // البحث عن صالونات حسب نوع الخدمة
  Future<List<Salon>> getSalonsByService(String serviceCategory, String serviceName) async {
    _isLoading = true;
    notifyListeners();

    try {
      // في بيئة الإنتاج، سنستدعي API حقيقي
      // مثال: final result = await ApiService().getSalonsByService(serviceCategory);

      // بحث في البيانات المحلية
      await Future.delayed(const Duration(milliseconds: 800));

      final filteredSalons = getMockSalons().where((salon) {
        return salon.services.any((service) =>
        service.category == serviceCategory ||
            service.name.contains(serviceName)
        );
      }).toList();

      _error = '';
      _isLoading = false;
      notifyListeners();

      return filteredSalons;
    } catch (e) {
      _error = 'حدث خطأ أثناء البحث عن الصالونات';
      print('Error getting salons by service: $e');
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

  // جلب تفاصيل صالون معين
  Future<void> getSalonDetails(int salonId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // في بيئة الإنتاج، سنستدعي API حقيقي
      // مثال: final result = await ApiService().getSalonDetails(salonId);

      // البحث في البيانات المحلية
      await Future.delayed(const Duration(milliseconds: 800));
      _selectedSalon = getMockSalons().firstWhere((salon) => salon.id == salonId);
      _error = '';
    } catch (e) {
      _error = 'حدث خطأ أثناء جلب تفاصيل الصالون';
      print('Error fetching salon details: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // تبديل حالة المفضلة
  void toggleFavorite(int salonId) {
    final index = _salons.indexWhere((salon) => salon.id == salonId);
    if (index != -1) {
      final salon = _salons[index];
      _salons[index] = Salon(
        id: salon.id,
        name: salon.name,
        address: salon.address,
        description: salon.description,
        imageUrl: salon.imageUrl,
        rating: salon.rating,
        reviewsCount: salon.reviewsCount,
        latitude: salon.latitude,
        longitude: salon.longitude,
        staff: salon.staff,
        services: salon.services,
        isFavorite: !salon.isFavorite,
      );

      // تحديث الصالون المحدد إذا كان هو نفسه
      if (_selectedSalon?.id == salonId) {
        _selectedSalon = _salons[index];
      }

      // في بيئة الإنتاج، سنرسل هذا التغيير إلى الخادم
      // مثال: ApiService().toggleFavorite(salonId, _salons[index].isFavorite);

      notifyListeners();
    }
  }
}