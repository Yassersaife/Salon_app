import 'package:flutter/material.dart';
import 'package:salon_booking_app/models/product.dart';
import 'package:salon_booking_app/theme.dart';

class ProductCategoryItem extends StatelessWidget {
  final ProductCategory category;

  const ProductCategoryItem({Key? key, required this.category}) : super(key: key);

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName) {
      case 'العناية بالشعر':
        return Icons.face_retouching_natural;
      case 'المكياج':
        return Icons.brush;
      case 'العناية بالبشرة':
        return Icons.spa;
      case 'العناية بالأظافر':
        return Icons.back_hand;
      case 'العطور':
        return Icons.water_drop;
      case 'أدوات تصفيف الشعر':
        return Icons.face;
      default:
        return Icons.category;
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