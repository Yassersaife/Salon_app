import 'package:flutter/foundation.dart';
import 'package:salon_booking_app/models/advertisement.dart';

class AdvertisementsProvider with ChangeNotifier {
  List<Advertisement> _advertisements = [];
  bool _isLoading = false;
  String _error = '';

  // جلب البيانات
  List<Advertisement> get advertisements => _advertisements;
  bool get isLoading => _isLoading;
  String get error => _error;

  AdvertisementsProvider() {
    // جلب الإعلانات عند إنشاء المزود
    fetchAdvertisements();
  }

  // جلب الإعلانات
  Future<void> fetchAdvertisements() async {
    _isLoading = true;
    notifyListeners();

    try {
      // في بيئة الإنتاج، سنستدعي API حقيقي
      // مثال: final result = await ApiService().getAdvertisements();

      // استخدام بيانات وهمية للتجربة
      await Future.delayed(const Duration(milliseconds: 800));
      _advertisements = getMockAdvertisements();
      _error = '';
    } catch (e) {
      _error = 'حدث خطأ أثناء جلب الإعلانات';
      print('Error fetching advertisements: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // الحصول على الإعلانات النشطة فقط (التي لم تنتهي بعد)
  List<Advertisement> getActiveAdvertisements() {
    final now = DateTime.now();
    return _advertisements.where((ad) => ad.endDate.isAfter(now)).toList();
  }
}