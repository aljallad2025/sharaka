import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/common_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('حسابي', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(gradient: AppColors.goldGradient, shape: BoxShape.circle),
                  child: const Icon(Icons.person, color: Color(0xFF1A1400), size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('ثائر الجلاد', style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      const Text('thaer@example.com', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      const SizedBox(height: 8),
                      const StatusBadge(label: 'الهوية موثّقة', color: AppColors.success),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _SectionLabel('الحساب'),
          _ProfileTile(icon: Icons.person_outline, label: 'تعديل البيانات الشخصية', onTap: () {}),
          _ProfileTile(icon: Icons.verified_user_outlined, label: 'حالة توثيق الهوية (KYC)', onTap: () {}),
          _ProfileTile(icon: Icons.account_balance_wallet_outlined, label: 'المحفظة والدفع', onTap: () {}),
          _ProfileTile(icon: Icons.swap_horiz_outlined, label: 'التبديل لحساب صاحب مشروع', onTap: () {}),
          const SizedBox(height: 16),
          _SectionLabel('الدعم'),
          _ProfileTile(icon: Icons.description_outlined, label: 'الشروط والأحكام', onTap: () {}),
          _ProfileTile(icon: Icons.shield_outlined, label: 'سياسة الخصوصية', onTap: () {}),
          _ProfileTile(icon: Icons.support_agent_outlined, label: 'تواصل مع الدعم', onTap: () {}),
          const SizedBox(height: 16),
          _SectionLabel('عام'),
          _ProfileTile(icon: Icons.language_outlined, label: 'اللغة', trailing: 'العربية', onTap: () {}),
          _ProfileTile(icon: Icons.dark_mode_outlined, label: 'المظهر', trailing: 'داكن', onTap: () {}),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => context.go('/login'),
            icon: const Icon(Icons.logout, size: 18, color: AppColors.danger),
            label: const Text('تسجيل الخروج', style: TextStyle(color: AppColors.danger)),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.danger)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 4),
      child: Text(text, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.textMuted)),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback onTap;

  const _ProfileTile({required this.icon, required this.label, this.trailing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 13.5, color: AppColors.textPrimary))),
            if (trailing != null)
              Text(trailing!, style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_back_ios_new, size: 13, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
