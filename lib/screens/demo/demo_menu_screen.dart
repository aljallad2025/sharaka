import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../routes/app_router.dart';

/// شاشة "وضع المعاينة" — تسمح بتصفّح كل شاشات التطبيق مباشرة
/// بدون تسجيل دخول وبدون ربط Supabase. مفيدة لعرض التصميم فقط.
/// ملاحظة: الشاشات اللي بتجيب بيانات من السيرفر (زي قائمة المشاريع)
/// رح تظهر فاضية أو فيها مؤشر تحميل لأنه ما في باكند حقيقي متصل.
class DemoMenuScreen extends StatelessWidget {
  const DemoMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('وضع المعاينة — كل الشاشات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.lightGold.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'هاي الشاشة مؤقتة لعرض تصميم التطبيق فقط. الشاشات اللي بتحتاج بيانات '
              'حقيقية (مشاريع، استثمارات...) رح تظهر فاضية لأنه Supabase مش متصل بعد.',
              style: TextStyle(fontSize: 13, height: 1.5),
            ),
          ),
          const SizedBox(height: 20),
          _Section(title: 'المصادقة (Auth)', children: [
            _DemoTile(label: 'تسجيل الدخول', onTap: () => context.push(AppRoutes.login)),
            _DemoTile(label: 'إنشاء حساب', onTap: () => context.push(AppRoutes.register)),
            _DemoTile(label: 'التحقق (KYC)', onTap: () => context.push(AppRoutes.kyc)),
          ]),
          _Section(title: 'المستثمر (Investor)', children: [
            _DemoTile(label: 'الرئيسية / استعراض المشاريع', onTap: () => context.push(AppRoutes.investorHome)),
            _DemoTile(label: 'تفاصيل مشروع', onTap: () => context.push('/investor/project/demo')),
            _DemoTile(label: 'شاشة الاستثمار', onTap: () => context.push('/investor/project/demo/invest')),
            _DemoTile(label: 'محفظتي', onTap: () => context.push(AppRoutes.portfolio)),
          ]),
          _Section(title: 'صاحب المشروع (Owner)', children: [
            _DemoTile(label: 'لوحة صاحب المشروع', onTap: () => context.push(AppRoutes.ownerDashboard)),
            _DemoTile(label: 'إضافة مشروع', onTap: () => context.push(AppRoutes.addProject)),
            _DemoTile(label: 'مستثمرو المشروع', onTap: () => context.push('/owner/project/demo/investors')),
          ]),
          _Section(title: 'عام (Common)', children: [
            _DemoTile(label: 'الإشعارات', onTap: () => context.push(AppRoutes.notifications)),
            _DemoTile(label: 'الملف الشخصي', onTap: () => context.push(AppRoutes.profile)),
          ]),
          _Section(title: 'الإدارة (Admin)', children: [
            _DemoTile(label: 'لوحة تحكم الأدمن', onTap: () => context.push(AppRoutes.admin)),
          ]),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.primaryGreen,
            ),
          ),
        ),
        ...children,
        const SizedBox(height: 12),
      ],
    );
  }
}

class _DemoTile extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _DemoTile({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(label),
        trailing: const Icon(Icons.chevron_left),
        onTap: onTap,
      ),
    );
  }
}
