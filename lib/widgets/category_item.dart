import 'package:flutter/material.dart';
import 'package:salon_booking_app/theme.dart';
import '../models/service.dart';

class CategoryItem extends StatelessWidget {
  final ServiceCategory category;

  const CategoryItem({Key? key, required this.category}) : super(key: key);

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName) {
      case 'قص شعر':
        return Icons.content_cut;
      case 'صبغة':
        return Icons.color_lens;
      case 'مكياج':
        return Icons.face;
      case 'عناية بالبشرة':
        return Icons.spa;
      case 'منيكير':
        return Icons.brush;
      case 'حمام مغربي':
        return Icons.water;
      default:
        return Icons.spa;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.lightPurple,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Icon(
                _getCategoryIcon(category.name),
                color: AppColors.primary,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
