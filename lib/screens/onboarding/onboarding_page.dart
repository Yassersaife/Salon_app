// lib/screens/onboarding/onboarding_page.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingPageData {
  final String title;
  final String description;
  final String image; // يمكن أن تكون صورة أو رسوم متحركة Lottie
  final BoxDecoration decoration;

  OnboardingPageData({
    required this.title,
    required this.description,
    required this.image,
    required this.decoration,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;

  const OnboardingPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: data.decoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // الصورة أو الرسوم المتحركة
          Expanded(
            flex: 3,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white30,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 20,
              ),
              child: data.image.endsWith('.json')
                  ? Lottie.asset(data.image)
                  : Image.asset(
                data.image,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // المحتوى النصي
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 3,
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    data.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 2,
                          color: Color.fromRGBO(0, 0, 0, 0.2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}