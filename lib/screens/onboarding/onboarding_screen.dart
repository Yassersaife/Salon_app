// lib/screens/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:salon_booking_app/screens/auth/login_screen.dart';
import 'package:salon_booking_app/screens/onboarding/onboarding_page.dart';
import 'package:salon_booking_app/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  bool isLastPage = false;

  // صفحات التعريف بالتطبيق
  final List<OnboardingPageData> pages = [
    OnboardingPageData(
      title: 'اكتشفي أفضل صالونات التجميل',
      description: 'تصفحي واكتشفي أعلى الصالونات تقييماً بالقرب منك',
      image: 'assets/images/onboarding/onboarding3.jpg',
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE0C3FC),
            Color(0xFF8EC5FC),
          ],
        ),
      ),
    ),
    OnboardingPageData(
      title: 'احجزي موعدك بكل سهولة',
      description: 'حددي الخدمة والموعد المناسب واحجزي بنقرة واحدة',
      image: 'assets/images/onboarding/onboarding2.jpg',
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFA18CD1),
            Color(0xFFFBC2EB),
          ],
        ),
      ),
    ),
    OnboardingPageData(
      title: 'تسوقي منتجات العناية والتجميل',
      description: 'تسوقي أفضل المنتجات من صالونك المفضل مباشرة عبر التطبيق',
      image: 'assets/images/onboarding/onboarding1.jpg',
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFECD2),
            Color(0xFFFC8181),
          ],
        ),
      ),
    ),
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // حفظ حالة مشاهدة صفحات الترحيب
  void _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showedOnboarding', true);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              isLastPage = index == pages.length - 1;
            });
          },
          children: pages.map((pageData) {
            return OnboardingPage(data: pageData);
          }).toList(),
        ),
      ),
      bottomSheet: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // زر التخطي
            isLastPage
                ? const SizedBox.shrink()
                : TextButton(
              onPressed: _completeOnboarding,
              child: Text(
                'تخطي',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // مؤشر الصفحات
            Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: pages.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: AppColors.primary,
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 4,
                ),
                onDotClicked: (index) => controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                ),
              ),
            ),

            // زر التالي أو البدء
            TextButton(
              onPressed: isLastPage
                  ? _completeOnboarding
                  : () {
                controller.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: Text(
                isLastPage ? 'البدء' : 'التالي',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}