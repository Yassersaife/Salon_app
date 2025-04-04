class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final double discountPrice; // السعر بعد الخصم (اختياري)
  final String imageUrl;
  final int salonId; // معرف الصالون المالك للمنتج
  final String salonName; // اسم الصالون المالك
  final String category; // فئة المنتج
  final String brand; // العلامة التجارية
  final int stockQuantity; // الكمية المتوفرة
  final double rating; // تقييم المنتج
  final int reviewsCount; // عدد التقييمات
  final bool isFavorite; // هل المنتج مفضل للمستخدم

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice = 0,
    required this.imageUrl,
    required this.salonId,
    required this.salonName,
    required this.category,
    required this.brand,
    required this.stockQuantity,
    this.rating = 0,
    this.reviewsCount = 0,
    this.isFavorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      discountPrice: json['discount_price']?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] ?? '',
      salonId: json['salon_id'] ?? 0,
      salonName: json['salon_name'] ?? '',
      category: json['category'] ?? '',
      brand: json['brand'] ?? '',
      stockQuantity: json['stock_quantity'] ?? 0,
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewsCount: json['reviews_count'] ?? 0,
      isFavorite: json['is_favorite'] ?? false,
    );
  }
}

// فئات المنتجات
class ProductCategory {
  final int id;
  final String name;
  final String imageUrl;

  ProductCategory({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}

// بيانات تجريبية للمنتجات
List<Product> getMockProducts() {
  return [
    Product(
      id: 1,
      name: 'شامبو للشعر الجاف',
      description: 'شامبو مرطب للشعر الجاف والمتضرر، يمنح الشعر الترطيب اللازم ويعالج التقصف',
      price: 75.0,
      discountPrice: 60.0,
      imageUrl: 'assets/images/products/product1.jpg',
      salonId: 1,
      salonName: 'صالون ليالي',
      category: 'العناية بالشعر',
      brand: 'لوريال باريس',
      stockQuantity: 25,
      rating: 4.7,
      reviewsCount: 120,
    ),
    Product(
      id: 2,
      name: 'ماسك الشعر بالأرغان',
      description: 'ماسك علاجي للشعر بزيت الأرغان الطبيعي، يمنح الشعر النعومة واللمعان ويغذيه من الجذور',
      price: 95.0,
      imageUrl: 'assets/images/products/product2.jpg',
      salonId: 2,
      salonName: 'صالون روز',
      category: 'العناية بالشعر',
      brand: 'المغرب',
      stockQuantity: 15,
      rating: 4.9,
      reviewsCount: 85,
    ),
    Product(
      id: 3,
      name: 'كريم أساس ماك',
      description: 'كريم أساس من ماك بتغطية متوسطة إلى عالية، مناسب لجميع أنواع البشرة',
      price: 180.0,
      discountPrice: 150.0,
      imageUrl: 'assets/images/products/product3.jpg',
      salonId: 1,
      salonName: 'صالون ليالي',
      category: 'المكياج',
      brand: 'ماك',
      stockQuantity: 10,
      rating: 4.5,
      reviewsCount: 150,
    ),
    Product(
      id: 4,
      name: 'مجموعة فرش مكياج احترافية',
      description: 'مجموعة فرش مكياج احترافية تتكون من 12 فرشاة مختلفة للوجه والعيون والشفاه',
      price: 250.0,
      imageUrl: 'assets/images/products/product4.jpg',
      salonId: 3,
      salonName: 'صالون لمسات',
      category: 'المكياج',
      brand: 'سيفورا',
      stockQuantity: 8,
      rating: 4.6,
      reviewsCount: 65,
    ),
    Product(
      id: 5,
      name: 'كريم مرطب للوجه',
      description: 'كريم مرطب للوجه من سيراف، خالي من العطور والمواد المهيجة للبشرة، مناسب للبشرة الحساسة',
      price: 120.0,
      imageUrl: 'assets/images/products/product5.jpg',
      salonId: 2,
      salonName: 'صالون روز',
      category: 'العناية بالبشرة',
      brand: 'سيراف',
      stockQuantity: 20,
      rating: 4.8,
      reviewsCount: 95,
    ),
    Product(
      id: 6,
      name: 'سيروم فيتامين سي',
      description: 'سيروم فيتامين سي مركز لتفتيح البشرة وتوحيد لونها، يقلل ظهور التصبغات والبقع الداكنة',
      price: 199.0,
      discountPrice: 169.0,
      imageUrl: 'assets/images/products/product6.jpg',
      salonId: 3,
      salonName: 'صالون لمسات',
      category: 'العناية بالبشرة',
      brand: 'ذا أورديناري',
      stockQuantity: 12,
      rating: 4.9,
      reviewsCount: 110,
    ),
    Product(
      id: 7,
      name: 'طلاء أظافر',
      description: 'طلاء أظافر بألوان متنوعة من إيسي، يدوم لمدة طويلة بدون تقشير',
      price: 45.0,
      imageUrl: 'assets/images/products/product7.jpg',
      salonId: 1,
      salonName: 'صالون ليالي',
      category: 'العناية بالأظافر',
      brand: 'إيسي',
      stockQuantity: 30,
      rating: 4.3,
      reviewsCount: 70,
    ),
    Product(
      id: 8,
      name: 'زيت الشعر بالكيراتين',
      description: 'زيت شعر بالكيراتين لإصلاح الشعر التالف وحمايته من الحرارة، يمنح الشعر نعومة ولمعاناً',
      price: 85.0,
      imageUrl: 'assets/images/products/product8.jpg',
      salonId: 2,
      salonName: 'صالون روز',
      category: 'العناية بالشعر',
      brand: 'تريسمي',
      stockQuantity: 18,
      rating: 4.4,
      reviewsCount: 55,
    ),
  ];
}

// فئات المنتجات التجريبية
List<ProductCategory> getMockProductCategories() {
  return [
    ProductCategory(id: 1, name: 'العناية بالشعر', imageUrl: 'assets/images/categories/hair_care.jpg'),
    ProductCategory(id: 2, name: 'المكياج', imageUrl: 'assets/images/categories/makeup.jpg'),
    ProductCategory(id: 3, name: 'العناية بالبشرة', imageUrl: 'assets/images/categories/skin_care.jpg'),
    ProductCategory(id: 4, name: 'العناية بالأظافر', imageUrl: 'assets/images/categories/nails.jpg'),
    ProductCategory(id: 5, name: 'العطور', imageUrl: 'assets/images/categories/perfume.jpg'),
    ProductCategory(id: 6, name: 'أدوات تصفيف الشعر', imageUrl: 'assets/images/categories/hair_tools.jpg'),
  ];
}