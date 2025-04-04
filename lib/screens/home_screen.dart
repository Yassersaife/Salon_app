import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_booking_app/models/salon.dart';
import 'package:salon_booking_app/providers/salons_provider.dart';
import 'package:salon_booking_app/providers/user_provider.dart';
import 'package:salon_booking_app/providers/advertisements_provider.dart';
import 'package:salon_booking_app/screens/Salon/all_salons_screen.dart';
import 'package:salon_booking_app/screens/Shop/shop_screen.dart';
import 'package:salon_booking_app/screens/map_screen.dart';
import 'package:salon_booking_app/screens/my_bookings_screen.dart';
import 'package:salon_booking_app/screens/profile_screen.dart';
import 'package:salon_booking_app/screens/Salon/salon_details.dart';
import 'package:salon_booking_app/screens/Salon/service_salons_screen.dart';
import 'package:salon_booking_app/screens/search_results_screen.dart'; // تأكد من إنشاء هذا الملف
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
  bool _isSearching = false;
  String _searchQuery = "";
  List<Salon> _searchResults = [];

  @override
  void initState() {
    super.initState();
    // تحميل الصالونات عند بدء التطبيق
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SalonsProvider>(context, listen: false).fetchSalons();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // البحث عند كتابة كل حرف
  void _performSearch(String query) {
    final salonsProvider = Provider.of<SalonsProvider>(context, listen: false);

    setState(() {
      _searchQuery = query;
      _isSearching = query.isNotEmpty;

      if (query.isEmpty) {
        _searchResults = [];
        return;
      }

      // البحث في الصالونات حسب الاسم أو العنوان أو الخدمات
      _searchResults = salonsProvider.salons.where((salon) {
        // البحث في اسم الصالون
        if (salon.name.contains(query)) {
          return true;
        }

        // البحث في عنوان الصالون
        if (salon.address.contains(query)) {
          return true;
        }

        // البحث في خدمات الصالون
        for (var service in salon.services) {
          if (service.name.contains(query) || service.category.contains(query)) {
            return true;
          }
        }

        return false;
      }).toList();
    });
  }

  // الانتقال إلى صفحة نتائج البحث المفصلة
  void _navigateToSearchResults() {
    if (_searchQuery.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsScreen(query: _searchQuery),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // إنشاء قائمة الصفحات داخل دالة build لتجنب استخدام الدوال كعنصر ثابت خارج الدالة
    final List<Widget> pages = [
      _buildBody(),
      const MapScreen(),
      const ShopScreen(),
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

            // إذا كان هناك بحث نشط، نعرض نتائج البحث
            if (_isSearching && _searchResults.isNotEmpty)
              return Column(
                children: [
                  // شريط التطبيق للبحث
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
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
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                      _searchQuery = "";
                                      _isSearching = false;
                                      _searchResults = [];
                                    });
                                  },
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: 'ابحث عن صالون أو خدمة...',
                                      hintStyle: const TextStyle(color: Colors.white70),
                                      prefixIcon: IconButton(
                                        icon: const Icon(Icons.search, color: Colors.white),
                                        onPressed: _navigateToSearchResults,
                                      ),
                                      suffixIcon: _searchController.text.isNotEmpty
                                          ? IconButton(
                                        icon: const Icon(Icons.clear, color: Colors.white),
                                        onPressed: () {
                                          setState(() {
                                            _searchController.clear();
                                            _performSearch("");
                                          });
                                        },
                                      )
                                          : null,
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.2),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(24),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    onChanged: _performSearch,
                                    onSubmitted: (_) => _navigateToSearchResults(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),

                  // نتائج البحث
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'عدد النتائج: ${_searchResults.length}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        TextButton(
                          onPressed: _navigateToSearchResults,
                          child: const Text('عرض كل النتائج'),
                        ),
                      ],
                    ),
                  ),

                  // قائمة نتائج البحث
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _searchResults.length > 5 ? 5 : _searchResults.length, // نعرض أول 5 نتائج فقط
                      itemBuilder: (context, index) {
                        final salon = _searchResults[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: SalonCard(
                            salon: salon,
                            onTap: () => _goToSalonDetails(salon),
                            onFavoriteTap: () {
                              Provider.of<SalonsProvider>(context, listen: false)
                                  .toggleFavorite(salon.id);
                              setState(() {});
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );

            // إذا كان هناك بحث نشط ولكن لا توجد نتائج
            if (_isSearching && _searchResults.isEmpty && _searchQuery.isNotEmpty)
              return Column(
                children: [
                  // شريط التطبيق للبحث
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
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
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                      _searchQuery = "";
                                      _isSearching = false;
                                      _searchResults = [];
                                    });
                                  },
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: 'ابحث عن صالون أو خدمة...',
                                      hintStyle: const TextStyle(color: Colors.white70),
                                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                                      suffixIcon: _searchController.text.isNotEmpty
                                          ? IconButton(
                                        icon: const Icon(Icons.clear, color: Colors.white),
                                        onPressed: () {
                                          setState(() {
                                            _searchController.clear();
                                            _performSearch("");
                                          });
                                        },
                                      )
                                          : null,
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.2),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(24),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    onChanged: _performSearch,
                                    onSubmitted: (_) => _navigateToSearchResults(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),

                  // رسالة لا توجد نتائج
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 70,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'لم نعثر على نتائج مطابقة لـ "$_searchQuery"',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'جرب البحث بكلمات مختلفة أو اسم صالون محدد',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );

            // العرض الرئيسي عندما لا يكون هناك بحث
            return CustomScrollView(
              slivers: [
                // شريط التطبيق المخصص
                SliverAppBar(
                  expandedHeight: 200,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  stretch: true,
                  collapsedHeight: 80,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    titlePadding: EdgeInsets.zero,
                    background: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
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
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
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
                                            fontSize: 18,
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
                          onSubmitted: (value) {
                            // الانتقال إلى صفحة البحث المفصلة عند الضغط على Enter
                            _navigateToSearchResults();
                          },
                          onChanged: (value) {
                            // البحث مباشرة أثناء الكتابة
                            _performSearch(value);
                          },
                        ),
                      ),
                    ),
                  ),
                ),

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
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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

                // قسم الصالونات القريبة منك
                _buildSectionHeader('الصالونات القريبة منك', () {
                  // عرض كل الصالونات القريبة
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllSalonsGridScreen(),
                    ),
                  );
                }),

                _buildHorizontalSalonsList(
                  salonsProvider.isLoading ? [] : _getNearbySalons(salonsProvider.salons),
                  salonsProvider.isLoading,
                ),

                // قسم الصالونات الأعلى تقييماً
                _buildSectionHeader('الصالونات الأعلى تقييماً', () {
                  // عرض كل الصالونات الأعلى تقييماً
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllSalonsGridScreen(),
                    ),
                  );
                }),

                _buildHorizontalSalonsList(
                  salonsProvider.isLoading ? [] : _getTopRatedSalons(salonsProvider.salons),
                  salonsProvider.isLoading,
                ),

                // قسم الصالونات الأكثر زيارة
                _buildSectionHeader('الصالونات الأكثر زيارة', () {
                  // عرض كل الصالونات الأكثر زيارة
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllSalonsGridScreen(),
                    ),
                  );
                }),

                _buildHorizontalSalonsList(
                  salonsProvider.isLoading ? [] : _getPopularSalons(salonsProvider.salons),
                  salonsProvider.isLoading,
                ),

                // مسافة إضافية في النهاية
                const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
              ],
            );
          },
        );
      },
    );
  }

  // عنوان قسم
  SliverToBoxAdapter _buildSectionHeader(String title, VoidCallback onTap) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Expanded(
              child: Text(
                '',
                style: TextStyle(fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: onTap,
              child: Text(
                'عرض الكل',
                style: TextStyle(color: AppColors.primary),
              ),
            ),

          ],
        ),
      ),
    );
  }

  // قائمة أفقية للصالونات
  SliverToBoxAdapter _buildHorizontalSalonsList(List<Salon> salons, bool isLoading) {
    if (isLoading) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 220,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (salons.isEmpty) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 100,
          child: Center(
            child: Text(
              'لا توجد صالونات متاحة',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 230,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: salons.length > 10 ? 10 : salons.length, // عرض أول 10 صالونات كحد أقصى
          itemBuilder: (context, index) {
            final salon = salons[index];
            return Container(
              width: 220,
              margin: const EdgeInsets.all(8),
              child: _buildHorizontalSalonCard(salon),
            );
          },
        ),
      ),
    );
  }

  // بطاقة الصالون المعروضة أفقياً
  Widget _buildHorizontalSalonCard(Salon salon) {
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

  // دوال الحصول على الصالونات حسب التصنيف
  List<Salon> _getNearbySalons(List<Salon> salons) {
    // في حالة حقيقية، هنا ستقوم بترتيب الصالونات حسب المسافة من موقع المستخدم
    // يمكنك استخدام مكتبة geolocator للحصول على موقع المستخدم وحساب المسافة
    // للتبسيط، سنقوم بترتيب عشوائي أو إرجاع نفس القائمة
    final List<Salon> result = List.from(salons);
    return result.take(10).toList();
  }

  List<Salon> _getTopRatedSalons(List<Salon> salons) {
    final List<Salon> result = List.from(salons);
    result.sort((a, b) => b.rating.compareTo(a.rating));
    return result.take(10).toList();
  }

  List<Salon> _getPopularSalons(List<Salon> salons) {
    final List<Salon> result = List.from(salons);
    result.sort((a, b) => b.reviewsCount.compareTo(a.reviewsCount));
    return result.take(10).toList();
  }
}