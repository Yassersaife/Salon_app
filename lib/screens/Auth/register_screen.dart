// lib/screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_booking_app/providers/user_provider.dart';
import 'package:salon_booking_app/screens/home_screen.dart';
import 'package:salon_booking_app/services/auth_service.dart';
import 'package:salon_booking_app/theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _errorMessage = '';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    // التحقق من صحة النموذج
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final user = await _authService.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
        phone: _phoneController.text.trim(),
      );

      // تحديث معلومات المستخدم في البروفايدر
      if (!mounted) return;
      Provider.of<UserProvider>(context, listen: false).setCurrentUser(user);

      // الانتقال إلى الصفحة الرئيسية
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
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
        title: const Text('إنشاء حساب جديد'),
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
                  // شعار التطبيق
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.spa,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'أنشئ حسابك الجديد',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'أدخل بياناتك لإنشاء حساب جديد',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
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

                  // حقل الاسم
                  TextFormField(
                    controller: _nameController,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      labelText: 'الاسم',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال الاسم';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

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
                  const SizedBox(height: 16),

                  // حقل رقم الهاتف
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      labelText: 'رقم الهاتف',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال رقم الهاتف';
                      }
                      if (!RegExp(r'^[0-9]{9,15}$').hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
                        return 'يرجى إدخال رقم هاتف صحيح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // حقل كلمة المرور
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور',
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
                        return 'الرجاء إدخال كلمة المرور';
                      }
                      if (value.length < 6) {
                        return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // حقل تأكيد كلمة المرور
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      labelText: 'تأكيد كلمة المرور',
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
                        return 'الرجاء تأكيد كلمة المرور';
                      }
                      if (value != _passwordController.text) {
                        return 'كلمات المرور غير متطابقة';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // زر التسجيل
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _register,
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
                          : const Text('إنشاء حساب'),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // زر العودة إلى صفحة تسجيل الدخول
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Text('لديك حساب بالفعل؟'),
                    ],
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