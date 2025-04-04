import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_booking_app/models/salon.dart';
import 'package:salon_booking_app/providers/salons_provider.dart';
import 'package:salon_booking_app/screens/Salon/salon_details.dart';
import 'package:salon_booking_app/theme.dart';

class FavoriteSalonsScreen extends StatefulWidget {
  const FavoriteSalonsScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteSalonsScreen> createState() => _FavoriteSalonsScreenState();
}

class _FavoriteSalonsScreenState extends State<FavoriteSalonsScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteSalons();
  }

  Future<void> _loadFavoriteSalons() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // استدعاء مزود الصالونات لجلب البيانات
      await Provider.of<SalonsProvider>(context, listen: false).fetchSalons();
    } catch (e) {
      // معالجة الخطأ
      print('Error loading favorite salons: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // الحصول على قائمة الصالونات المفضلة فقط
  List<Salon> _getFavoriteSalons(List<Salon> salons) {
    return salons.where((salon) => salon.isFavorite).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('صالوناتي المفضلة'),
      ),
      body: Consumer<SalonsProvider>(
        builder: (context, salonsProvider, child) {
          if (_isLoading || salonsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (salonsProvider.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(salonsProvider.error),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadFavoriteSalons,
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          final favoriteSalons = _getFavoriteSalons(salonsProvider.salons);

          // عرض رسالة عند عدم وجود صالونات مفضلة
          if (favoriteSalons.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 70,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'لا توجد صالونات مفضلة',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Text('استعرض الصالونات'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadFavoriteSalons,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // معلومات عن عدد الصالونات المفضلة
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'عدد الصالونات المفضلة: ${favoriteSalons.length}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),

                // شبكة الصالونات المفضلة
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // عدد الأعمدة
                      childAspectRatio: 0.7, // نسبة العرض إلى الارتفاع
                      crossAxisSpacing: 10, // المسافة الأفقية بين العناصر
                      mainAxisSpacing: 10, // المسافة الرأسية بين العناصر
                    ),
                    itemCount: favoriteSalons.length,
                    itemBuilder: (context, index) {
                      final salon = favoriteSalons[index];
                      return _buildSalonGridItem(salon);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSalonGridItem(Salon salon) {
    return GestureDetector(
      onTap: () => _goToSalonDetails(salon),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة الصالون
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    salon.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.error)),
                      );
                    },
                  ),
                ),
                // زر المفضلة
                Positioned(
                  top: 5,
                  left: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 18,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 30,
                        minHeight: 30,
                      ),
                      onPressed: () {
                        Provider.of<SalonsProvider>(context, listen: false)
                            .toggleFavorite(salon.id);
                        // إعادة بناء الشاشة بعد إزالة من المفضلة
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ],
            ),

            // تفاصيل الصالون
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    salon.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        salon.address,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.location_on,
                        color: AppColors.primary,
                        size: 12,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '(${salon.reviewsCount})',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${salon.rating}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 14,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 24,
                        child: ElevatedButton(
                          onPressed: () => _goToSalonDetails(salon),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'احجز الآن',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
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

  void _goToSalonDetails(Salon salon) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SalonDetailsScreen(salonId: salon.id),
      ),
    );
  }
}