import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/common_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  Future<void> _login() async {
    setState(() => _loading = true);
    // TODO: ربط Supabase Auth
    // await supabase.auth.signInWithPassword(email: _emailCtrl.text, password: _passCtrl.text);
    // ثم التوجيه حسب دور المستخدم من جدول profiles
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) {
      setState(() => _loading = false);
      context.go('/investor/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('تسجيل الدخول', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              const Text('أهلاً فيك من جديد في شراكة', style: TextStyle(fontSize: 13.5, color: AppColors.textMuted)),
              const SizedBox(height: 32),
              AppTextField(
                label: 'البريد الإلكتروني',
                controller: _emailCtrl,
                hint: 'example@email.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 18),
              AppTextField(
                label: 'كلمة المرور',
                controller: _passCtrl,
                hint: '••••••••',
                obscureText: _obscure,
                suffixIcon: IconButton(
                  icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textMuted, size: 20),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(onPressed: () {}, child: const Text('نسيت كلمة المرور؟')),
              ),
              const SizedBox(height: 12),
              GoldButton(label: 'دخول', loading: _loading, onPressed: _login),
              const SizedBox(height: 24),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('ما عندك حساب؟', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                    TextButton(onPressed: () => context.go('/role-selection'), child: const Text('إنشاء حساب')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
