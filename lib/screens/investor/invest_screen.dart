import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/supabase_service.dart';
import '../../models/project_model.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class InvestScreen extends StatefulWidget {
  final String projectId;
  const InvestScreen({super.key, required this.projectId});

  @override
  State<InvestScreen> createState() => _InvestScreenState();
}

class _InvestScreenState extends State<InvestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  ProjectModel? _project;
  bool _isLoading = true;
  bool _isSubmitting = false;
  double _computedSharePercent = 0;

  @override
  void initState() {
    super.initState();
    _load();
    _amountCtrl.addListener(_recalculate);
  }

  Future<void> _load() async {
    final data = await SupabaseService.instance.fetchProjectById(widget.projectId);
    setState(() {
      _project = data != null ? ProjectModel.fromMap(data) : null;
      _isLoading = false;
    });
  }

  void _recalculate() {
    final amount = double.tryParse(_amountCtrl.text) ?? 0;
    final price = _project?.pricePerSharePercent ?? 0;
    setState(() {
      _computedSharePercent = price > 0 ? amount / price : 0;
    });
  }

  Future<void> _confirmInvestment() async {
    if (!_formKey.currentState!.validate() || _project == null) return;
    setState(() => _isSubmitting = true);
    try {
      final amount = double.parse(_amountCtrl.text);
      await SupabaseService.instance.createInvestment(
        projectId: _project!.id,
        amount: amount,
        sharesPercentage: _computedSharePercent,
      );
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('تم استلام طلب الاستثمار'),
          content: const Text(
            'رح تتحول لبوابة الدفع لإتمام العملية. بعد تأكيد الدفع، رح تظهر الحصة بمحفظتك الاستثمارية.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.pop();
                context.pop();
              },
              child: const Text('حسناً'),
            ),
          ],
        ),
      );
      // TODO: ربط بوابة الدفع الخليجية (Thawani / Tap / PayTabs) هنا
      // بعد نجاح الدفع فعلياً، تُحدَّث حالة الاستثمار إلى completed عبر webhook من طرف السيرفر.
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر تنفيذ العملية، حاول مجدداً')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _amountCtrl.removeListener(_recalculate);
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تأكيد الاستثمار')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _project == null
              ? const Center(child: Text('تعذر إيجاد المشروع'))
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_project!.title,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 6),
                                Text(
                                  'سعر كل 1% من الأسهم: ${_project!.pricePerSharePercent.toStringAsFixed(0)} ر.ع',
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'المبلغ الذي تريد استثماره (ر.ع)',
                          controller: _amountCtrl,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.payments_outlined,
                          validator: (v) {
                            final n = double.tryParse(v ?? '');
                            if (n == null || n <= 0) return 'أدخل مبلغاً صحيحاً';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('نسبة الأسهم التقديرية', style: TextStyle(fontWeight: FontWeight.w600)),
                              Text(
                                '${_computedSharePercent.toStringAsFixed(2)}%',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.deepGreen),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        CustomButton(
                          label: 'متابعة للدفع',
                          onPressed: _confirmInvestment,
                          isLoading: _isSubmitting,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'بالمتابعة، أنت تقر بأن هذا الاستثمار خاضع لشروط منصة شراكة وموافق عليه بعد اكتمال الترخيص التنظيمي.',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
