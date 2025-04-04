import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_booking_app/models/salon.dart';
import 'package:salon_booking_app/models/service.dart';
import 'package:salon_booking_app/providers/salons_provider.dart';
import 'package:salon_booking_app/screens/Salon/salon_details.dart';
import 'package:salon_booking_app/theme.dart';
import 'package:salon_booking_app/widgets/salon_card.dart';

class ServiceSalonsScreen extends StatefulWidget {
  final String serviceCategory;
  final String serviceName;

  const ServiceSalonsScreen({
    Key? key,
    required this.serviceCategory,
    required this.serviceName,
  }) : super(key: key);

  @override
  State<ServiceSalonsScreen> createState() => _ServiceSalonsScreenState();
}

class _ServiceSalonsScreenState extends State<ServiceSalonsScreen> {
  List<Salon> _filteredSalons = [];
  bool _isLoading = true;

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
      // في بيئة حقيقية، هنا سنستدعي API لجلب الصالونات حسب نوع الخدمة
      // مثال: final salons = await ApiService().getSalonsByService(widget.serviceCategory);

      // استخدام البيانات المحلية للتجربة
      await Future.delayed(const Duration(milliseconds: 800));

      final salonsProvider = Provider.of<SalonsProvider>(context, listen: false);
      await salonsProvider.fetchSalons();

      // تصفية الصالونات حسب نوع الخدمة
      final allSalons = salonsProvider.salons;
      _filteredSalons = allSalons.where((salon) {
        return salon.services.any((service) =>
        service.category == widget.serviceCategory ||
            service.name.contains(widget.serviceName)
        );
      }).toList();
    } catch (e) {
      // معالجة الخطأ
      print('Error loading salons: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('صالونات ${widget.serviceName}'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredSalons.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'لم نعثر على صالونات تقدم خدمة "${widget.serviceName}"',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('العودة للرئيسية'),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _loadSalons,
        child: CustomScrollView(
          slivers: [
            // معلومات عن الخدمة
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'صالونات تقدم خدمة: ${widget.serviceName}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _getServiceIcon(widget.serviceCategory),
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'عدد الصالونات: ${_filteredSalons.length}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // قائمة الصالونات
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final salon = _filteredSalons[index];

                  // البحث عن معلومات الخدمة في هذا الصالون
                  final serviceInfo = salon.services.firstWhere(
                        (service) =>
                    service.category == widget.serviceCategory ||
                        service.name.contains(widget.serviceName),
                    orElse: () => salon.services.first,
                  );

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SalonCard(
                          salon: salon,
                          onTap: () => _goToSalonDetails(salon),
                          onFavoriteTap: () {
                            Provider.of<SalonsProvider>(context, listen: false)
                                .toggleFavorite(salon.id);
                            setState(() {});
                          },
                        ),
                        // معلومات الخدمة في هذا الصالون
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'السعر: ${serviceInfo.price} ر.س',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'المدة: ${serviceInfo.durationMinutes} دقيقة',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                  );
                },
                childCount: _filteredSalons.length,
              ),
            ),

            // المساحة الإضافية في النهاية
            const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
          ],
        ),
      ),
    );
  }

  IconData _getServiceIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'الشعر':
        return Icons.content_cut;
      case 'صبغة':
        return Icons.color_lens;
      case 'المكياج':
        return Icons.face;
      case 'عناية بالبشرة':
        return Icons.spa;
      case 'العناية بالأظافر':
        return Icons.brush;
      case 'حمام مغربي':
        return Icons.water;
      default:
        return Icons.spa;
    }
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