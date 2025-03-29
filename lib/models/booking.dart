class Booking {
  final int id;
  final int salonId;
  final String salonName;
  final String salonImage;
  final int serviceId;
  final String serviceName;
  final double servicePrice;
  final int staffId;
  final String staffName;
  final DateTime appointmentDateTime;
  final int durationMinutes;
  final String status; // pending, confirmed, completed, cancelled
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.salonId,
    required this.salonName,
    required this.salonImage,
    required this.serviceId,
    required this.serviceName,
    required this.servicePrice,
    required this.staffId,
    required this.staffName,
    required this.appointmentDateTime,
    required this.durationMinutes,
    required this.status,
    required this.createdAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      salonId: json['salon_id'],
      salonName: json['salon_name'],
      salonImage: json['salon_image'] ?? '',
      serviceId: json['service_id'],
      serviceName: json['service_name'],
      servicePrice: json['service_price']?.toDouble() ?? 0.0,
      staffId: json['staff_id'],
      staffName: json['staff_name'],
      appointmentDateTime: DateTime.parse(json['appointment_date_time']),
      durationMinutes: json['duration_minutes'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'salon_id': salonId,
      'service_id': serviceId,
      'staff_id': staffId,
      'appointment_date_time': appointmentDateTime.toIso8601String(),
    };
  }
}

// بيانات تجريبية للحجوزات
List<Booking> getMockBookings() {
  return [
    Booking(
      id: 1,
      salonId: 1,
      salonName: 'صالون ليالي',
      salonImage: 'assets/images/salons/salon1.jpg',
      serviceId: 1,
      serviceName: 'قص شعر + سشوار',
      servicePrice: 120.0,
      staffId: 1,
      staffName: 'سارة',
      appointmentDateTime: DateTime.now().add(const Duration(days: 2)),
      durationMinutes: 45,
      status: 'confirmed',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Booking(
      id: 2,
      salonId: 2,
      salonName: 'صالون روز',
      salonImage: 'assets/images/salons/salon2.jpg',
      serviceId: 3,
      serviceName: 'مكياج سهرة',
      servicePrice: 250.0,
      staffId: 2,
      staffName: 'نوف',
      appointmentDateTime: DateTime.now().add(const Duration(days: 5)),
      durationMinutes: 60,
      status: 'pending',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Booking(
      id: 3,
      salonId: 1,
      salonName: 'صالون ليالي',
      salonImage: 'assets/images/salons/salon1.jpg',
      serviceId: 4,
      serviceName: 'تنظيف بشرة عميق',
      servicePrice: 180.0,
      staffId: 3,
      staffName: 'ليلى',
      appointmentDateTime: DateTime.now().subtract(const Duration(days: 3)),
      durationMinutes: 90,
      status: 'completed',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];
}