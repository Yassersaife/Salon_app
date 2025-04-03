import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_booking_app/models/salon.dart';
import 'package:salon_booking_app/providers/salons_provider.dart';
import 'package:salon_booking_app/screens/salon_details.dart';
import 'package:salon_booking_app/theme.dart';
import 'package:salon_booking_app/widgets/salon_card.dart';

class SearchResultsScreen extends StatefulWidget {
  final String query;

  const SearchResultsScreen({Key? key, required this.query}) : super(key: key);

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  bool _isLoading = true;
  List<Salon> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.query;
    _searchQuery = widget.query;
    _searchSalons();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchSalons() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // تأكد من تحميل الصالونات
      final salonsProvider = Provider.of<SalonsProvider>(context, listen: false);
      if (salonsProvider.salons.isEmpty) {
        await salonsProvider.fetchSalons();
      }

      // البحث في الصالونات المحملة
      _performSearch(_searchQuery);
    } catch (e) {
      print('Error searching salons: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _performSearch(String query) {
    final salonsProvider = Provider.of<SalonsProvider>(context, listen: false);

    // البحث في الصالونات حسب الاسم أو العنوان أو الخدمات
    final results = salonsProvider.salons.where((salon) {
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

    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نتائج البحث'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'ابحث عن صالون أو خدمة...',
                hintStyle: TextStyle(color: AppColors.textLight),
                prefixIcon: Icon(Icons.search, color: AppColors.textLight),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = "";
                    });
                    _performSearch("");
                  },
                )
                    : null,
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _performSearch(value);
              },
              onChanged: (value) {
                // يمكنك تفعيل البحث المباشر هنا إذا أردت
                // _performSearch(value);
              },
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // معلومات عن نتائج البحث
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'عدد النتائج: ${_searchResults.length}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  Text(
                    'نتائج البحث عن: "$_searchQuery"',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),

          // عرض نتائج البحث
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                ? Center(
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
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final salon = _searchResults[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
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