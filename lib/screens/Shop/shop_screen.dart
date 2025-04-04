import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_booking_app/models/product.dart';
import 'package:salon_booking_app/providers/products_provider.dart';
import 'package:salon_booking_app/providers/cart_provider.dart';
import 'package:salon_booking_app/screens/Shop/product_details_screen.dart';
import 'package:salon_booking_app/screens/Shop/cart_screen.dart';
import 'package:salon_booking_app/screens/Shop/shop_filter_screen.dart';
import 'package:salon_booking_app/theme.dart';
import 'package:salon_booking_app/widgets/product_grid_item.dart';
import 'package:salon_booking_app/widgets/product_category_item.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isGridView = true; // للتبديل بين عرض الشبكة وعرض القائمة


      @override
      void initState() {
      super.initState();
      // جلب المنتجات والفئات
      WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductsProvider>(context, listen: false).fetchProducts();
      Provider.of<ProductsProvider>(context, listen: false).fetchCategories();
      });
      }

      @override
      void dispose() {
      _searchController.dispose();
      super.dispose();
      }

      @override
      Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
      title: const Text('متجر المنتجات'),
      actions: [
      // زر البحث

      // زر السلة
      Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
      return Stack(
      alignment: Alignment.center,
      children: [
      IconButton(
      icon: const Icon(Icons.shopping_cart),
      onPressed: () {
      Navigator.push(
      context,
      MaterialPageRoute(
      builder: (context) => const CartScreen(),
      ),
      );
      },
      ),
      if (cartProvider.cart.totalItems > 0)
      Positioned(
      top: 5,
      right: 5,
      child: Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints(
      minWidth: 16,
      minHeight: 16,
      ),
      child: Text(
      '${cartProvider.cart.totalItems}',
      style: const TextStyle(
      color: Colors.white,
      fontSize: 10,
      ),
      textAlign: TextAlign.center,
      ),
      ),
      ),
      ],
      );
      },
      ),
      ],
      ),
      body: Consumer<ProductsProvider>(
      builder: (context, productsProvider, child) {
      if (productsProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
      }

      if (productsProvider.error.isNotEmpty) {
      return Center(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Text(productsProvider.error),
      const SizedBox(height: 16),
      ElevatedButton(
      onPressed: () {
      productsProvider.fetchProducts();
      },
      child: const Text('إعادة المحاولة'),
      ),
      ],
      ),
      );
      }

      return CustomScrollView(
      slivers: [
      // حقل البحث
      SliverToBoxAdapter(
      child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
      children: [
      // زر الفلتر
      Container(
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
      color: AppColors.lightPurple,
      borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
      icon: Icon(
      Icons.filter_list,
      color: AppColors.primary,
      ),
      onPressed: () {
      Navigator.push(
      context,
      MaterialPageRoute(
      builder: (context) => const ShopFilterScreen(),
      ),
      );
      },
      ),
      ),

      // حقل البحث
      Expanded(
      child: TextField(
      controller: _searchController,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
      hintText: 'ابحث عن منتج...',
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
      productsProvider.setSearchQuery(value);
      },
      ),
      ),
      ],
      ),
      ),
      ),

      // الفلاتر النشطة
      if (productsProvider.searchQuery.isNotEmpty ||
      productsProvider.selectedCategory.isNotEmpty ||
      productsProvider.selectedSalon.isNotEmpty ||
      productsProvider.selectedBrand.isNotEmpty)
      SliverToBoxAdapter(
      child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
      if (productsProvider.searchQuery.isNotEmpty)
      _buildFilterChip(
      'بحث: ${productsProvider.searchQuery}',
      () {
      _searchController.clear();
      productsProvider.setSearchQuery('');
      },
      ),
      if (productsProvider.selectedCategory.isNotEmpty)
      _buildFilterChip(
      'الفئة: ${productsProvider.selectedCategory}',
      () {
      productsProvider.setCategory('');
      },
      ),
      if (productsProvider.selectedSalon.isNotEmpty)
      _buildFilterChip(
      'الصالون: ${productsProvider.selectedSalon}',
      () {
      productsProvider.setSalon('');
      },
      ),
      if (productsProvider.selectedBrand.isNotEmpty)
      _buildFilterChip(
      'الماركة: ${productsProvider.selectedBrand}',
      () {
      productsProvider.setBrand('');
      },
      ),
      // زر إعادة تعيين جميع الفلاتر
      GestureDetector(
      onTap: () {
      _searchController.clear();
      productsProvider.resetFilters();
      },
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
      color: Colors.red[100],
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.red),
      ),
      child: Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
      Icon(Icons.clear, size: 16, color: Colors.red),
      SizedBox(width: 4),
      Text(
      'مسح الكل',
      style: TextStyle(color: Colors.red, fontSize: 12),
      ),
      ],
      ),
      ),
      ),
      ],
      ),
      ),
      ),

      // عنوان الفئات
      if (productsProvider.selectedCategory.isEmpty &&
      productsProvider.searchQuery.isEmpty)
      SliverToBoxAdapter(
      child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
      children: [
      const Expanded(
      child: Text(
      'الفئات',
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
      if (productsProvider.selectedCategory.isEmpty &&
      productsProvider.searchQuery.isEmpty)
      SliverToBoxAdapter(
      child: SizedBox(
      height: 120,
      child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: productsProvider.categories.length,
      itemBuilder: (context, index) {
      final category = productsProvider.categories[index];
      return GestureDetector(
      onTap: () {
      productsProvider.setCategory(category.name);
      },
      child: ProductCategoryItem(category: category),
      );
      },
      ),
      ),
      ),

      // نتائج المنتجات
      SliverToBoxAdapter(
      child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      // أزرار تغيير طريقة العرض (شبكة/قائمة)
      Row(
      children: [
      IconButton(
      icon: Icon(
      Icons.grid_view,
      color: _isGridView ? AppColors.primary : Colors.grey,
      ),
      onPressed: () {
      setState(() {
      _isGridView = true;
      });
      },
      ),
      IconButton(
      icon: Icon(
      Icons.view_list,
      color: !_isGridView ? AppColors.primary : Colors.grey,
      ),
      onPressed: () {
      setState(() {
      _isGridView = false;
      });
      },
      ),
      ],
      ),

      // عدد النتائج والترتيب
      Row(
      children: [
      Text(
      'عدد النتائج: ${productsProvider.products.length}',
      style: TextStyle(
      fontSize: 12,
      color: Colors.grey[600],
      ),
      ),
      const SizedBox(width: 8),
      // زر الترتيب
      GestureDetector(
      onTap: () {
      _showSortDialog(productsProvider);
      },
      child: Row(
      children: [
      Text(
      _getSortText(productsProvider.sortBy),
      style: TextStyle(
      fontSize: 12,
      color: AppColors.primary,
      ),
      ),
      Icon(
      Icons.sort,
      size: 16,
      color: AppColors.primary,
      ),
      ],
      ),
      ),
      ],
      ),
      ],
      ),
      ),
      ),

      // شبكة المنتجات
      productsProvider.products.isEmpty
      ? const SliverFillRemaining(
      child: Center(
      child: Text(
      'لا توجد منتجات مطابقة للبحث',
      style: TextStyle(fontSize: 16),
      ),
      ),
      )
          : _isGridView
      ? SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      crossAxisSpacing: 10,
      mainAxisSpacing: 20,
      ),
      delegate: SliverChildBuilderDelegate(
      (context, index) {
      final product = productsProvider.products[index];
      return ProductGridItem(
      product: product,
      onTap: () => _navigateToProductDetails(product),
      onFavoriteTap: () {
      productsProvider.toggleFavorite(product.id);
      },
      );
      },
      childCount: productsProvider.products.length,
      ),
      ),
      )
          : SliverList(
      delegate: SliverChildBuilderDelegate(
      (context, index) {
      final product = productsProvider.products[index];
      return _buildProductListItem(product, productsProvider);
      },
      childCount: productsProvider.products.length,
      ),
      ),

      // مساحة إضافية في النهاية
      const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
      ],
      );
      },
      ),
      );
      }

      Widget _buildFilterChip(String label, VoidCallback onDelete) {
      return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
      color: AppColors.lightPurple,
      borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
      GestureDetector(
      onTap: onDelete,
      child: Icon(
      Icons.clear,
      size: 16,
      color: AppColors.primary,
      ),
      ),
      const SizedBox(width: 4),
      Text(
      label,
      style: TextStyle(
      color: AppColors.primary,
      fontSize: 12,
      ),
      ),
      ],
      ),
      );
      }

      Widget _buildProductListItem(Product product, ProductsProvider productsProvider) {
      return Card(

      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
      onTap: () => _navigateToProductDetails(product),
      child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      // صورة المنتج
      ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
      children: [
      Image.asset(
      product.imageUrl,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
      return Container(
      width: 100,
      height: 100,
      color: Colors.grey[200],
      child: const Icon(Icons.image, size: 50, color: Colors.grey),
      );
      },
      ),
      if (product.discountPrice > 0)
      Positioned(
      top: 0,
      right: 0,
      child: Container(
      padding: const EdgeInsets.symmetric(
      horizontal: 6,
      vertical: 2,
      ),
      decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(8),
      ),
      ),
      child: Text(
      '${(((product.price - product.discountPrice) / product.price) * 100).toInt()}%-',
      style: const TextStyle(
      color: Colors.white,
      fontSize: 10,
      fontWeight: FontWeight.bold,
      ),
      ),
      ),
      ),
      ],
      ),
      ),
      const SizedBox(width: 12),

      // تفاصيل المنتج
      Expanded(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      // زر المفضلة
      IconButton(
      icon: Icon(
      product.isFavorite ? Icons.favorite : Icons.favorite_border,
      color: product.isFavorite ? Colors.red : null,
      size: 20,
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: () {
      productsProvider.toggleFavorite(product.id);
      },
      ),

      // اسم المنتج
      Flexible(
      child: Text(
      product.name,
      style: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.right,
      ),
      ),
      ],
      ),
      const SizedBox(height: 4),

      // اسم الصالون
      Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
      Text(
      product.salonName,
      style: TextStyle(
      color: AppColors.primary,
      fontSize: 12,
      ),
      ),
      const SizedBox(width: 4),
      Icon(
      Icons.spa,
      size: 12,
      color: AppColors.primary,
      ),
      ],
      ),
      const SizedBox(height: 4),

      // التقييم
      Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
      Text(
      '(${product.reviewsCount})',
      style: TextStyle(
      color: Colors.grey[600],
      fontSize: 12,
      ),
      ),
      const SizedBox(width: 4),
      Text(
      '${product.rating}',
      style: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      ),
      ),
      const SizedBox(width: 4),
      const Icon(
      Icons.star,
      color: Colors.amber,
      size: 16,
      ),
      ],
      ),
      const SizedBox(height: 8),

      // السعر وزر الإضافة للسلة
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
      return ElevatedButton.icon(
      onPressed: () {
      cartProvider.addToCart(product);
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
      content: Text('تمت إضافة ${product.name} إلى السلة'),
      duration: const Duration(seconds: 2),
      ),
      );
      },
      icon: const Icon(Icons.add_shopping_cart, size: 16),
      label: const Text('إضافة'),
      style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 4,
      ),
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      );
      },
      ),

      // السعر
      Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
      if (product.discountPrice > 0)
      Text(
      '${product.price} ر.س',
      style: TextStyle(
      decoration: TextDecoration.lineThrough,
      color: Colors.grey[600],
      fontSize: 12,
      ),
      ),
      Text(
      '${product.discountPrice > 0 ? product.discountPrice : product.price} ر.س',
      style: TextStyle(
      fontWeight: FontWeight.bold,
      color: product.discountPrice > 0 ? Colors.red : AppColors.primary,
      ),
      ),
      ],
      ),
      ],
      ),
      ],
      ),
      ),
      ],
      ),
      ),
      ),
      );
      }

      void _navigateToProductDetails(Product product) {
      Navigator.push(
      context,
      MaterialPageRoute(
      builder: (context) => ProductDetailsScreen(productId: product.id),
      ),
      );
      }


      void _showSortDialog(ProductsProvider productsProvider) {
      showDialog(
      context: context,
      builder: (context) => AlertDialog(
      title: const Text(
      'ترتيب حسب',
      textAlign: TextAlign.right,
      ),
      content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
      _buildSortOption(
      'الأكثر رواجاً',
      SortOption.popularity,
      productsProvider,
      ),
      _buildSortOption(
      'السعر: من الأقل للأعلى',
      SortOption.priceAsc,
      productsProvider,
      ),
      _buildSortOption(
      'السعر: من الأعلى للأقل',
      SortOption.priceDesc,
      productsProvider,
      ),
      _buildSortOption(
      'التقييم',
      SortOption.rating,
      productsProvider,
      ),
      _buildSortOption(
      'الأحدث',
      SortOption.newest,
      productsProvider,
      ),
      ],
      ),
      ),
      );
      }

      Widget _buildSortOption(
      String label,
      SortOption option,
      ProductsProvider productsProvider,
      ) {
      return InkWell(
      onTap: () {
      productsProvider.setSortOption(option);
      Navigator.pop(context);
      },
      child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      Radio<SortOption>(
      value: option,
      groupValue: productsProvider.sortBy,
      onChanged: (value) {
      if (value != null) {
      productsProvider.setSortOption(value);
      Navigator.pop(context);
      }
      },
      ),
      Text(
      label,
      style: TextStyle(
      color: productsProvider.sortBy == option ? AppColors.primary : null,
      fontWeight: productsProvider.sortBy == option ? FontWeight.bold : null,
      ),
      ),
      ],
      ),
      ),
      );
      }

      String _getSortText(SortOption sortOption) {
      switch (sortOption) {
      case SortOption.popularity:
      return 'الأكثر رواجاً';
      case SortOption.priceAsc:
      return 'السعر: من الأقل للأعلى';
      case SortOption.priceDesc:
      return 'السعر: من الأعلى للأقل';
      case SortOption.rating:
      return 'التقييم';
      case SortOption.newest:
      return 'الأحدث';
      }
      }
    }