import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_booking_app/models/product.dart';
import 'package:salon_booking_app/providers/products_provider.dart';
import 'package:salon_booking_app/providers/cart_provider.dart';
import 'package:salon_booking_app/screens/Salon/salon_details.dart';
import 'package:salon_booking_app/screens/Shop/cart_screen.dart';
import 'package:salon_booking_app/theme.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({Key? key, required this.productId}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    // جلب تفاصيل المنتج
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductsProvider>(context, listen: false).getProductDetails(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('تفاصيل المنتج'),
          actions: [
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
                  productsProvider.getProductDetails(widget.productId);
                },
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        );
      }

      if (productsProvider.selectedProduct == null) {
        return const Center(child: Text('لم يتم العثور على المنتج'));
      }

      final product = productsProvider.selectedProduct!;
      return Stack(
        children: [
      // محتوى الصفحة
      SingleChildScrollView(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      // صورة المنتج
      Stack(
      children: [
      Image.asset(
        product.imageUrl,
        width: double.infinity,
        height: 300,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 300,
            color: Colors.grey[200],
            child: const Center(
              child: Icon(Icons.image, size: 80, color: Colors.grey),
            ),
          );
        },
      ),
    if (product.discountPrice > 0)
    Positioned(
    top: 16,
    right: 16,
    child: Container(
    padding: const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
    ),
    decoration: BoxDecoration(
    color: Colors.red,
    borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
    '${(((product.price - product.discountPrice) / product.price) * 100).toInt()}% خصم',
    style: const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    ),
    Positioned(
    top: 16,
    left: 16,
    child: Container(
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.white.withOpacity(0.8),
    ),
    child: IconButton(
    icon: Icon(
    product.isFavorite ? Icons.favorite : Icons.favorite_border,
    color: product.isFavorite ? Colors.red : null,
    ),
    onPressed: () {
          productsProvider.toggleFavorite(product.id);
          },
          ),
          ),
          ),
          ],
          ),

          // معلومات المنتج
          Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
          // اسم المنتج
          Text(
          product.name,
          style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right,
          ),
          const SizedBox(height: 8),

          // الماركة والفئة
          Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
          Container(
          padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
          ),
          decoration: BoxDecoration(
          color: AppColors.lightPurple,
          borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
          product.category,
          style: TextStyle(
          color: AppColors.primary,
          fontSize: 12,
          ),
          ),
          ),
          const SizedBox(width: 8),
          Text(
          'الماركة: ${product.brand}',
          style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
          ),
          ),
          ],
          ),
          const SizedBox(height: 8),

          // التقييم
          Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
          Text(
          '(${product.reviewsCount} تقييم)',
          style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
          ),
          ),
          const SizedBox(width: 4),
          Text(
          '${product.rating}',
          style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          ),
          ),
          const SizedBox(width: 4),
          const Icon(
          Icons.star,
          color: Colors.amber,
          size: 20,
          ),
          ],
          ),
          const SizedBox(height: 16),

          // السعر
          Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
          if (product.discountPrice > 0)
          Text(
          '${product.price} ر.س',
          style: TextStyle(
          decoration: TextDecoration.lineThrough,
          color: Colors.grey[600],
          fontSize: 16,
          ),
          ),
          const SizedBox(width: 8),
          Text(
          '${product.discountPrice > 0 ? product.discountPrice : product.price} ر.س',
          style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: product.discountPrice > 0 ? Colors.red : AppColors.primary,
          ),
          ),
          ],
          ),
          const SizedBox(height: 16),

          // معلومات الصالون
          GestureDetector(
          onTap: () {
          Navigator.push(
          context,
          MaterialPageRoute(
          builder: (context) => SalonDetailsScreen(salonId: product.salonId),
          ),
          );
          },
          child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
          const Icon(
          Icons.arrow_back_ios,
          size: 16,
          color: Colors.grey,
          ),
          const Spacer(),
          Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
          Text(
          product.salonName,
          style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          ),
          ),
          const SizedBox(height: 4),
          const Text(
          'الانتقال إلى صفحة الصالون',
          style: TextStyle(
          color: Colors.grey,
          fontSize: 12,
          ),
          ),
          ],
          ),
          const SizedBox(width: 8),
          Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
          color: AppColors.lightPurple,
          shape: BoxShape.circle,
          ),
          child: Icon(
          Icons.spa,
          color: AppColors.primary,
          ),
          ),
          ],
          ),
          ),
          ),
          const SizedBox(height: 24),

          // الوصف
          const Text(
          'الوصف',
          style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right,
          ),
          const SizedBox(height: 8),
          Text(
          product.description,
          style: const TextStyle(
          fontSize: 16,
          height: 1.5,
          ),
          textAlign: TextAlign.right,
          ),
          const SizedBox(height: 24),

          // المخزون
          Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
          Text(
          product.stockQuantity > 0
          ? 'متوفر في المخزون (${product.stockQuantity})'
              : 'غير متوفر حالياً',
          style: TextStyle(
          color: product.stockQuantity > 0 ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
          ),
          ),
          const SizedBox(width: 8),
          Icon(
          product.stockQuantity > 0
          ? Icons.check_circle
              : Icons.cancel,
          color: product.stockQuantity > 0 ? Colors.green : Colors.red,
          ),
          ],
          ),
          const SizedBox(height: 100), // مساحة للزر أسفل الشاشة
          ],
          ),
          ),
          ],
          ),
          ),
          ],
          );
        },
        ),
      bottomSheet: Consumer<ProductsProvider>(
        builder: (context, productsProvider, child) {
          if (productsProvider.selectedProduct == null) {
            return const SizedBox.shrink();
          }

          final product = productsProvider.selectedProduct!;
          return Container(
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
                // زر إضافة للسلة
                Expanded(
                  flex: 2,
                  child: Consumer<CartProvider>(
                    builder: (context, cartProvider, child) {
                      return ElevatedButton(
                        onPressed: product.stockQuantity > 0
                            ? () {
                          // إضافة المنتج للسلة بالكمية المحددة
                          for (var i = 0; i < _quantity; i++) {
                            cartProvider.addToCart(product);
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تمت إضافة ${product.name} إلى السلة'),
                              action: SnackBarAction(
                                label: 'عرض السلة',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CartScreen(),
                                    ),
                                  );
                                },
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                            : null, // تعطيل الزر إذا كان المنتج غير متوفر
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('إضافة للسلة'),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),

                // اختيار الكمية
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.lightPurple,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: product.stockQuantity > _quantity
                              ? () {
                            setState(() {
                              _quantity++;
                            });
                          }
                              : null, // تعطيل الزر إذا وصلنا للحد الأقصى
                          color: AppColors.primary,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '$_quantity',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.lightPurple,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: _quantity > 1
                              ? () {
                            setState(() {
                              _quantity--;
                            });
                          }
                              : null, // تعطيل الزر إذا كانت الكمية 1
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}