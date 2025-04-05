// lib/screens/auth/reset_password_screen.dart
import 'package:flutter/material.dart';
import 'package:salon_booking_app/screens/auth/login_screen.dart';
import 'package:salon_booking_app/services/auth_service.dart';
import 'package:salon_booking_app/theme.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _errorMessage = '';
  bool _isSuccess = false;

  @override
  void dispose() {
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
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
      await _authService.resetPassword(
        email: widget.email,
        token: _tokenController.text.trim(),
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
      );

      // تم إعادة تعيين كلمة المرور بنجاح
      setState(() {
        _isSuccess = true;
      });

      // الانتقال إلى صفحة تسجيل الدخول بعد 2 ثانية
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false, // إزالة جميع الشاشات السابقة من المكدس
          );
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
        title: const Text('إعادة تعيين كلمة المرور'),
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
                    'إعادة تعيين كلمة المرور',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'أدخل رمز الاستعادة المرسل إلى ${widget.email} وكلمة المرور الجديدة',
                    style: const TextStyle(
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
                              'تم إعادة تعيين كلمة المرور بنجاح! جاري تحويلك إلى صفحة تسجيل الدخول...',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // حقل رمز الاستعادة
                  TextFormField(
                    controller: _tokenController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'رمز الاستعادة',
                      prefixIcon: Icon(Icons.vpn_key_outlined),
                      hintText: 'أدخل الرمز المرسل إلى بريدك الإلكتروني',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال رمز الاستعادة';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // حقل كلمة المرور الجديدة
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور الجديدة',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال كلمة المرور الجديدة';
                      }
                      if (value.length < 6) {
                        return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // حقل تأكيد كلمة المرور الجديدة
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      labelText: 'تأكيد كلمة المرور الجديدة',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء تأكيد كلمة المرور الجديدة';
                      }
                      if (value != _passwordController.text) {
                        return 'كلمات المرور غير متطابقة';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // زر إعادة تعيين كلمة المرور
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading || _isSuccess ? null : _resetPassword,
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
                          : const Text('إعادة تعيين كلمة المرور'),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // زر العودة إلى صفحة تسجيل الدخول
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                            (route) => false, // إزالة جميع الشاشات السابقة من المكدس
                      );
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