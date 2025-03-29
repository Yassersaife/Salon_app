import 'package:flutter/material.dart';
import 'package:salon_booking_app/models/salon.dart';
import 'package:salon_booking_app/theme.dart';

class SalonCard extends StatelessWidget {
  final Salon salon;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const SalonCard({
    Key? key,
    required this.salon,
    required this.onTap,
    required this.onFavoriteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة الصالون
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    salon.imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150,
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.error)),
                      );
                    },
                  ),
                ),
                // زر المفضلة
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    child: IconButton(
                      icon: Icon(
                        salon.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: salon.isFavorite ? Colors.red : null,
                      ),
                      onPressed: onFavoriteTap,
                      iconSize: 20,
                    ),
                  ),
                ),
              ],
            ),

            // تفاصيل الصالون
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '${salon.rating}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${salon.reviewsCount})',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        salon.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Spacer(),
                      Icon(Icons.location_on, color: AppColors.primary, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        salon.address,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'احجز الآن',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      // أيقونات الخدمات المتوفرة
                      Row(
                        children: _buildServiceIcons(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildServiceIcons() {
    // نعرض رموز للخدمات المتاحة (بحد أقصى 3)
    final serviceCategories = salon.services
        .map((service) => service.category)
        .toSet() // إزالة التكرار
        .take(3) // أخذ أول 3 فقط
        .toList();

    return serviceCategories.map((category) {
      IconData icon;
      switch (category.toLowerCase()) {
        case 'الشعر':
          icon = Icons.content_cut;
          break;
        case 'المكياج':
          icon = Icons.face;
          break;
        case 'العناية بالبشرة':
          icon = Icons.spa;
          break;
        case 'العناية بالأظافر':
          icon = Icons.brush;
          break;
        default:
          icon = Icons.spa;
      }

      return Container(
        margin: const EdgeInsets.only(right: 4),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.lightPurple,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 16,
        ),
      );
    }).toList();
  }
}