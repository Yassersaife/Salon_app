import 'package:salon_booking_app/models/cart_item.dart';

class DeliveryAddress {
  final String name;
  final String phone;
  final String address;
  final String city;
  final String postalCode;

  DeliveryAddress({
    required this.name,
    required this.phone,
    required this.address,
    required this.city,
    required this.postalCode,
  });
}

enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled
}

class Order {
  final int id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime orderDate;
  final OrderStatus status;
  final DeliveryAddress deliveryAddress;
  final String paymentMethod;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.status,
    required this.deliveryAddress,
    required this.paymentMethod,
  });
}