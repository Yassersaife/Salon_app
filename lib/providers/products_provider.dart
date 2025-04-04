import 'package:flutter/foundation.dart';
import 'package:salon_booking_app/models/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _products = [];
  List<ProductCategory> _categories = [];
  Product? _selectedProduct;
  bool _isLoading = false;
  String _error = '';

  // فلاتر البحث
  String _searchQuery = '';
  String _selectedCategory = '';
  String _selectedSalon = '';
  String _selectedBrand = '';
  double _minPrice = 0;
  double _maxPrice = 1000;
  SortOption _sortBy = SortOption.popularity;

  // جلب البيانات
  List<Product> get products => _products;
  List<ProductCategory> get categories => _categories;
  Product? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  String get error => _error;

  // جلب الفلاتر
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get selectedSalon => _selectedSalon;
  String get selectedBrand => _selectedBrand;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  SortOption get sortBy => _sortBy;

  // قائمة الصالونات المتاحة (مستخرجة من المنتجات)
  List<String> get availableSalons {
    final salons = _products.map((product) => product.salonName).toSet().toList();
    salons.sort();
    return salons;
  }

  // قائمة الماركات المتاحة (مستخرجة من المنتجات)
  List<String> get availableBrands {
    final brands = _products.map((product) => product.brand).toSet().toList();
    brands.sort();
    return brands;
  }

  ProductsProvider() {
    // جلب البيانات عند إنشاء المزود
    fetchProducts();
    fetchCategories();
  }

  // جلب المنتجات
  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      // في بيئة الإنتاج، سنستدعي API حقيقي
      // مثال: final result = await ApiService().getProducts();

      // استخدام بيانات وهمية للتجربة
      await Future.delayed(const Duration(seconds: 1));
      _products = getMockProducts();
      _error = '';
    } catch (e) {
      _error = 'حدث خطأ أثناء جلب المنتجات';
      print('Error fetching products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // جلب فئات المنتجات
  Future<void> fetchCategories() async {
    try {
      // في بيئة الإنتاج، سنستدعي API حقيقي
      // مثال: final result = await ApiService().getProductCategories();

      // استخدام بيانات وهمية للتجربة
      await Future.delayed(const Duration(milliseconds: 800));
      _categories = getMockProductCategories();
      notifyListeners();
    } catch (e) {
      print('Error fetching product categories: $e');
    }
  }

  // جلب تفاصيل منتج معين
  Future<void> getProductDetails(int productId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // في بيئة الإنتاج، سنستدعي API حقيقي
      // مثال: final result = await ApiService().getProductDetails(productId);

      // البحث في البيانات المحلية
      await Future.delayed(const Duration(milliseconds: 500));
      _selectedProduct = _products.firstWhere((product) => product.id == productId);
      _error = '';
    } catch (e) {
      _error = 'حدث خطأ أثناء جلب تفاصيل المنتج';
      print('Error fetching product details: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // تبديل حالة المفضلة
  void toggleFavorite(int productId) {
    final index = _products.indexWhere((product) => product.id == productId);
    if (index != -1) {
      _products[index] = Product(
        id: _products[index].id,
        name: _products[index].name,
        description: _products[index].description,
        price: _products[index].price,
        discountPrice: _products[index].discountPrice,
        imageUrl: _products[index].imageUrl,
        salonId: _products[index].salonId,
        salonName: _products[index].salonName,
        category: _products[index].category,
        brand: _products[index].brand,
        stockQuantity: _products[index].stockQuantity,
        rating: _products[index].rating,
        reviewsCount: _products[index].reviewsCount,
        isFavorite: !_products[index].isFavorite,
      );

      // تحديث المنتج المحدد إذا كان هو نفسه
      if (_selectedProduct?.id == productId) {
        _selectedProduct = _products[index];
      }

      // في بيئة الإنتاج، سنرسل هذا التغيير إلى الخادم
      // مثال: ApiService().toggleProductFavorite(productId, _products[index].isFavorite);

      notifyListeners();
    }
  }

  // ضبط فلتر البحث
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  // ضبط فلتر الفئة
  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  // ضبط فلتر الصالون
  void setSalon(String salon) {
    _selectedSalon = salon;
    _applyFilters();
  }

  // ضبط فلتر الماركة
  void setBrand(String brand) {
    _selectedBrand = brand;
    _applyFilters();
  }

  // ضبط نطاق السعر
  void setPriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    _applyFilters();
  }

  // ضبط الترتيب
  void setSortOption(SortOption option) {
    _sortBy = option;
    _applyFilters();
  }

  // تطبيق جميع الفلاتر
  void _applyFilters() async {
    _isLoading = true;
    notifyListeners();

    try {
      // في بيئة الإنتاج، سنستدعي API حقيقي مع الفلاتر
      // مثال: final result = await ApiService().searchProducts(query, filters);

      // محاكاة طلب بيانات
      await Future.delayed(const Duration(milliseconds: 500));

      // الحصول على جميع المنتجات أولاً
      var filteredProducts = getMockProducts();

      // تطبيق فلتر البحث
      if (_searchQuery.isNotEmpty) {
        filteredProducts = filteredProducts.where((product) {
          return product.name.contains(_searchQuery) ||
              product.description.contains(_searchQuery) ||
              product.category.contains(_searchQuery) ||
              product.brand.contains(_searchQuery);
        }).toList();
      }

      // تطبيق فلتر الفئة
      if (_selectedCategory.isNotEmpty) {
        filteredProducts = filteredProducts.where((product) =>
        product.category == _selectedCategory).toList();
      }

      // تطبيق فلتر الصالون
      if (_selectedSalon.isNotEmpty) {
        filteredProducts = filteredProducts.where((product) =>
        product.salonName == _selectedSalon).toList();
      }

      // تطبيق فلتر الماركة
      if (_selectedBrand.isNotEmpty) {
        filteredProducts = filteredProducts.where((product) =>
        product.brand == _selectedBrand).toList();
      }

      // تطبيق نطاق السعر
      filteredProducts = filteredProducts.where((product) {
        final productPrice = product.discountPrice > 0
            ? product.discountPrice
            : product.price;
        return productPrice >= _minPrice && productPrice <= _maxPrice;
      }).toList();

      // تطبيق الترتيب
      switch (_sortBy) {
        case SortOption.priceAsc:
          filteredProducts.sort((a, b) {
            final aPrice = a.discountPrice > 0 ? a.discountPrice : a.price;
            final bPrice = b.discountPrice > 0 ? b.discountPrice : b.price;
            return aPrice.compareTo(bPrice);
          });
          break;
        case SortOption.priceDesc:
          filteredProducts.sort((a, b) {
            final aPrice = a.discountPrice > 0 ? a.discountPrice : a.price;
            final bPrice = b.discountPrice > 0 ? b.discountPrice : b.price;
            return bPrice.compareTo(aPrice);
          });
          break;
        case SortOption.rating:
          filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case SortOption.popularity:
          filteredProducts.sort((a, b) => b.reviewsCount.compareTo(a.reviewsCount));
          break;
        case SortOption.newest:
        // في بيانات حقيقية، سنستخدم تاريخ إضافة المنتج
        // هنا نستخدم معرف المنتج كمؤشر على حداثته
          filteredProducts.sort((a, b) => b.id.compareTo(a.id));
          break;
      }

      _products = filteredProducts;
    } catch (e) {
      _error = 'حدث خطأ أثناء تطبيق الفلاتر';
      print('Error applying filters: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // إعادة تعيين جميع الفلاتر
  void resetFilters() {
    _searchQuery = '';
    _selectedCategory = '';
    _selectedSalon = '';
    _selectedBrand = '';
    _minPrice = 0;
    _maxPrice = 1000;
    _sortBy = SortOption.popularity;
    fetchProducts();
  }

  // الحصول على منتجات صالون معين
  List<Product> getProductsBySalon(int salonId) {
    return _products.where((product) => product.salonId == salonId).toList();
  }

  // الحصول على المنتجات المفضلة
  List<Product> get favoriteProducts {
    return _products.where((product) => product.isFavorite).toList();
  }
}

// خيارات الترتيب
enum SortOption {
  popularity, // الأكثر رواجاً (افتراضي)
  priceAsc,   // السعر من الأقل للأعلى
  priceDesc,  // السعر من الأعلى للأقل
  rating,     // التقييم
  newest      // الأحدث
}