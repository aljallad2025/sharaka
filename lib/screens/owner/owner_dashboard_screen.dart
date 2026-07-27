import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/mock_data.dart';
import '../../widgets/common_widgets.dart';

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final myProjects = mockProjects.take(2).toList();
    final totalRaised = myProjects.fold<double>(0, (s, p) => s + p.raisedAmount);
    final totalInvestors = myProjects.fold<int>(0, (s, p) => s + p.investorsCount);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('لوحة التحكم', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.surfaceElevated, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.notifications_outlined, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: StatTile(
                      label: 'إجمالي التمويل المجموع',
                      value: '${totalRaised.toStringAsFixed(0)} ر.ع',
                      icon: Icons.stacked_line_chart)),
              const SizedBox(width: 12),
              Expanded(
                  child: StatTile(
                      label: 'إجمالي المستثمرين',
                      value: '$totalInvestors',
                      icon: Icons.groups_outlined,
                      accent: AppColors.info)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: StatTile(
                      label: 'مشاريع نشطة',
                      value: '${myProjects.length}',
                      icon: Icons.folder_open_outlined,
                      accent: AppColors.success)),
              const SizedBox(width: 12),
              Expanded(
                  child: StatTile(
                      label: 'قيد المراجعة',
                      value: '0',
                      icon: Icons.hourglass_empty_rounded,
                      accent: AppColors.warning)),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('مشاريعي', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              TextButton(onPressed: () => context.go('/owner/projects'), child: const Text('عرض الكل')),
            ],
          ),
          const SizedBox(height: 12),
          for (final p in myProjects) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(p.coverImageUrl, width: 50, height: 50, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            StatusBadge(label: 'قيد التمويل', color: AppColors.gold),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearPercentIndicator(
                    lineHeight: 7,
                    percent: p.fundingProgress,
                    barRadius: const Radius.circular(10),
                    backgroundColor: AppColors.surfaceElevated,
                    linearGradient: AppColors.goldGradient,
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 8),
                  Text('${p.raisedAmount.toStringAsFixed(0)} من ${p.targetAmount.toStringAsFixed(0)} ر.ع',
                      style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 8),
          GoldButton(
            label: 'أضف مشروع جديد',
            icon: Icons.add_rounded,
            onPressed: () => context.push('/owner/add-project'),
          ),
        ],
      ),
    );
  }
}
