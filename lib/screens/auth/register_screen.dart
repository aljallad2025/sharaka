import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/supabase_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../routes/app_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String _selectedRole = AppConstants.roleInvestor;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await SupabaseService.instance.signUp(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
        fullName: _nameCtrl.text.trim(),
        role: _selectedRole,
      );
      if (!mounted) return;
      context.go(AppRoutes.kyc);
    } catch (e) {
      setState(() => _errorMessage = 'تعذر إنشاء الحساب، حاول مرة أخرى');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('حساب جديد')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Text('اختر نوع حسابك', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _RoleCard(
                        title: 'مستثمر',
                        subtitle: 'استعرض المشاريع واستثمر',
                        icon: Icons.trending_up_rounded,
                        selected: _selectedRole == AppConstants.roleInvestor,
                        onTap: () => setState(() => _selectedRole = AppConstants.roleInvestor),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _RoleCard(
                        title: 'صاحب مشروع',
                        subtitle: 'اعرض مشروعك واجمع تمويل',
                        icon: Icons.storefront_outlined,
                        selected: _selectedRole == AppConstants.roleOwner,
                        onTap: () => setState(() => _selectedRole = AppConstants.roleOwner),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'الاسم الكامل',
                  controller: _nameCtrl,
                  prefixIcon: Icons.person_outline,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'أدخل اسمك' : null,
                ),
                const SizedBox(height: 16),
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
                CustomButton(label: 'إنشاء الحساب', onPressed: _register, isLoading: _isLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryGreen.withOpacity(0.08) : Colors.white,
          border: Border.all(
            color: selected ? AppColors.primaryGreen : Colors.grey.shade300,
            width: selected ? 1.6 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: selected ? AppColors.primaryGreen : Colors.grey.shade600),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
