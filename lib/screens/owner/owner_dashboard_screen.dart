import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/supabase_service.dart';
import '../../models/project_model.dart';
import '../../widgets/project_card.dart';
import '../../routes/app_router.dart';

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  late Future<List<ProjectModel>> _projectsFuture;

  @override
  void initState() {
    super.initState();
    _projectsFuture = _load();
  }

  Future<List<ProjectModel>> _load() async {
    final data = await SupabaseService.instance.fetchMyProjects();
    return data.map((e) => ProjectModel.fromMap(e)).toList();
  }

  Future<void> _refresh() async {
    setState(() => _projectsFuture = _load());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مشاريعي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () => context.push(AppRoutes.notifications),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push(AppRoutes.profile),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.deepGreen,
        icon: const Icon(Icons.add),
        label: const Text('مشروع جديد'),
        onPressed: () async {
          await context.push(AppRoutes.addProject);
          _refresh();
        },
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<ProjectModel>>(
          future: _projectsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final projects = snapshot.data ?? [];
            if (projects.isEmpty) {
              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const SizedBox(height: 80),
                  Icon(Icons.storefront_outlined, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text('ما عندك مشاريع بعد', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      'اضغط "مشروع جديد" لعرض أول مشروع للمستثمرين',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: projects.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final p = projects[index];
                return ProjectCard(
                  project: p,
                  onTap: () => context.push(
                    AppRoutes.projectInvestors.replaceFirst(':id', p.id),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
