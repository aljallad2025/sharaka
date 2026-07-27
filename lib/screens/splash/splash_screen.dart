import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/supabase_service.dart';
import '../../routes/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _decideNextRoute();
  }

  Future<void> _decideNextRoute() async {
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    final user = SupabaseService.instance.currentUser;
    if (user == null) {
      context.go(AppRoutes.login);
      return;
    }

    final profile = await SupabaseService.instance.getMyProfile();
    if (!mounted) return;

    final role = profile?['role'] ?? 'investor';
    switch (role) {
      case 'project_owner':
        context.go(AppRoutes.ownerDashboard);
        break;
      case 'admin':
        context.go(AppRoutes.admin);
        break;
      default:
        context.go(AppRoutes.investorHome);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: AppColors.gold.withOpacity(0.4), blurRadius: 24, spreadRadius: 2),
                ],
              ),
              child: const Center(
                child: Text(
                  'ش',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'شراكة',
              style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Sharaka — استثمر في مشاريع الخليج',
              style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.gold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
