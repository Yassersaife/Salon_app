import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_booking_app/models/order.dart';
import 'package:salon_booking_app/providers/cart_provider.dart';
import 'package:salon_booking_app/screens/Shop/order_success_screen.dart';
import 'package:salon_booking_app/theme.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  // بيانات التوصيل
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();

  // طريقة الدفع
  String _paymentMethod = 'الدفع عند الاستلام';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إتمام الطلب'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.cart.items.isEmpty) {
            // إذا كانت السلة فارغة، نعيد المستخدم للسلة
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context);
            });
            return const SizedBox.shrink();
          }

          return Stack(
            children: [
              // محتوى الصفحة
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // ملخص الطلب
                      _buildOrderSummary(cartProvider),
                      const SizedBox(height: 24),

                      // عنوان التوصيل
                      const Text(
                        'عنوان التوصيل',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildAddressForm(),
                      const SizedBox(height: 24),

                      // طريقة الدفع
                      const Text(
                        'طريقة الدفع',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildPaymentMethods(),
                      const SizedBox(height: 100), // مساحة للزر
                    ],
                  ),
                ),
              ),

              // زر تأكيد الطلب
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
                      // زر تأكيد الطلب
                      Expanded(
                        child: ElevatedButton(
                          onPressed: cartProvider.isLoading
                              ? null
                              : () => _confirmOrder(context, cartProvider),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: cartProvider.isLoading
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : const Text('تأكيد الطلب'),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // إجمالي الطلب
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'الإجمالي',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '${cartProvider.cart.totalPrice.toStringAsFixed(2)} ر.س',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
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

  Widget _buildOrderSummary(CartProvider cartProvider) {
    final cart = cartProvider.cart;

    return Card(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
              const Text(
              'ملخص الطلب',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // قائمة المنتجات مختصرة
            ...cart.items.map((item) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text(
    '${item.totalPrice.toStringAsFixed(2)} ر.س',
    style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    Expanded(
    child: Text(
    '${item.product.name} (${item.quantity})',
    textAlign: TextAlign.right,
    overflow: TextOverflow.ellipsis,
    ),
    ),
    ],
    ),
    )),

    const Divider(),

    // الإجمالي
                // الإجمالي
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${cart.totalPrice.toStringAsFixed(2)} ر.س',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Text(
                      'إجمالي الطلب:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // عدد المنتجات
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${cart.totalItems}',
                    ),
                    const Text(
                      'عدد المنتجات:',
                    ),
                  ],
                ),
              ],
            ),
        ),
    );
  }

  Widget _buildAddressForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // الاسم
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'الاسم الكامل',
            prefixIcon: Icon(Icons.person),
          ),
          textAlign: TextAlign.right,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى إدخال الاسم';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // رقم الهاتف
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'رقم الهاتف',
            prefixIcon: Icon(Icons.phone),
          ),
          textAlign: TextAlign.right,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى إدخال رقم الهاتف';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // العنوان
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'العنوان',
            prefixIcon: Icon(Icons.location_on),
          ),
          textAlign: TextAlign.right,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى إدخال العنوان';
            }
            return null;
          },
          maxLines: 2,
        ),
        const SizedBox(height: 16),

        // المدينة
        TextFormField(
          controller: _cityController,
          decoration: const InputDecoration(
            labelText: 'المدينة',
            prefixIcon: Icon(Icons.location_city),
          ),
          textAlign: TextAlign.right,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى إدخال المدينة';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // الرمز البريدي
        TextFormField(
          controller: _postalCodeController,
          decoration: const InputDecoration(
            labelText: 'الرمز البريدي',
            prefixIcon: Icon(Icons.markunread_mailbox),
          ),
          textAlign: TextAlign.right,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى إدخال الرمز البريدي';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      children: [
        // الدفع عند الاستلام
        RadioListTile<String>(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Text('الدفع عند الاستلام'),
              SizedBox(width: 8),
              Icon(Icons.payments_outlined),
            ],
          ),
          value: 'الدفع عند الاستلام',
          groupValue: _paymentMethod,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _paymentMethod = value;
              });
            }
          },
        ),

        // بطاقة ائتمان
        RadioListTile<String>(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Text('بطاقة ائتمان'),
              SizedBox(width: 8),
              Icon(Icons.credit_card),
            ],
          ),
          value: 'بطاقة ائتمان',
          groupValue: _paymentMethod,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _paymentMethod = value;
              });
            }
          },
        ),

        // محفظة إلكترونية
        RadioListTile<String>(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Text('محفظة إلكترونية'),
              SizedBox(width: 8),
              Icon(Icons.account_balance_wallet),
            ],
          ),
          value: 'محفظة إلكترونية',
          groupValue: _paymentMethod,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _paymentMethod = value;
              });
            }
          },
        ),
      ],
    );
  }

  void _confirmOrder(BuildContext context, CartProvider cartProvider) {
    // التحقق من صحة النموذج
    if (!_formKey.currentState!.validate()) {
      // عرض تنبيه إذا كانت البيانات غير صحيحة
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إدخال جميع البيانات المطلوبة بشكل صحيح'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // إنشاء كائن عنوان التوصيل
    final deliveryAddress = DeliveryAddress(
      name: _nameController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      city: _cityController.text,
      postalCode: _postalCodeController.text,
    );

    // ضبط عنوان التوصيل وطريقة الدفع
    cartProvider.setDeliveryAddress(deliveryAddress);
    cartProvider.setPaymentMethod(_paymentMethod);

    // إرسال الطلب
    cartProvider.checkout().then((success) {
      if (success) {
        // الانتقال إلى صفحة نجاح الطلب
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OrderSuccessScreen(),
          ),
        );
      } else {
        // عرض رسالة الخطأ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(cartProvider.error),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }
}