// lib/models/service_category.dart
import 'package:flutter/material.dart';
import 'package:salon_booking_app/models/service.dart';

class ServiceCategory {
  final int id;
  final String name;
  final IconData icon;
  final List<Service> services;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.services,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['id'],
      name: json['name'],
      icon: _getIconFromString(json['icon']),
      services: (json['services'] as List)
          .map((service) => Service.fromJson(service))
          .toList(),
    );
  }

  static IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'haircut':
        return Icons.content_cut;
      case 'facial':
        return Icons.face;
      case 'massage':
        return Icons.spa;
      case 'manicure':
        return Icons.colorize;
      case 'makeup':
        return Icons.face_retouching_natural;
      default:
        return Icons.spa;
    }
  }
}