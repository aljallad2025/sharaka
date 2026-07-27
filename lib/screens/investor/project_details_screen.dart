import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/supabase_service.dart';
import '../../models/project_model.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/custom_button.dart';
import '../../routes/app_router.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final String projectId;
  const ProjectDetailsScreen({super.key, required this.projectId});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  late Future<ProjectModel?> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<ProjectModel?> _load() async {
    final data = await SupabaseService.instance.fetchProjectById(widget.projectId);
    return data != null ? ProjectModel.fromMap(data) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ProjectModel?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final project = snapshot.data;
          if (project == null) {
            return const Center(child: Text('تعذر إيجاد المشروع'));
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                backgroundColor: AppColors.primaryGreen,
                flexibleSpace: FlexibleSpaceBar(
                  background: project.imageUrls.isNotEmpty
                      ? CachedNetworkImage(imageUrl: project.imageUrls.first, fit: BoxFit.cover)
                      : Container(
                          color: AppColors.primaryGreen,
                          child: const Center(
                            child: Icon(Icons.apartment_rounded, color: Colors.white54, size: 64),
                          ),
                        ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(project.title,
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          ),
                          StatusBadge(status: project.status),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Chip(label: Text(project.sector), visualDensity: VisualDensity.compact),
                          const SizedBox(width: 8),
                          Chip(label: Text(project.country), visualDensity: VisualDensity.compact),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              LinearPercentIndicator(
                                lineHeight: 10,
                                percent: project.progressRatio,
                                barRadius: const Radius.circular(8),
                                backgroundColor: Colors.grey.shade200,
                                progressColor: AppColors.gold,
                                padding: EdgeInsets.zero,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${project.amountRaised.toStringAsFixed(0)} ر.ع',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      Text('تم جمعه', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('${project.fundingGoal.toStringAsFixed(0)} ر.ع',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      Text('الهدف', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('عن المشروع', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 8),
                      Text(project.description, style: TextStyle(color: AppColors.textPrimary.withOpacity(0.85), height: 1.6)),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _InfoBox(
                              label: 'أسهم معروضة',
                              value: '${project.sharesOfferedPercentage.toStringAsFixed(1)}%',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _InfoBox(
                              label: 'سعر كل 1%',
                              value: '${project.pricePerSharePercent.toStringAsFixed(0)} ر.ع',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      CustomButton(
                        label: 'استثمر في هذا المشروع',
                        onPressed: project.status == 'active'
                            ? () => context.push(AppRoutes.invest.replaceFirst(':id', project.id))
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;
  const _InfoBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
