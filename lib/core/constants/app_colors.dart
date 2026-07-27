import 'package:flutter/material.dart';

/// هوية "شراكة" اللونية — تصميم داكن فخم (Dark Premium) بلمسات ذهبية
/// يرمز الذهبي للنمو والثقة المالية، والداكن للاحترافية والأمان
class AppColors {
  AppColors._();

  // الخلفيات
  static const Color background = Color(0xFF0B0E14);
  static const Color surface = Color(0xFF141822);
  static const Color surfaceElevated = Color(0xFF1C212E);
  static const Color surfaceCard = Color(0xFF1A1F2B);

  // الذهبي - اللون المميز
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFE8CC6E);
  static const Color goldDark = Color(0xFFAA8B2C);

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFE8CC6E), Color(0xFFD4AF37), Color(0xFFAA8B2C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF141822), Color(0xFF0B0E14)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // النصوص
  static const Color textPrimary = Color(0xFFF5F3EE);
  static const Color textSecondary = Color(0xFFA8AEBB);
  static const Color textMuted = Color(0xFF6B7280);

  // حالات
  static const Color success = Color(0xFF3BB273);
  static const Color danger = Color(0xFFE5484D);
  static const Color warning = Color(0xFFE8A73B);
  static const Color info = Color(0xFF4A9EE0);

  // خطوط وحدود
  static const Color border = Color(0xFF262B38);
  static const Color divider = Color(0xFF1F2430);

  // ألوان القطاعات (تُستخدم كوسوم Chips للمشاريع)
  static const Map<String, Color> sectorColors = {
    'تقنية': Color(0xFF4A9EE0),
    'عقارات': Color(0xFFE8A73B),
    'تجارة': Color(0xFF3BB273),
    'صناعة': Color(0xFFB07AE0),
    'زراعة': Color(0xFF6FBF73),
    'سياحة': Color(0xFFE0764A),
  };
}
