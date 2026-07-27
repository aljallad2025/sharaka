import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/mock_data.dart';
import '../../models/project_model.dart';
import '../../widgets/common_widgets.dart';

class InvestScreen extends StatefulWidget {
  final String projectId;
  const InvestScreen({super.key, required this.projectId});

  @override
  State<InvestScreen> createState() => _InvestScreenState();
}

class _InvestScreenState extends State<InvestScreen> {
  final _amountCtrl = TextEditingController();
  String _paymentMethod = 'card';
  bool _processing = false;
  late InvestmentProject project;

  @override
  void initState() {
    super.initState();
    project = mockProjects.firstWhere((p) => p.id == widget.projectId, orElse: () => mockProjects.first);
    _amountCtrl.text = project.minInvestment.toStringAsFixed(0);
  }

  double get _amount => double.tryParse(_amountCtrl.text) ?? 0;
  double get _shares => project.sharePrice == 0 ? 0 : _amount / project.sharePrice;
  double get _ownership => project.totalShares == 0 ? 0 : (_shares / project.totalShares) * 100;

  Future<void> _confirmInvestment() async {
    if (_amount < project.minInvestment) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('الحد الأدنى للاستثمار ${project.minInvestment.toStringAsFixed(0)} ر.ع')),
      );
      return;
    }
    setState(() => _processing = true);
    // TODO: ربط بوابة الدفع (Thawani) + إنشاء سجل استثمار بحالة pending بجدول investments
    // ثم بعد تأكيد الدفع تحديث الحالة إلى confirmed وتحديث raised_amount بالمشروع
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() => _processing = false);
      _showSuccessSheet();
    }
  }

  void _showSuccessSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isDismissible: false,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
              child: const Icon(Icons.check, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 18),
            const Text('تم تأكيد استثمارك!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('امتلكت ${_shares.toStringAsFixed(1)} سهم في "${project.title}"',
                textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
            const SizedBox(height: 24),
            GoldButton(
              label: 'عرض محفظتي',
              onPressed: () {
                context.pop();
                context.go('/investor/portfolio');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تأكيد الاستثمار')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(project.coverImageUrl, width: 56, height: 56, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(project.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 3),
                          Text('${project.sharePrice.toStringAsFixed(0)} ر.ع / السهم',
                              style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Text('كم تحب تستثمر؟', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(height: 14),
              AppTextField(
                label: 'المبلغ (ر.ع)',
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                hint: project.minInvestment.toStringAsFixed(0),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: [
                  for (final v in [project.minInvestment, project.minInvestment * 2, project.minInvestment * 5])
                    ActionChip(
                      label: Text('${v.toStringAsFixed(0)} ر.ع'),
                      onPressed: () => setState(() => _amountCtrl.text = v.toStringAsFixed(0)),
                      backgroundColor: AppColors.surfaceElevated,
                      labelStyle: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.gold.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    _SummaryRow(label: 'عدد الأسهم', value: _shares.toStringAsFixed(2)),
                    _SummaryRow(label: 'نسبة ملكيتك بالمشروع', value: '${_ownership.toStringAsFixed(3)}٪'),
                    _SummaryRow(label: 'العائد السنوي المتوقع', value: '${project.expectedAnnualReturn.toStringAsFixed(0)}٪'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('طريقة الدفع', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              _PaymentOption(
                label: 'بطاقة ائتمانية / مدى',
                icon: Icons.credit_card,
                selected: _paymentMethod == 'card',
                onTap: () => setState(() => _paymentMethod = 'card'),
              ),
              const SizedBox(height: 10),
              _PaymentOption(
                label: 'تحويل بنكي',
                icon: Icons.account_balance_outlined,
                selected: _paymentMethod == 'bank',
                onTap: () => setState(() => _paymentMethod = 'bank'),
              ),
              const SizedBox(height: 10),
              _PaymentOption(
                label: 'رصيد المحفظة',
                icon: Icons.account_balance_wallet_outlined,
                selected: _paymentMethod == 'wallet',
                onTap: () => setState(() => _paymentMethod = 'wallet'),
              ),
              const SizedBox(height: 32),
              GoldButton(label: 'تأكيد والدفع', loading: _processing, onPressed: _confirmInvestment),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.gold)),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _PaymentOption({required this.label, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.gold : AppColors.border, width: selected ? 1.6 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: selected ? AppColors.gold : AppColors.textMuted),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 13.5))),
            Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 20, color: selected ? AppColors.gold : AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
