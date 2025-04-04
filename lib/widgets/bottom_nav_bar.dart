import 'package:flutter/material.dart';
import 'dart:ui';

class SleekBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const SleekBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap
  }) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    // الألوان الأساسية
    final primaryColor = Color(0xFF9D27AF);
    final backgroundColor = Colors.white;
    // ارتفاع أقل للشريط
    final double height = 55;

    return Container(
      height: height,
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor.withOpacity(0.85),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(Icons.home_rounded, 'الرئيسية', 0, primaryColor),
                _buildNavItem(Icons.search_rounded, 'أبحث', 1, primaryColor),
                _buildNavItem(Icons.shopping_bag_rounded, 'المتجر', 2, primaryColor), // زر المتجر
                _buildNavItem(Icons.calendar_today_rounded, 'حجوزاتي', 3, primaryColor),
                _buildNavItem(Icons.person_rounded, 'حسابي', 4, primaryColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildNavItem(IconData icon, String label, int index, Color primaryColor) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: isSelected ? LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryColor.withOpacity(0.05),
              primaryColor.withOpacity(0.15),
            ],
          ) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? primaryColor : Colors.grey,
              size: 24,
            ),
            SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? primaryColor : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}