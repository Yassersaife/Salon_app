import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_booking_app/models/salon.dart';
import 'package:salon_booking_app/providers/salons_provider.dart';
import 'package:salon_booking_app/providers/user_provider.dart';
import 'package:salon_booking_app/providers/advertisements_provider.dart';
import 'package:salon_booking_app/screens/all_salons_screen.dart';
import 'package:salon_booking_app/screens/map_screen.dart';
import 'package:salon_booking_app/screens/my_bookings_screen.dart';
import 'package:salon_booking_app/screens/profile_screen.dart';
import 'package:salon_booking_app/screens/salon_details.dart';
import 'package:salon_booking_app/screens/service_salons_screen.dart';
import 'package:salon_booking_app/theme.dart';
import 'package:salon_booking_app/widgets/advertisement_card.dart';
import 'package:salon_booking_app/widgets/bottom_nav_bar.dart';
import 'package:salon_booking_app/widgets/category_item.dart';
import 'package:salon_booking_app/widgets/salon_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // إنشاء قائمة الصفحات داخل دالة build لتجنب استخدام الدوال كعنصر ثابت خارج الدالة
    final List<Widget> pages = [
      _buildBody(),
      const MapScreen(),
      const MyBookingsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: SleekBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildBody() {
    // محتوى الصفحة الرئيسية باستخدام Consumer لمزودي الصالونات والمستخدم
    return Consumer<SalonsProvider>(
      builder: (context, salonsProvider, child) {
        return Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            print("User name: ${userProvider.currentUser?.name}");

            return CustomScrollView(
              slivers: [
                // شريط التطبيق المخصص
                SliverAppBar(
                  expandedHeight: 200,
                  floating: false,  // تم تغييره إلى false لضمان سلوك أفضل
                  pinned: true,
                  backgroundColor: Colors.transparent, // تغيير لإظهار الخلفية بشكل صحيح
                  elevation: 0,
                  stretch: true, // إضافة خاصية للتمدد
                  collapsedHeight: 80, // تحديد ارتفاع للحالة المطوية
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax, // إضافة تأثير التوازي عند التمرير
                    titlePadding: EdgeInsets.zero, // إزالة الهوامش للعنوان
                    background: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        // يمكنك إضافة تدرج لوني أو صورة خلفية هنا
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.primary.withOpacity(0.8),
                            AppColors.primary,
                          ],
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              SizedBox(height: 16), // مسافة من الأعلى
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24, // زيادة حجم الصورة الشخصية
                                    backgroundColor: Colors.white,
                                    backgroundImage: userProvider.currentUser?.imageUrl != null
                                        ? AssetImage(userProvider.currentUser!.imageUrl!)
                                        : null,
                                    child: userProvider.currentUser?.imageUrl == null
                                        ? const Icon(Icons.person)
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'أهلاً ${userProvider.currentUser?.name ?? ''}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18, // زيادة حجم الخط
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text(
                                          'اكتشف صالونات التجميل القريبة منك',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                                      onPressed: () {
                                        // هنا يمكنك تنفيذ ما يلزم للإشعارات
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // حقل البحث منفصل عن الخلفية
                    title: Container(
                      height: 60,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: Offset(0, -3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: TextField(
                          controller: _searchController,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            hintText: 'ابحث عن صالون أو خدمة...',
                            hintStyle: TextStyle(color: AppColors.textLight),
                            prefixIcon: Icon(Icons.search, color: AppColors.textLight),
                            filled: true,
                            fillColor: Colors.grey[100],
                            contentPadding: const EdgeInsets.symmetric(vertical: 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {
                            salonsProvider.searchSalons(value);
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // إضافة قسم الإعلانات المتحركة في الشاشة الرئيسية

// Carousel الإعلانات
                SliverToBoxAdapter(
                  child: Consumer<AdvertisementsProvider>(
                    builder: (context, adsProvider, child) {
                      if (adsProvider.isLoading) {
                        return const SizedBox(
                          height: 180,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final activeAds = adsProvider.getActiveAdvertisements();

                      if (activeAds.isEmpty) {
                        return const SizedBox(); // لا نعرض شيئًا إذا لم تكن هناك إعلانات
                      }

                      return AdsCarousel(advertisements: activeAds);
                    },
                  ),
                ),
                // فئات الخدمات
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'الخدمات المميزة',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // عرض كل الفئات
                          },
                          child: Text(
                            'عرض الكل',
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // قائمة الفئات أفقية
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 120,
                    child: salonsProvider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: salonsProvider.categories.length,
                      itemBuilder: (context, index) {
                        final category = salonsProvider.categories[index];
                        return GestureDetector(
                            onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServiceSalonsScreen(
                                serviceCategory: category.name,
                                serviceName: category.name,
                              ),
                            ),
                          );
                        },
                        child: CategoryItem(category: category),
                        );
                        },
                    ),
                  ),
                ),

                // عنوان قسم الصالونات
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'صالونات التجميل القريبة',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // عرض كل الصالونات
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AllSalonsGridScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'عرض الكل',
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // قائمة الصالونات
                salonsProvider.isLoading
                    ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
                    : salonsProvider.salons.isEmpty
                    ? const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'لا توجد صالونات قريبة منك',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
                    : SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final salon = salonsProvider.salons[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: SalonCard(
                          salon: salon,
                          onTap: () => _goToSalonDetails(salon),
                          onFavoriteTap: () {
                            salonsProvider.toggleFavorite(salon.id);
                          },
                        ),
                      );
                    },
                    childCount: salonsProvider.salons.length,
                  ),
                ),

                // مسافة إضافية في النهاية
                const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
              ],
            );
          },
        );
      },
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
