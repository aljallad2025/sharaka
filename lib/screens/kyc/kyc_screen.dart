import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/common_widgets.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  bool _idFrontUploaded = false;
  bool _idBackUploaded = false;
  bool _selfieUploaded = false;
  bool _submitting = false;

  bool get _canSubmit => _idFrontUploaded && _idBackUploaded && _selfieUploaded;

  Future<void> _pickFile(String type) async {
    // TODO: استخدام image_picker/file_picker فعلياً لرفع الصورة إلى Supabase Storage (bucket: kyc_documents)
    setState(() {
      if (type == 'front') _idFrontUploaded = true;
      if (type == 'back') _idBackUploaded = true;
      if (type == 'selfie') _selfieUploaded = true;
    });
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    // TODO: تحديث kyc_status = pending بجدول profiles + إشعار للأدمن للمراجعة
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) context.go('/investor/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('توثيق الهوية')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.info.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.info, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'التحقق من الهوية إلزامي قبل أي عملية استثمار أو استقبال تمويل، بحسب متطلبات الجهات التنظيمية',
                        style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              _UploadTile(
                title: 'الوجه الأمامي للبطاقة/الجواز',
                uploaded: _idFrontUploaded,
                onTap: () => _pickFile('front'),
              ),
              const SizedBox(height: 14),
              _UploadTile(
                title: 'الوجه الخلفي للبطاقة',
                uploaded: _idBackUploaded,
                onTap: () => _pickFile('back'),
              ),
              const SizedBox(height: 14),
              _UploadTile(
                title: 'صورة سيلفي واضحة',
                uploaded: _selfieUploaded,
                onTap: () => _pickFile('selfie'),
              ),
              const SizedBox(height: 32),
              GoldButton(
                label: 'إرسال للمراجعة',
                loading: _submitting,
                onPressed: _canSubmit ? _submit : null,
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => context.go('/investor/home'),
                  child: const Text('تخطي الآن، أكمل لاحقاً من الملف الشخصي'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UploadTile extends StatelessWidget {
  final String title;
  final bool uploaded;
  final VoidCallback onTap;

  const _UploadTile({required this.title, required this.uploaded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: uploaded ? AppColors.success : AppColors.border),
        ),
        child: Row(
          children: [
            Icon(
              uploaded ? Icons.check_circle_rounded : Icons.upload_file_outlined,
              color: uploaded ? AppColors.success : AppColors.textMuted,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
            ),
            Text(uploaded ? 'تم الرفع' : 'رفع',
                style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: uploaded ? AppColors.success : AppColors.gold)),
          ],
        ),
      ),
    );
  }
}
