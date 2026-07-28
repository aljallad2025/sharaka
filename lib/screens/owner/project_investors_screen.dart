import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/supabase_service.dart';
import '../../models/project_model.dart';
import '../../widgets/status_badge.dart';

class ProjectInvestorsScreen extends StatefulWidget {
  final String projectId;
  const ProjectInvestorsScreen({super.key, required this.projectId});

  @override
  State<ProjectInvestorsScreen> createState() => _ProjectInvestorsScreenState();
}

class _ProjectInvestorsScreenState extends State<ProjectInvestorsScreen> {
  late Future<_ProjectInvestorsData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_ProjectInvestorsData> _load() async {
    final projectMap = await SupabaseService.instance.fetchProjectById(widget.projectId);
    final investmentsRaw = await SupabaseService.instance.fetchProjectInvestors(widget.projectId);

    return _ProjectInvestorsData(
      project: projectMap != null ? ProjectModel.fromMap(projectMap) : null,
      investments: investmentsRaw,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('متابعة التمويل')),
      body: FutureBuilder<_ProjectInvestorsData>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data;
          final project = data?.project;
          final investments = data?.investments ?? [];

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (project != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(project.title,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                            StatusBadge(status: project.status),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _StatBlock(label: 'الهدف', value: '${project.fundingGoal.toStringAsFixed(0)} ر.ع'),
                            _StatBlock(label: 'تم جمعه', value: '${project.amountRaised.toStringAsFixed(0)} ر.ع'),
                            _StatBlock(
                              label: 'النسبة',
                              value: '${(project.progressRatio * 100).toStringAsFixed(0)}%',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              Text('المستثمرون (${investments.length})',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 12),
              if (investments.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text('لا يوجد مستثمرون بعد', style: TextStyle(color: AppColors.textSecondary)),
                  ),
                )
              else
                ...investments.map((inv) {
                  final profile = inv['profiles'] as Map<String, dynamic>?;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(profile?['full_name'] ?? 'مستثمر'),
                      subtitle: Text('${(inv['amount'] ?? 0).toStringAsFixed(0)} ر.ع • ${(inv['shares_percentage'] ?? 0).toStringAsFixed(1)}% أسهم'),
                      trailing: StatusBadge(status: inv['status'] ?? 'pending_payment'),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}

class _ProjectInvestorsData {
  final ProjectModel? project;
  final List<Map<String, dynamic>> investments;
  _ProjectInvestorsData({required this.project, required this.investments});
}

class _StatBlock extends StatelessWidget {
  final String label;
  final String value;
  const _StatBlock({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
