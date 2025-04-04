import 'package:salon_booking_app/models/cart_item.dart';
import 'package:salon_booking_app/models/product.dart';

class Cart {
  List<CartItem> items = [];

  double get totalPrice => items.fold(
      0, (sum, item) => sum + item.totalPrice);

  int get totalItems => items.fold(
      0, (sum, item) => sum + item.quantity);

  void addItem(Product product) {
    // التحقق إذا كان المنتج موجوداً بالفعل في السلة
    final existingIndex = items.indexWhere(
            (item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      // زيادة الكمية إذا كان المنتج موجوداً
      items[existingIndex].quantity++;
    } else {
      // إضافة منتج جديد
      items.add(
          CartItem(
            id: DateTime.now().millisecondsSinceEpoch,
            product: product,
            quantity: 1,
          )
      );
    }
  }

  void removeItem(int productId) {
    items.removeWhere((item) => item.product.id == productId);
  }

  void updateQuantity(int productId, int quantity) {
    final index = items.indexWhere(
            (item) => item.product.id == productId);

    if (index >= 0) {
      if (quantity <= 0) {
        removeItem(productId);
      } else {
        items[index].quantity = quantity;
      }
    }
  }

  void clear() {
    items = [];
  }
}