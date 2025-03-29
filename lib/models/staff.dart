class Staff {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> specialties;
  final double rating;
  final int reviewsCount;

  Staff({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.specialties,
    required this.rating,
    required this.reviewsCount,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'] ?? '',
      specialties: (json['specialties'] as List?)?.map((e) => e.toString()).toList() ?? [],
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewsCount: json['reviews_count'] ?? 0,
    );
  }
}

// بيانات تجريبية للموظفين
List<Staff> getMockStaff() {
  return [
    Staff(
      id: 1,
      name: 'سارة',
      imageUrl: 'assets/images/staff/staff1.jpg',
      specialties: ['قص شعر', 'صبغة'],
      rating: 4.9,
      reviewsCount: 120,
    ),
    Staff(
      id: 2,
      name: 'نوف',
      imageUrl: 'assets/images/staff/staff2.jpg',
      specialties: ['مكياج', 'تسريحات شعر'],
      rating: 4.8,
      reviewsCount: 98,
    ),
    Staff(
      id: 3,
      name: 'ليلى',
      imageUrl: 'assets/images/staff/staff3.jpg',
      specialties: ['عناية بالبشرة', 'عناية باليدين'],
      rating: 4.7,
      reviewsCount: 85,
    ),
  ];
}