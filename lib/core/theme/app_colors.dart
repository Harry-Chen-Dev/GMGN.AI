import 'package:flutter/material.dart';

class AppColors {
  // Background Colors
  static const Color background = Color(0xFF0B0E11);
  static const Color cardBackground = Color(0xFF1A1D21);
  static const Color surfaceColor = Color(0xFF252830);
  
  // Primary Colors
  static const Color primary = Color(0xFF00D4AA);
  static const Color primaryLight = Color(0xFF33E0C0);
  static const Color primaryDark = Color(0xFF00A085);
  
  // Success/Profit Colors
  static const Color success = Color(0xFF00C896);
  static const Color successLight = Color(0xFF33D4A8);
  static const Color successBackground = Color(0xFF0D2818);
  
  // Error/Loss Colors
  static const Color error = Color(0xFFFF4D6D);
  static const Color errorLight = Color(0xFFFF7A91);
  static const Color errorBackground = Color(0xFF2D1319);
  
  // Warning Colors
  static const Color warning = Color(0xFFFFA726);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningBackground = Color(0xFF2D2318);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B7C3);
  static const Color textTertiary = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFF4A5568);
  
  // Border Colors
  static const Color borderColor = Color(0xFF2D3748);
  static const Color borderLight = Color(0xFF3A4553);
  static const Color borderDark = Color(0xFF1A202C);
  
  // Button Colors
  static const Color buttonPrimary = Color(0xFF00D4AA);
  static const Color buttonSecondary = Color(0xFF4A5568);
  static const Color buttonDisabled = Color(0xFF2D3748);
  
  // Chart Colors
  static const Color chartGreen = Color(0xFF00C896);
  static const Color chartRed = Color(0xFFFF4D6D);
  static const Color chartBlue = Color(0xFF3B82F6);
  static const Color chartOrange = Color(0xFFF59E0B);
  static const Color chartPurple = Color(0xFF8B5CF6);
  
  // Special Colors
  static const Color accent = Color(0xFF7C3AED);
  static const Color highlight = Color(0xFF1E40AF);
  static const Color overlay = Color(0x80000000);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00D4AA), Color(0xFF00A085)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF00C896), Color(0xFF00A075)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient errorGradient = LinearGradient(
    colors: [Color(0xFFFF4D6D), Color(0xFFE63946)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1A1D21), Color(0xFF252830)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}