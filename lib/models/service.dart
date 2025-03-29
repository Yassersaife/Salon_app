class Service {
  final int id;
  final String name;
  final String description;
  final double price;
  final int durationMinutes;
  final String imageUrl;
  final String category;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationMinutes,
    required this.imageUrl,
    required this.category,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      durationMinutes: json['duration_minutes'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      category: json['category'] ?? '',
    );
  }
}

// بيانات تجريبية للخدمات
List<Service> getMockServices() {
  return [
    Service(
      id: 1,
      name: 'قص شعر + سشوار',
      description: 'قص الشعر مع تجفيف وتصفيف بالسشوار',
      price: 120.0,
      durationMinutes: 45,
      imageUrl: 'https://example.com/images/service1.jpg',
      category: 'الشعر',
    ),
    Service(
      id: 2,
      name: 'صبغة شعر كاملة',
      description: 'صبغة شعر كاملة مع اختيار اللون المناسب',
      price: 350.0,
      durationMinutes: 120,
      imageUrl: 'https://example.com/images/service2.jpg',
      category: 'الشعر',
    ),
    Service(
      id: 3,
      name: 'مكياج سهرة',
      description: 'مكياج كامل للمناسبات والسهرات',
      price: 250.0,
      durationMinutes: 60,
      imageUrl: 'https://example.com/images/service3.jpg',
      category: 'المكياج',
    ),
    Service(
      id: 4,
      name: 'تنظيف بشرة عميق',
      description: 'تنظيف عميق للبشرة مع ماسكات متخصصة',
      price: 180.0,
      durationMinutes: 90,
      imageUrl: 'https://example.com/images/service4.jpg',
      category: 'العناية بالبشرة',
    ),
    Service(
      id: 5,
      name: 'منيكير وبديكير',
      description: 'عناية كاملة بالأظافر',
      price: 140.0,
      durationMinutes: 60,
      imageUrl: 'https://example.com/images/service5.jpg',
      category: 'العناية بالأظافر',
    ),
  ];
}

// فئات الخدمات
List<ServiceCategory> getMockCategories() {
  return [
    ServiceCategory(id: 1, name: 'قص شعر', imageUrl: 'https://example.com/images/category1.jpg'),
    ServiceCategory(id: 2, name: 'صبغة', imageUrl: 'https://example.com/images/category2.jpg'),
    ServiceCategory(id: 3, name: 'مكياج', imageUrl: 'https://example.com/images/category3.jpg'),
    ServiceCategory(id: 4, name: 'عناية بالبشرة', imageUrl: 'https://example.com/images/category4.jpg'),
    ServiceCategory(id: 5, name: 'منيكير', imageUrl: 'https://example.com/images/category5.jpg'),
    ServiceCategory(id: 6, name: 'حمام مغربي', imageUrl: 'https://example.com/images/category6.jpg'),
  ];
}

class ServiceCategory {
  final int id;
  final String name;
  final String imageUrl;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}