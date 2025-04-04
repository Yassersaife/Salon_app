import 'package:flutter/material.dart';
import 'package:salon_booking_app/theme.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // أيقونة النجاح
              Icon(
                Icons.check_circle,
                size: 100,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),

              // رسالة النجاح
              const Text(
                'تم تأكيد طلبك بنجاح!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              const Text(
                'سيتم مراجعة طلبك وإرساله في أقرب وقت ممكن',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // زر متابعة التسوق
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // العودة للمتجر
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('متابعة التسوق'),
                ),
              ),
              const SizedBox(height: 16),

              // زر عرض الطلبات
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // الانتقال لصفحة الطلبات
                    // يمكن إضافتها مستقبلاً
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('عرض طلباتي'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}