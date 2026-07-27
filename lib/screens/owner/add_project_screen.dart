import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/common_widgets.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  int _step = 0;
  final _titleCtrl = TextEditingController();
  final _shortDescCtrl = TextEditingController();
  final _fullDescCtrl = TextEditingController();
  final _targetCtrl = TextEditingController();
  final _sharePriceCtrl = TextEditingController();
  final _minInvestCtrl = TextEditingController();
  final _returnCtrl = TextEditingController();
  String _sector = 'تقنية';
  bool _submitting = false;

  final _sectors = ['تقنية', 'عقارات', 'تجارة', 'صناعة', 'زراعة', 'سياحة'];

  final _steps = ['البيانات الأساسية', 'التفاصيل والوصف', 'الأسهم والتمويل', 'المستندات والمراجعة'];

  Future<void> _submit() async {
    setState(() => _submitting = true);
    // TODO: رفع المستندات لـ Supabase Storage + إدراج سجل بجدول projects بحالة pendingReview
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() => _submitting = false);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Text('تم إرسال مشروعك للمراجعة'),
          content: const Text('رح يتم إشعارك بعد ما يراجع فريقنا المشروع ويوافق عليه (عادة خلال 2-3 أيام عمل)',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
                context.pop();
              },
              child: const Text('حسناً'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مشروع جديد')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  for (int i = 0; i < _steps.length; i++) ...[
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: i <= _step ? AppColors.gold : AppColors.border,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    if (i != _steps.length - 1) const SizedBox(width: 6),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(_steps[_step],
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.gold)),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildStepContent(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  if (_step > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _step--),
                        child: const Text('السابق'),
                      ),
                    ),
                  if (_step > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: GoldButton(
                      label: _step == _steps.length - 1 ? 'إرسال للمراجعة' : 'التالي',
                      loading: _submitting,
                      onPressed: () {
                        if (_step == _steps.length - 1) {
                          _submit();
                        } else {
                          setState(() => _step++);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(label: 'اسم المشروع', controller: _titleCtrl, hint: 'مثال: مزرعة عمودية ذكية'),
            const SizedBox(height: 16),
            const Text('القطاع', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _sectors
                  .map((s) => ChoiceChip(
                        label: Text(s),
                        selected: _sector == s,
                        onSelected: (_) => setState(() => _sector = s),
                        selectedColor: AppColors.gold,
                        backgroundColor: AppColors.surfaceElevated,
                        labelStyle: TextStyle(color: _sector == s ? const Color(0xFF1A1400) : AppColors.textSecondary, fontSize: 12.5, fontWeight: FontWeight.w700),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            AppTextField(label: 'وصف مختصر', controller: _shortDescCtrl, maxLines: 2, hint: 'جملة أو جملتين تلخص فكرة المشروع'),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: 'الوصف الكامل للمشروع',
              controller: _fullDescCtrl,
              maxLines: 8,
              hint: 'اشرح فكرة المشروع، النموذج التجاري، وليش يستحق الاستثمار فيه...',
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(label: 'المبلغ المستهدف (ر.ع)', controller: _targetCtrl, keyboardType: TextInputType.number, hint: '100000'),
            const SizedBox(height: 16),
            AppTextField(label: 'سعر السهم الواحد (ر.ع)', controller: _sharePriceCtrl, keyboardType: TextInputType.number, hint: '50'),
            const SizedBox(height: 16),
            AppTextField(label: 'الحد الأدنى للاستثمار (ر.ع)', controller: _minInvestCtrl, keyboardType: TextInputType.number, hint: '250'),
            const SizedBox(height: 16),
            AppTextField(label: 'العائد السنوي المتوقع (%)', controller: _returnCtrl, keyboardType: TextInputType.number, hint: '18'),
          ],
        );
      case 3:
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DocUploadTile(title: 'صورة الغلاف الرئيسية'),
            const SizedBox(height: 12),
            _DocUploadTile(title: 'خطة العمل (Business Plan) - PDF'),
            const SizedBox(height: 12),
            _DocUploadTile(title: 'السجل التجاري / الترخيص'),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
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
                      'بعد الإرسال، بيتم مراجعة المشروع من فريق شراكة قبل نشره للمستثمرين، للتأكد من اكتمال البيانات والمستندات القانونية',
                      style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
    }
  }
}

class _DocUploadTile extends StatefulWidget {
  final String title;
  const _DocUploadTile({required this.title});

  @override
  State<_DocUploadTile> createState() => _DocUploadTileState();
}

class _DocUploadTileState extends State<_DocUploadTile> {
  bool _uploaded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => _uploaded = true), // TODO: ربط file_picker / image_picker فعلياً
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _uploaded ? AppColors.success : AppColors.border),
        ),
        child: Row(
          children: [
            Icon(_uploaded ? Icons.check_circle_rounded : Icons.upload_file_outlined,
                color: _uploaded ? AppColors.success : AppColors.textMuted),
            const SizedBox(width: 12),
            Expanded(child: Text(widget.title, style: const TextStyle(fontSize: 13.5))),
            Text(_uploaded ? 'تم الرفع' : 'رفع الملف',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _uploaded ? AppColors.success : AppColors.gold)),
          ],
        ),
      ),
    );
  }
}
