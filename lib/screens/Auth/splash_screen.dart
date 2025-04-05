// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_booking_app/providers/user_provider.dart';
import 'package:salon_booking_app/screens/auth/login_screen.dart';
import 'package:salon_booking_app/screens/home_screen.dart';
import 'package:salon_booking_app/screens/onboarding/onboarding_screen.dart';
import 'package:salon_booking_app/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _showedOnboarding = false;

  @override
  void initState() {
    super.initState();
// للاختبار فقط

    // إعداد الرسوم المتحركة
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();

    // التحقق من حالة تسجيل الدخول بعد انتهاء الرسوم المتحركة
    Future.delayed(const Duration(seconds: 2), () {

      _checkOnboardingStatus();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // التحقق من حالة صفحات الترحيب
  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
   // _showedOnboarding = prefs.getBool('showedOnboarding') ?? false;
    _showedOnboarding =  false;

    if (_showedOnboarding) {
      // إذا تم عرض صفحات الترحيب من قبل، تحقق من حالة تسجيل الدخول
      _checkAuthStatus();
    } else {
      // إذا لم يتم عرض صفحات الترحيب من قبل، انتقل إلى صفحات الترحيب
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }

  // التحقق من حالة تسجيل الدخول وتوجيه المستخدم
  Future<void> _checkAuthStatus() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // انتظار انتهاء عملية التحقق من حالة تسجيل الدخول
    while (userProvider.isLoading) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (!mounted) return;

    // توجيه المستخدم حسب حالة تسجيل الدخول
    if (userProvider.isLoggedIn) {
      // المستخدم مسجل دخول، الانتقال إلى الصفحة الرئيسية
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      // المستخدم غير مسجل دخول، الانتقال إلى صفحة تسجيل الدخول
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // شعار التطبيق
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.spa,
                  color: Colors.white,
                  size: 80,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'تطبيق ريلاكس',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'لحجز صالونات التجميل',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 48),
              // مؤشر التحميل
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}