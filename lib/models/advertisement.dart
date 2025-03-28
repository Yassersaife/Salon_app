class Advertisement {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String targetUrl;
  final DateTime startDate;
  final DateTime endDate;
  final int salonId; // معرف الصالون المرتبط بالإعلان (إن وجد)

  Advertisement({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.targetUrl,
    required this.startDate,
    required this.endDate,
    this.salonId = 0, // 0 يعني أنه لا يوجد صالون مرتبط
  });

  // محول من JSON
  factory Advertisement.fromJson(Map<String, dynamic> json) {
    return Advertisement(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      imageUrl: json['image_url'],
      targetUrl: json['target_url'] ?? '',
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      salonId: json['salon_id'] ?? 0,
    );
  }
}

// بيانات تجريبية للإعلانات
List<Advertisement> getMockAdvertisements() {
  return [
    Advertisement(
      id: 1,
      title: 'خصم 30% على خدمات قص الشعر',
      description: 'استمتعي بخصم حصري 30% على جميع خدمات قص وتصفيف الشعر خلال شهر رمضان',
      imageUrl: 'https://example.com/images/ad1.jpg',
      targetUrl: '/promo/haircut',
      startDate: DateTime.now().subtract(const Duration(days: 5)),
      endDate: DateTime.now().add(const Duration(days: 25)),
      salonId: 1,
    ),
    Advertisement(
      id: 2,
      title: 'باقة العروس الكاملة',
      description: 'باقة متكاملة للعروس تشمل المكياج والشعر والعناية بالبشرة والأظافر',
      imageUrl: 'https://example.com/images/ad2.jpg',
      targetUrl: '/promo/bride',
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      endDate: DateTime.now().add(const Duration(days: 20)),
      salonId: 2,
    ),
    Advertisement(
      id: 3,
      title: 'احصلي على جلسة مجانية',
      description: 'احصلي على جلسة عناية بالبشرة مجانية عند حجز أي خدمة هذا الأسبوع',
      imageUrl: 'https://example.com/images/ad3.jpg',
      targetUrl: '/promo/free-session',
      startDate: DateTime.now().subtract(const Duration(days: 2)),
      endDate: DateTime.now().add(const Duration(days: 5)),
      salonId: 3,
    ),
  ];
}