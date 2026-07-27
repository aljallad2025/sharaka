import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/supabase_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../routes/app_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await SupabaseService.instance.signIn(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );
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
    } catch (e) {
      setState(() => _errorMessage = 'فشل تسجيل الدخول، تأكد من البريد وكلمة المرور');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 40),
                const Text('أهلاً بعودتك 👋',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('سجّل الدخول لمتابعة استثماراتك أو مشاريعك',
                    style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 32),
                CustomTextField(
                  label: 'البريد الإلكتروني',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (v) => (v == null || !v.contains('@')) ? 'أدخل بريد إلكتروني صحيح' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'كلمة المرور',
                  controller: _passCtrl,
                  obscureText: true,
                  prefixIcon: Icons.lock_outline,
                  validator: (v) => (v == null || v.length < 6) ? 'كلمة المرور 6 أحرف على الأقل' : null,
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(_errorMessage!, style: TextStyle(color: AppColors.danger, fontSize: 13)),
                ],
                const SizedBox(height: 28),
                CustomButton(label: 'تسجيل الدخول', onPressed: _login, isLoading: _isLoading),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('ليس لديك حساب؟'),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.register),
                      child: const Text('إنشاء حساب جديد'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
