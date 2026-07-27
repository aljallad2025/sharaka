import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text('وش بيناسبك أكثر؟',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              const Text('اختر نوع حسابك، وممكن تضيف الدور التاني لاحقاً من الإعدادات',
                  style: TextStyle(fontSize: 13.5, color: AppColors.textMuted)),
              const SizedBox(height: 32),
              _RoleCard(
                icon: Icons.savings_outlined,
                title: 'مستثمر',
                subtitle: 'تصفّح المشاريع واستثمر بأسهم حقيقية وتابع محفظتك',
                onTap: () => context.go('/register?role=investor'),
              ),
              const SizedBox(height: 16),
              _RoleCard(
                icon: Icons.storefront_outlined,
                title: 'صاحب مشروع',
                subtitle: 'اعرض مشروعك، حدد نسبة الأسهم، واحصل على تمويل من مستثمرين',
                onTap: () => context.go('/register?role=projectOwner'),
              ),
              const Spacer(),
              Center(
                child: TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('عندي حساب مسبقاً؟ تسجيل الدخول'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _RoleCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: const Color(0xFF1A1400), size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted, height: 1.5)),
                ],
              ),
            ),
            const Icon(Icons.arrow_back_ios_new, size: 15, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
