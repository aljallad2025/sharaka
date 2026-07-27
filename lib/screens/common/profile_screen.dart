import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/supabase_service.dart';
import '../../models/user_model.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/custom_button.dart';
import '../../routes/app_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserModel?> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<UserModel?> _load() async {
    final data = await SupabaseService.instance.getMyProfile();
    return data != null ? UserModel.fromMap(data) : null;
  }

  Future<void> _logout() async {
    await SupabaseService.instance.signOut();
    if (mounted) context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الملف الشخصي')),
      body: FutureBuilder<UserModel?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = snapshot.data;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: CircleAvatar(
                  radius: 44,
                  backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
                  child: Text(
                    (user?.fullName.isNotEmpty ?? false) ? user!.fullName.substring(0, 1) : '؟',
                    style: const TextStyle(fontSize: 32, color: AppColors.primaryGreen, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Text(user?.fullName ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Center(
                child: Text(user?.email ?? '', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ),
              const SizedBox(height: 10),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Chip(
                      label: Text(
                        user?.isOwner == true ? 'صاحب مشروع' : (user?.isAdmin == true ? 'إدارة' : 'مستثمر'),
                        style: const TextStyle(fontSize: 11.5),
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                    const SizedBox(width: 8),
                    StatusBadge(status: user?.kycStatus ?? 'not_submitted'),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              _SettingsTile(icon: Icons.verified_user_outlined, title: 'التحقق من الهوية (KYC)', onTap: () => context.push(AppRoutes.kyc)),
              _SettingsTile(icon: Icons.lock_outline, title: 'تغيير كلمة المرور', onTap: () {}),
              _SettingsTile(icon: Icons.language, title: 'اللغة / Language', onTap: () {}),
              _SettingsTile(icon: Icons.description_outlined, title: 'الشروط والأحكام', onTap: () {}),
              _SettingsTile(icon: Icons.headset_mic_outlined, title: 'الدعم الفني', onTap: () {}),
              const SizedBox(height: 24),
              CustomButton(
                label: 'تسجيل الخروج',
                variant: ButtonVariant.outline,
                onPressed: _logout,
                icon: Icons.logout,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingsTile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryGreen),
        title: Text(title, style: const TextStyle(fontSize: 14)),
        trailing: const Icon(Icons.chevron_left),
        onTap: onTap,
      ),
    );
  }
}
