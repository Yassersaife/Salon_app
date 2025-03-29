import 'package:flutter/foundation.dart';
import 'package:salon_booking_app/models/booking.dart';
import 'package:salon_booking_app/services/api_service.dart';

enum BookingStatus { initial, loading, success, error }

class BookingProvider with ChangeNotifier {
  List<Booking> _bookings = [];
  BookingStatus _status = BookingStatus.initial;
  String _errorMessage = '';

  // جلب البيانات
  List<Booking> get bookings => _bookings;
  BookingStatus get status => _status;
  String get errorMessage => _errorMessage;

  // جلب الحجوزات الخاصة بالمستخدم
  Future<void> fetchUserBookings() async {
    _status = BookingStatus.loading;
    notifyListeners();

    try {
      // في بيئة الإنتاج، سنستدعي API حقيقي
      // مثال: final result = await ApiService().getUserBookings();

      // استخدام بيانات وهمية للتجربة
      await Future.delayed(const Duration(seconds: 1));
      _bookings = getMockBookings();
      _status = BookingStatus.success;
    } catch (e) {
      _status = BookingStatus.error;
      _errorMessage = 'حدث خطأ أثناء جلب الحجوزات';
      print('Error fetching bookings: $e');
    }
    notifyListeners();
  }

  // إنشاء حجز جديد
  Future<bool> createBooking({
    required int salonId,
    required String salonName,
    required String salonImage,
    required int serviceId,
    required String serviceName,
    required double servicePrice,
    required int staffId,
    required String staffName,
    required DateTime appointmentDateTime,
    required int durationMinutes,
  }) async {
    _status = BookingStatus.loading;
    notifyListeners();

    try {
      // في بيئة الإنتاج، سنستدعي API حقيقي
      // مثال: final result = await ApiService().createBooking(bookingData);

      // محاكاة إنشاء حجز جديد
      await Future.delayed(const Duration(seconds: 1));

      // إضافة الحجز الجديد للقائمة
      final newBooking = Booking(
        id: _bookings.isEmpty ? 1 : _bookings.map((b) => b.id).reduce((a, b) => a > b ? a : b) + 1,
        salonId: salonId,
        salonName: salonName,
        salonImage: salonImage,
        serviceId: serviceId,
        serviceName: serviceName,
        servicePrice: servicePrice,
        staffId: staffId,
        staffName: staffName,
        appointmentDateTime: appointmentDateTime,
        durationMinutes: durationMinutes,
        status: 'pending',
        createdAt: DateTime.now(),
      );

      _bookings.add(newBooking);
      _status = BookingStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _status = BookingStatus.error;
      _errorMessage = 'حدث خطأ أثناء إنشاء الحجز';
      print('Error creating booking: $e');
      notifyListeners();
      return false;
    }
  }

  // إلغاء حجز
  Future<bool> cancelBooking(int bookingId) async {
    _status = BookingStatus.loading;
    notifyListeners();

    try {
      // في بيئة الإنتاج، سنستدعي API حقيقي
      // مثال: final result = await ApiService().cancelBooking(bookingId);

      // محاكاة إلغاء الحجز
      await Future.delayed(const Duration(milliseconds: 800));

      final index = _bookings.indexWhere((booking) => booking.id == bookingId);
      if (index != -1) {
        final booking = _bookings[index];
        _bookings[index] = Booking(
          id: booking.id,
          salonId: booking.salonId,
          salonName: booking.salonName,
          salonImage: booking.salonImage,
          serviceId: booking.serviceId,
          serviceName: booking.serviceName,
          servicePrice: booking.servicePrice,
          staffId: booking.staffId,
          staffName: booking.staffName,
          appointmentDateTime: booking.appointmentDateTime,
          durationMinutes: booking.durationMinutes,
          status: 'cancelled',
          createdAt: booking.createdAt,
        );

        _status = BookingStatus.success;
        notifyListeners();
        return true;
      } else {
        throw Exception('الحجز غير موجود');
      }
    } catch (e) {
      _status = BookingStatus.error;
      _errorMessage = 'حدث خطأ أثناء إلغاء الحجز';
      print('Error cancelling booking: $e');
      notifyListeners();
      return false;
    }
  }

  // فلترة الحجوزات حسب الحالة
  List<Booking> getFilteredBookings(String status) {
    if (status.isEmpty) {
      return _bookings;
    }
    return _bookings.where((booking) => booking.status == status).toList();
  }

  // الحجوزات القادمة
  List<Booking> get upcomingBookings {
    return _bookings.where((booking) =>
    booking.status == 'pending' ||
        booking.status == 'confirmed'
    ).toList();
  }

  // الحجوزات السابقة
  List<Booking> get pastBookings {
    return _bookings.where((booking) =>
    booking.status == 'completed' ||
        booking.status == 'cancelled'
    ).toList();
  }
}