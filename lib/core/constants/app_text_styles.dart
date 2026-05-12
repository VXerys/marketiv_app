import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // ==========================================
  // === Newsreader Styles (Heading)
  // ==========================================
  static const String _fontNewsreader = 'Newsreader';
  
  static const TextStyle h1 = TextStyle(
    fontFamily: _fontNewsreader,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.grey900,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: _fontNewsreader,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.grey900,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: _fontNewsreader,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.grey900,
  );

  // ==========================================
  // === Inter Styles (Body & UI)
  // ==========================================
  static const String _fontInter = 'Inter';

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontInter,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.grey700,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _fontInter,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.grey700,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontInter,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.grey500,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: _fontInter,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.grey900,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: _fontInter,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.grey700,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: _fontInter,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
