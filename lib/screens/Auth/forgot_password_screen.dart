import 'package:flutter/material.dart';
import 'package:salon_booking_app/screens/auth/reset_password_screen.dart';
import 'package:salon_booking_app/services/auth_service.dart';
import 'package:salon_booking_app/theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isSuccess = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    // التحقق من صحة النموذج
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _isSuccess = false;
    });

    try {
      // استدعاء خدمة استعادة كلمة المرور
      await _authService.forgotPassword(_emailController.text.trim());

      // تم إرسال رابط إعادة التعيين بنجاح
      setState(() {
        _isSuccess = true;
      });

      // الانتقال إلى صفحة إعادة تعيين كلمة المرور بعد 2 ثانية
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('استعادة كلمة المرور'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // أيقونة القفل
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.lightPurple,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_reset,
                      color: AppColors.primary,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'نسيت كلمة المرور؟',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'أدخل بريدك الإلكتروني وسنرسل لك رمز استعادة كلمة المرور',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // عرض رسالة الخطأ إذا وجدت
                  if (_errorMessage.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _errorMessage,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // عرض رسالة النجاح
                  if (_isSuccess)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline, color: Colors.green),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'تم إرسال رمز استعادة كلمة المرور بنجاح، تحقق من بريدك الإلكتروني',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // حقل البريد الإلكتروني
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      labelText: 'البريد الإلكتروني',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال البريد الإلكتروني';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'يرجى إدخال بريد إلكتروني صحيح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // زر إرسال رمز الاستعادة
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading || _isSuccess ? null : _sendResetLink,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Text('إرسال رمز الاستعادة'),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // زر العودة إلى صفحة تسجيل الدخول
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'العودة إلى تسجيل الدخول',
                      style: TextStyle(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}