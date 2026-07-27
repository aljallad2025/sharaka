import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});

  ({Color bg, Color fg, String label}) get _style {
    switch (status) {
      case 'active':
        return (bg: AppColors.success.withOpacity(0.12), fg: AppColors.success, label: 'نشط');
      case 'funded':
        return (bg: AppColors.gold.withOpacity(0.15), fg: const Color(0xFF8A6D00), label: 'مكتمل التمويل');
      case 'pending_review':
      case 'pending_payment':
      case 'pending':
        return (bg: AppColors.pending.withOpacity(0.15), fg: const Color(0xFF8A6500), label: 'قيد المراجعة');
      case 'rejected':
      case 'failed':
        return (bg: AppColors.danger.withOpacity(0.1), fg: AppColors.danger, label: 'مرفوض');
      case 'closed':
        return (bg: Colors.grey.withOpacity(0.15), fg: Colors.grey.shade700, label: 'مغلق');
      case 'approved':
        return (bg: AppColors.success.withOpacity(0.12), fg: AppColors.success, label: 'موثّق');
      case 'completed':
        return (bg: AppColors.success.withOpacity(0.12), fg: AppColors.success, label: 'مكتمل');
      case 'not_submitted':
        return (bg: Colors.grey.withOpacity(0.15), fg: Colors.grey.shade700, label: 'لم يُرسل بعد');
      default:
        return (bg: Colors.grey.withOpacity(0.15), fg: Colors.grey.shade700, label: status);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _style;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: s.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        s.label,
        style: TextStyle(color: s.fg, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
