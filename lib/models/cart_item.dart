import 'package:salon_booking_app/models/product.dart';

class CartItem {
  final int id;
  final Product product;
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.discountPrice > 0
      ? product.discountPrice * quantity
      : product.price * quantity;
}