import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/mock_data.dart';
import '../../models/project_model.dart';
import '../../widgets/common_widgets.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final String projectId;
  const ProjectDetailsScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final InvestmentProject project =
        mockProjects.firstWhere((p) => p.id == projectId, orElse: () => mockProjects.first);
    final sectorColor = AppColors.sectorColors[project.sector] ?? AppColors.gold;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(imageUrl: project.coverImageUrl, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, AppColors.background.withOpacity(0.95)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    children: [
                      StatusBadge(label: project.sector, color: sectorColor),
                      StatusBadge(label: '${project.city} · ${project.country}', color: AppColors.info),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(project.title,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Text(project.shortDescription,
                      style: const TextStyle(fontSize: 13.5, color: AppColors.textSecondary, height: 1.6)),
                  const SizedBox(height: 24),

                  // بطاقة التمويل
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${project.raisedAmount.toStringAsFixed(0)} ر.ع',
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.gold)),
                            Text('من ${project.targetAmount.toStringAsFixed(0)} ر.ع',
                                style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        LinearPercentIndicator(
                          lineHeight: 9,
                          percent: project.fundingProgress,
                          barRadius: const Radius.circular(10),
                          backgroundColor: AppColors.surfaceElevated,
                          linearGradient: AppColors.goldGradient,
                          padding: EdgeInsets.zero,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                                child: _MiniStat(
                                    icon: Icons.trending_up,
                                    label: 'عائد متوقع',
                                    value: '${project.expectedAnnualReturn.toStringAsFixed(0)}٪')),
                            Expanded(
                                child: _MiniStat(
                                    icon: Icons.people_outline,
                                    label: 'مستثمر',
                                    value: '${project.investorsCount}')),
                            Expanded(
                                child: _MiniStat(
                                    icon: Icons.schedule,
                                    label: 'يوم متبقي',
                                    value: '${project.daysRemaining}')),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text('عن المشروع', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  const SizedBox(height: 10),
                  Text(project.fullDescription,
                      style: const TextStyle(fontSize: 13.5, color: AppColors.textSecondary, height: 1.8)),

                  const SizedBox(height: 24),
                  const Text('تفاصيل الأسهم', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  _InfoRow(label: 'سعر السهم', value: '${project.sharePrice.toStringAsFixed(0)} ر.ع'),
                  _InfoRow(label: 'إجمالي الأسهم', value: project.totalShares.toStringAsFixed(0)),
                  _InfoRow(label: 'الأسهم المتبقية', value: project.remainingShares.toStringAsFixed(0)),
                  _InfoRow(label: 'الحد الأدنى للاستثمار', value: '${project.minInvestment.toStringAsFixed(0)} ر.ع'),

                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'الاستثمار بالأسهم ينطوي على مخاطر وقد تخسر كامل أو جزء من مبلغك. اقرأ نشرة المشروع كاملة قبل الاستثمار.',
                            style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: GoldButton(
            label: 'استثمر الآن',
            icon: Icons.add_chart_rounded,
            onPressed: () => context.push('/investor/invest/${project.id}'),
          ),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _MiniStat({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: AppColors.gold),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        Text(label, style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted)),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
          Text(value, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
