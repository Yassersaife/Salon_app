import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_booking_app/models/salon.dart';
import 'package:salon_booking_app/providers/salons_provider.dart';
import 'package:salon_booking_app/screens/salon_details.dart';
import 'package:salon_booking_app/theme.dart';

class AllSalonsGridScreen extends StatefulWidget {
  const AllSalonsGridScreen({Key? key}) : super(key: key);

  @override
  State<AllSalonsGridScreen> createState() => _AllSalonsGridScreenState();
}

class _AllSalonsGridScreenState extends State<AllSalonsGridScreen> {
  bool _isLoading = false;
  String _sortBy = 'rating'; // التصنيف الافتراضي حسب التقييم

  @override
  void initState() {
    super.initState();
    _loadSalons();
  }

  Future<void> _loadSalons() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // استدعاء مزود الصالونات لجلب البيانات
      await Provider.of<SalonsProvider>(context, listen: false).fetchSalons();
    } catch (e) {
      // معالجة الخطأ
      print('Error loading salons: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Salon> _getSortedSalons(List<Salon> salons) {
    // نسخة من القائمة لتجنب تعديل القائمة الأصلية
    final sortedSalons = List<Salon>.from(salons);

    switch (_sortBy) {
      case 'rating':
      // ترتيب حسب التقييم (من الأعلى للأدنى)
        sortedSalons.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'reviews':
      // ترتيب حسب عدد التقييمات (من الأعلى للأدنى)
        sortedSalons.sort((a, b) => b.reviewsCount.compareTo(a.reviewsCount));
        break;
      case 'name':
      // ترتيب حسب الاسم (من أ إلى ي)
        sortedSalons.sort((a, b) => a.name.compareTo(b.name));
        break;
    }

    return sortedSalons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('جميع الصالونات'),
        actions: [
          // قائمة الترتيب
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'rating',
                child: Text('الترتيب حسب التقييم'),
              ),
              const PopupMenuItem(
                value: 'reviews',
                child: Text('الترتيب حسب عدد التقييمات'),
              ),
              const PopupMenuItem(
                value: 'name',
                child: Text('الترتيب حسب الاسم'),
              ),
            ],
          ),
        ],
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
                    onPressed: _loadSalons,
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          final sortedSalons = _getSortedSalons(salonsProvider.salons);

          return RefreshIndicator(
            onRefresh: _loadSalons,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // معلومات عن الترتيب الحالي
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.sort, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            _sortBy == 'rating'
                                ? 'الترتيب حسب التقييم'
                                : _sortBy == 'reviews'
                                ? 'الترتيب حسب عدد التقييمات'
                                : 'الترتيب حسب الاسم',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'عدد الصالونات: ${sortedSalons.length}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // شبكة الصالونات
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // عدد الأعمدة
                      childAspectRatio: 0.7, // نسبة العرض إلى الارتفاع
                      crossAxisSpacing: 10, // المسافة الأفقية بين العناصر
                      mainAxisSpacing: 10, // المسافة الرأسية بين العناصر
                    ),
                    itemCount: sortedSalons.length,
                    itemBuilder: (context, index) {
                      final salon = sortedSalons[index];
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
                  child: Image.network(
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
                      icon: Icon(
                        salon.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: salon.isFavorite ? Colors.red : null,
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