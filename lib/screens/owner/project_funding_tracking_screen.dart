import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/mock_data.dart';
import '../../models/project_model.dart';
import '../../widgets/common_widgets.dart';

class ProjectFundingTrackingScreen extends StatelessWidget {
  final String projectId;
  const ProjectFundingTrackingScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final InvestmentProject project =
        mockProjects.firstWhere((p) => p.id == projectId, orElse: () => mockProjects.first);

    final recentInvestors = [
      {'name': 'سالم البلوشي', 'amount': 500, 'time': 'قبل ساعة'},
      {'name': 'مريم الهنائية', 'amount': 250, 'time': 'قبل 4 ساعات'},
      {'name': 'خالد الرواحي', 'amount': 1000, 'time': 'أمس'},
    ];

    return Scaffold(
      appBar: AppBar(title: Text(project.title, maxLines: 1, overflow: TextOverflow.ellipsis)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('إجمالي التمويل المجموع',
                      style: TextStyle(fontSize: 12.5, color: Color(0xFF1A1400), fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text('${project.raisedAmount.toStringAsFixed(0)} ر.ع',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF1A1400))),
                  const SizedBox(height: 14),
                  LinearPercentIndicator(
                    lineHeight: 8,
                    percent: project.fundingProgress,
                    barRadius: const Radius.circular(10),
                    backgroundColor: Colors.white.withOpacity(0.35),
                    progressColor: const Color(0xFF1A1400),
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 8),
                  Text('${(project.fundingProgress * 100).toStringAsFixed(0)}٪ من ${project.targetAmount.toStringAsFixed(0)} ر.ع',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF1A1400), fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: StatTile(
                        label: 'عدد المستثمرين', value: '${project.investorsCount}', icon: Icons.groups_outlined)),
                const SizedBox(width: 12),
                Expanded(
                    child: StatTile(
                        label: 'الأسهم المباعة',
                        value: project.soldShares.toStringAsFixed(0),
                        icon: Icons.pie_chart_outline,
                        accent: AppColors.info)),
              ],
            ),
            const SizedBox(width: 12, height: 12),
            Row(
              children: [
                Expanded(
                    child: StatTile(
                        label: 'الأيام المتبقية',
                        value: '${project.daysRemaining}',
                        icon: Icons.schedule,
                        accent: AppColors.warning)),
                const SizedBox(width: 12),
                Expanded(
                    child: StatTile(
                        label: 'سعر السهم',
                        value: '${project.sharePrice.toStringAsFixed(0)} ر.ع',
                        icon: Icons.sell_outlined,
                        accent: AppColors.success)),
              ],
            ),
            const SizedBox(height: 28),
            const Text('آخر المستثمرين', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),
            for (final inv in recentInvestors) ...[
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(color: AppColors.surfaceElevated, shape: BoxShape.circle),
                      child: const Icon(Icons.person_outline, color: AppColors.textMuted, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(inv['name'] as String, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                          Text(inv['time'] as String, style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                    Text('${inv['amount']} ر.ع',
                        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.gold)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
