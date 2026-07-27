import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/common_widgets.dart';

class RegisterScreen extends StatefulWidget {
  final String role; // investor | projectOwner
  const RegisterScreen({super.key, required this.role});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String _country = 'عُمان';
  bool _loading = false;
  bool _agree = false;

  final _countries = ['عُمان', 'البحرين', 'الإمارات', 'السعودية', 'الكويت', 'قطر'];

  Future<void> _register() async {
    if (!_agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لازم توافق على الشروط والأحكام أولاً')),
      );
      return;
    }
    setState(() => _loading = true);
    // TODO: ربط Supabase Auth signUp + إنشاء سجل بجدول profiles يتضمن role
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) {
      setState(() => _loading = false);
      context.go('/kyc');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOwner = widget.role == 'projectOwner';
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('إنشاء حساب ${isOwner ? "صاحب مشروع" : "مستثمر"}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              const Text('عبّي بياناتك للمتابعة', style: TextStyle(fontSize: 13.5, color: AppColors.textMuted)),
              const SizedBox(height: 28),
              AppTextField(label: 'الاسم الكامل', controller: _nameCtrl, hint: 'مثال: أحمد السعدي'),
              const SizedBox(height: 16),
              AppTextField(
                  label: 'البريد الإلكتروني',
                  controller: _emailCtrl,
                  hint: 'example@email.com',
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              AppTextField(
                  label: 'رقم الجوال',
                  controller: _phoneCtrl,
                  hint: '+968 9xxx xxxx',
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('الدولة', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _country,
                        isExpanded: true,
                        dropdownColor: AppColors.surfaceElevated,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                        items: _countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (v) => setState(() => _country = v!),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppTextField(label: 'كلمة المرور', controller: _passCtrl, hint: '••••••••', obscureText: true),
              const SizedBox(height: 18),
              InkWell(
                onTap: () => setState(() => _agree = !_agree),
                child: Row(
                  children: [
                    Checkbox(
                      value: _agree,
                      activeColor: AppColors.gold,
                      onChanged: (v) => setState(() => _agree = v ?? false),
                    ),
                    const Expanded(
                      child: Text('أوافق على الشروط والأحكام وسياسة الخصوصية الخاصة بمنصة شراكة',
                          style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GoldButton(label: 'إنشاء الحساب', loading: _loading, onPressed: _register),
              const SizedBox(height: 20),
              Center(
                child: TextButton(onPressed: () => context.go('/login'), child: const Text('عندك حساب؟ تسجيل الدخول')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
