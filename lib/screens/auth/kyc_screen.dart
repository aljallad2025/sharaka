import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/supabase_service.dart';
import '../../widgets/custom_button.dart';
import '../../routes/app_router.dart';

/// شاشة التحقق من الهوية (KYC) - أساسية لأي منصة أسهم قبل تفعيل الاستثمار الفعلي
class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  File? _idFrontImage;
  File? _selfieImage;
  bool _isSubmitting = false;

  Future<void> _pickImage(bool isSelfie) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: isSelfie ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;
    setState(() {
      if (isSelfie) {
        _selfieImage = File(picked.path);
      } else {
        _idFrontImage = File(picked.path);
      }
    });
  }

  Future<void> _submit() async {
    if (_idFrontImage == null || _selfieImage == null) return;
    setState(() => _isSubmitting = true);
    try {
      final idBytes = await _idFrontImage!.readAsBytes();
      final selfieBytes = await _selfieImage!.readAsBytes();
      final uid = SupabaseService.instance.currentUserId ?? 'unknown';

      await SupabaseService.instance.uploadFile(
        bucket: 'kyc-documents',
        path: '$uid/id_front.jpg',
        bytes: idBytes,
      );
      await SupabaseService.instance.uploadFile(
        bucket: 'kyc-documents',
        path: '$uid/selfie.jpg',
        bytes: selfieBytes,
      );

      await SupabaseService.instance.updateProfile({'kyc_status': 'pending'});

      if (!mounted) return;
      context.go(AppRoutes.investorHome);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر رفع المستندات، حاول مرة أخرى')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التحقق من الهوية')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.pending.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.pending),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'التحقق من الهوية مطلوب قبل تفعيل أي عملية استثمار أو استلام تمويل، تماشياً مع متطلبات الجهات الرقابية.',
                      style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _UploadTile(
              title: 'صورة البطاقة الشخصية / جواز السفر',
              file: _idFrontImage,
              icon: Icons.badge_outlined,
              onTap: () => _pickImage(false),
            ),
            const SizedBox(height: 16),
            _UploadTile(
              title: 'صورة سيلفي واضحة',
              file: _selfieImage,
              icon: Icons.camera_alt_outlined,
              onTap: () => _pickImage(true),
            ),
            const SizedBox(height: 28),
            CustomButton(
              label: 'إرسال للمراجعة',
              isLoading: _isSubmitting,
              onPressed: (_idFrontImage != null && _selfieImage != null) ? _submit : null,
            ),
            const SizedBox(height: 10),
            CustomButton(
              label: 'تخطي الآن (يمكنك إكمالها لاحقاً)',
              variant: ButtonVariant.text,
              onPressed: () => context.go(AppRoutes.investorHome),
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadTile extends StatelessWidget {
  final String title;
  final File? file;
  final IconData icon;
  final VoidCallback onTap;

  const _UploadTile({
    required this.title,
    required this.file,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: file != null ? AppColors.success : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(file != null ? Icons.check_circle : icon,
                color: file != null ? AppColors.success : AppColors.primaryGreen),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                file != null ? 'تم الرفع بنجاح ✓' : title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(Icons.chevron_left),
          ],
        ),
      ),
    );
  }
}
