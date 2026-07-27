import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();
  late final Animation<double> _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  late final Animation<double> _scale =
      Tween(begin: 0.85, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

  @override
  void initState() {
    super.initState();
    // TODO: استبدال المنطق بفحص حالة تسجيل الدخول عبر Supabase (auth.currentSession)
    // ثم التوجيه: لو مسجّل -> الرئيسية حسب الدور، لو لأ -> Onboarding
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) context.go('/onboarding');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkGradient),
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // شعار مبدئي (Placeholder) - بانتظار ملف الشعار الرسمي
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(color: AppColors.gold.withOpacity(0.35), blurRadius: 40, spreadRadius: 4),
                      ],
                    ),
                    child: const Icon(Icons.handshake_rounded, size: 46, color: Color(0xFF1A1400)),
                  ),
                  const SizedBox(height: 22),
                  ShaderMask(
                    shaderCallback: (bounds) => AppColors.goldGradient.createShader(bounds),
                    child: const Text(
                      'شراكة',
                      style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'استثمر في المستقبل، سهماً بسهم',
                    style: TextStyle(fontSize: 13, color: AppColors.textMuted),
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
