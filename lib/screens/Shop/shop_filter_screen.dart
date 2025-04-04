import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_booking_app/providers/products_provider.dart';
import 'package:salon_booking_app/theme.dart';

class ShopFilterScreen extends StatefulWidget {
  const ShopFilterScreen({Key? key}) : super(key: key);

  @override
  State<ShopFilterScreen> createState() => _ShopFilterScreenState();
}

class _ShopFilterScreenState extends State<ShopFilterScreen> {
  // قيم الفلاتر المؤقتة
  late String _category;
  late String _salon;
  late String _brand;
  late double _minPrice;
  late double _maxPrice;
  late SortOption _sortBy;

  @override
  void initState() {
    super.initState();
    // جلب القيم الحالية من المزود
    final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    _category = productsProvider.selectedCategory;
    _salon = productsProvider.selectedSalon;
    _brand = productsProvider.selectedBrand;
    _minPrice = productsProvider.minPrice;
    _maxPrice = productsProvider.maxPrice;
    _sortBy = productsProvider.sortBy;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تصفية المنتجات'),
      ),
      body: Consumer<ProductsProvider>(
        builder: (context, productsProvider, child) {
          return Stack(
            children: [
              // محتوى الصفحة
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // الفئات
                    const Text(
                      'الفئة',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildCategoryFilter(productsProvider),
                    const SizedBox(height: 24),

                    // الصالونات
                    const Text(
                      'الصالون',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildSalonFilter(productsProvider),
                    const SizedBox(height: 24),

                    // الماركات
                    const Text(
                      'الماركة',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildBrandFilter(productsProvider),
                    const SizedBox(height: 24),

                    // نطاق السعر
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_maxPrice.toInt()} - ${_minPrice.toInt()} ر.س',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'نطاق السعر',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    RangeSlider(
                      values: RangeValues(_minPrice, _maxPrice),
                      min: 0,
                      max: 1000,
                      divisions: 20,
                      labels: RangeLabels(
                        '${_minPrice.toInt()} ر.س',
                        '${_maxPrice.toInt()} ر.س',
                      ),
                      onChanged: (values) {
                        setState(() {
                          _minPrice = values.start;
                          _maxPrice = values.end;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // الترتيب
                    const Text(
                      'الترتيب حسب',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildSortOptions(),
                    const SizedBox(height: 100), // مساحة للأزرار
                  ],
                ),
              ),

              // أزرار التطبيق وإعادة التعيين
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // زر إعادة التعيين
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _category = '';
                              _salon = '';
                              _brand = '';
                              _minPrice = 0;
                              _maxPrice = 1000;
                              _sortBy = SortOption.popularity;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('إعادة تعيين'),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // زر تطبيق الفلاتر
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            // تطبيق الفلاتر
                            productsProvider.setCategory(_category);
                            productsProvider.setSalon(_salon);
                            productsProvider.setBrand(_brand);
                            productsProvider.setPriceRange(_minPrice, _maxPrice);
                            productsProvider.setSortOption(_sortBy);

                            // العودة للمتجر
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('تطبيق الفلاتر'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryFilter(ProductsProvider productsProvider) {
    // استخراج الفئات المتاحة من المنتجات
    final categories = productsProvider.categories.map((cat) => cat.name).toSet().toList();
    categories.sort();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildFilterChip(
          'الكل',
          _category.isEmpty,
              () {
            setState(() {
              _category = '';
            });
          },
        ),
        ...categories.map((category) {
          return _buildFilterChip(
            category,
            _category == category,
                () {
              setState(() {
                _category = category;
              });
            },
          );
        }),
      ],
    );
  }

  Widget _buildSalonFilter(ProductsProvider productsProvider) {
    final salons = productsProvider.availableSalons;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildFilterChip(
          'الكل',
          _salon.isEmpty,
              () {
            setState(() {
              _salon = '';
            });
          },
        ),
        ...salons.map((salon) {
          return _buildFilterChip(
            salon,
            _salon == salon,
                () {
              setState(() {
                _salon = salon;
              });
            },
          );
        }),
      ],
    );
  }

  Widget _buildBrandFilter(ProductsProvider productsProvider) {
    final brands = productsProvider.availableBrands;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildFilterChip(
          'الكل',
          _brand.isEmpty,
              () {
            setState(() {
              _brand = '';
            });
          },
        ),
        ...brands.map((brand) {
          return _buildFilterChip(
            brand,
            _brand == brand,
                () {
              setState(() {
                _brand = brand;
              });
            },
          );
        }),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSortOptions() {
    return Column(
      children: [
        _buildSortOption(
          'الأكثر رواجاً',
          SortOption.popularity,
        ),
        _buildSortOption(
          'السعر: من الأقل للأعلى',
          SortOption.priceAsc,
        ),
        _buildSortOption(
          'السعر: من الأعلى للأقل',
          SortOption.priceDesc,
        ),
        _buildSortOption(
          'التقييم',
          SortOption.rating,
        ),
        _buildSortOption(
          'الأحدث',
          SortOption.newest,
        ),
      ],
    );
  }

  Widget _buildSortOption(String label, SortOption option) {
    return RadioListTile<SortOption>(
      title: Text(
        label,
        textAlign: TextAlign.right,
      ),
      value: option,
      groupValue: _sortBy,
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _sortBy = value;
          });
        }
      },
    );
  }
}