import 'package:geolocator/geolocator.dart';

class LocationService {
  // الحصول على الموقع الحالي
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // التحقق مما إذا كانت خدمات الموقع ممكّنة
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('خدمات الموقع غير ممكّنة');
    }

    // التحقق من صلاحيات الموقع
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('تم رفض صلاحيات الموقع');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('تم رفض صلاحيات الموقع بشكل دائم ولا يمكن طلبها مرة أخرى');
    }

    // الحصول على الموقع الحالي
    return await Geolocator.getCurrentPosition();
  }

  // حساب المسافة بين نقطتين (بالكيلومتر)
  double calculateDistance(
      double startLatitude,
      double startLongitude,
      double endLatitude,
      double endLongitude,
      ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    ) / 1000; // تحويل من متر إلى كيلومتر
  }
}