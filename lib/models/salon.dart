import 'package:salon_booking_app/models/service.dart';
import 'package:salon_booking_app/models/staff.dart';

class Salon {
  final int id;
  final String name;
  final String address;
  final String description;
  final String imageUrl;
  final double rating;
  final int reviewsCount;
  final double latitude;
  final double longitude;
  final List<Staff> staff;
  final List<Service> services;
  final bool isFavorite;

  Salon({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.reviewsCount,
    required this.latitude,
    required this.longitude,
    required this.staff,
    required this.services,
    this.isFavorite = false,
  });

  // محول من JSON
  factory Salon.fromJson(Map<String, dynamic> json) {
    return Salon(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      description: json['description'],
      imageUrl: json['image_url'],
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewsCount: json['reviews_count'] ?? 0,
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      staff: (json['staff'] as List?)
          ?.map((s) => Staff.fromJson(s))
          .toList() ??
          [],
      services: (json['services'] as List?)
          ?.map((s) => Service.fromJson(s))
          .toList() ??
          [],
      isFavorite: json['is_favorite'] ?? false,
    );
  }
}

// نموذج من أجل التصور فقط - بيانات تجريبية
List<Salon> getMockSalons() {
  return [
    Salon(
      id: 1,
      name: 'صالون ليالي',
      address: 'شارع الإرسال، رام الله',
      description: 'صالون متميز للعناية بالشعر والبشرة بأحدث التقنيات وأيدي خبيرة',
      imageUrl: 'assets/images/salons/salon1.jpg',
      rating: 4.9,
      reviewsCount: 320,
      latitude: 31.9074, // إحداثيات رام الله
      longitude: 35.2042,
      staff: getMockStaff(),
      services: getMockServices(),
      isFavorite: true,
    ),
    Salon(
      id: 2,
      name: 'صالون روز',
      address: 'دوار المنارة، رام الله',
      description: 'صالون متخصص بالتجميل والمكياج الاحترافي مع خدمة متميزة',
      imageUrl: 'assets/images/salons/salon2.jpg',
      rating: 4.7,
      reviewsCount: 215,
      latitude: 31.9055, // إحداثيات قريبة من المنارة
      longitude: 35.2033,
      staff: getMockStaff(),
      services: getMockServices(),
    ),
    Salon(
      id: 3,
      name: 'صالون لمسات',
      address: 'الطيرة، رام الله',
      description: 'أحدث صيحات التجميل والعناية بالشعر مع خدمة VIP',
      imageUrl: 'assets/images/salons/salon3.jpg',
      rating: 4.8,
      reviewsCount: 189,
      latitude: 31.9100, // إحداثيات الطيرة
      longitude: 35.1900,
      staff: getMockStaff(),
      services: getMockServices(),
    ),

  ];
}