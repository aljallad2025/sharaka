import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/supabase_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _goalCtrl = TextEditingController();
  final _sharesCtrl = TextEditingController();

  String _sector = AppConstants.sectors.first;
  String _country = AppConstants.targetCountries.first;
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      final goal = double.parse(_goalCtrl.text);
      final shares = double.parse(_sharesCtrl.text);
      await SupabaseService.instance.createProject({
        'title': _titleCtrl.text.trim(),
        'description': _descCtrl.text.trim(),
        'sector': _sector,
        'country': _country,
        'funding_goal': goal,
        'shares_offered_percentage': shares,
        'price_per_share_percent': goal / (shares == 0 ? 1 : shares),
        'amount_raised': 0,
        'image_urls': <String>[],
        'document_urls': <String>[],
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرسال المشروع للمراجعة من الإدارة ✅')),
      );
      context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر حفظ المشروع، تأكد من البيانات وحاول مجدداً')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مشروع جديد')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.pending.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.pending, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'كل مشروع يخضع لمراجعة الإدارة قبل ظهوره للمستثمرين',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              CustomTextField(
                label: 'اسم المشروع',
                controller: _titleCtrl,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'أدخل اسم المشروع' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'وصف المشروع',
                controller: _descCtrl,
                maxLines: 4,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'أدخل وصف المشروع' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _sector,
                decoration: const InputDecoration(labelText: 'القطاع'),
                items: AppConstants.sectors
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _sector = v ?? _sector),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _country,
                decoration: const InputDecoration(labelText: 'الدولة'),
                items: AppConstants.targetCountries
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _country = v ?? _country),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'المبلغ المستهدف (ر.ع)',
                controller: _goalCtrl,
                keyboardType: TextInputType.number,
                validator: (v) => (double.tryParse(v ?? '') == null) ? 'أدخل رقم صحيح' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'نسبة الأسهم المعروضة (%)',
                controller: _sharesCtrl,
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = double.tryParse(v ?? '');
                  if (n == null || n <= 0 || n > 100) return 'أدخل نسبة بين 1 و 100';
                  return null;
                },
              ),
              const SizedBox(height: 28),
              CustomButton(label: 'إرسال المشروع للمراجعة', onPressed: _submit, isLoading: _isSubmitting),
            ],
          ),
        ),
      ),
    );
  }
}
