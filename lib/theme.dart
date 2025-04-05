import 'package:flutter/material.dart';

class AppColors {
  static Color primary = const Color(0xFF9D27AF); // بنفسجي
  static Color lightPurple = const Color(0xFFF3E5F5);
  static Color darkPurple = const Color(0xFF6A1B9A);
  static Color background = const Color(0xFFF8F8FA);
  static Color textDark = const Color(0xFF333333);
  static Color textLight = const Color(0xFF999999);
  static Color border = const Color(0xFFE0E0E0);
}
class ApiConfig {
  static const String baseUrl = 'http://192.168.88.6:8000/api';
}
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Cairo',
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.darkPurple,
        background: AppColors.background,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSurface: AppColors.textDark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.primary),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
          fontFamily: 'Cairo',
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }
}