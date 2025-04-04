import 'package:flutter/foundation.dart';
import 'package:salon_booking_app/models/cart.dart';
import 'package:salon_booking_app/models/product.dart';
import 'package:salon_booking_app/models/order.dart';

class CartProvider with ChangeNotifier {
  Cart _cart = Cart();
  DeliveryAddress? _deliveryAddress;
  String _paymentMethod = 'الدفع عند الاستلام';
  bool _isLoading = false;
  String _error = '';

  // جلب البيانات
  Cart get cart => _cart;
  DeliveryAddress? get deliveryAddress => _deliveryAddress;
  String get paymentMethod => _paymentMethod;
  bool get isLoading => _isLoading;
  String get error => _error;

  // إضافة منتج للسلة
  void addToCart(Product product) {
    _cart.addItem(product);
    notifyListeners();
  }

  // إزالة منتج من السلة
  void removeFromCart(int productId) {
    _cart.removeItem(productId);
    notifyListeners();
  }

  // تحديث كمية منتج
  void updateQuantity(int productId, int quantity) {
    _cart.updateQuantity(productId, quantity);
    notifyListeners();
  }

  // تفريغ السلة
  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  // ضبط عنوان التوصيل
  void setDeliveryAddress(DeliveryAddress address) {
    _deliveryAddress = address;
    notifyListeners();
  }

  // ضبط طريقة الدفع
  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  // إتمام الطلب
  Future<bool> checkout() async {
    if (_deliveryAddress == null) {
      _error = 'يرجى إضافة عنوان التوصيل';
      notifyListeners();
      return false;
    }

    if (_cart.items.isEmpty) {
      _error = 'السلة فارغة';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // في بيئة الإنتاج، سنرسل الطلب إلى API
      // مثال: final result = await ApiService().createOrder(orderData);

      // محاكاة إرسال الطلب
      await Future.delayed(const Duration(seconds: 1));

      // إنشاء طلب جديد
      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch,
        items: List.from(_cart.items),
        totalAmount: _cart.totalPrice,
        orderDate: DateTime.now(),
        status: OrderStatus.pending,
        deliveryAddress: _deliveryAddress!,
        paymentMethod: _paymentMethod,
      );

      // تسجيل الطلب في النظام (في الحالة الواقعية)

      // تفريغ السلة بعد نجاح الطلب
      _cart.clear();
      _error = '';
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'حدث خطأ أثناء إتمام الطلب';
      print('Error checking out: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}