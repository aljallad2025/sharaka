import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/supabase_service.dart';
import '../../models/project_model.dart';
import '../../widgets/status_badge.dart';
import '../../routes/app_router.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<ProjectModel>> _pendingProjectsFuture;
  late Future<List<Map<String, dynamic>>> _pendingKycFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pendingProjectsFuture = _loadPendingProjects();
    _pendingKycFuture = _loadPendingKyc();
  }

  Future<List<ProjectModel>> _loadPendingProjects() async {
    final data = await SupabaseService.instance.client
        .from('projects')
        .select()
        .eq('status', 'pending_review')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data).map((e) => ProjectModel.fromMap(e)).toList();
  }

  Future<List<Map<String, dynamic>>> _loadPendingKyc() async {
    final data = await SupabaseService.instance.client
        .from('profiles')
        .select()
        .eq('kyc_status', 'pending')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> _updateProjectStatus(String id, String status) async {
    await SupabaseService.instance.client.from('projects').update({'status': status}).eq('id', id);
    setState(() => _pendingProjectsFuture = _loadPendingProjects());
  }

  Future<void> _updateKycStatus(String userId, String status) async {
    await SupabaseService.instance.client.from('profiles').update({'kyc_status': status}).eq('id', userId);
    setState(() => _pendingKycFuture = _loadPendingKyc());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة الإدارة'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.gold,
          labelColor: Colors.white,
          tabs: const [
            Tab(text: 'مشاريع بانتظار الاعتماد'),
            Tab(text: 'طلبات KYC'),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.person_outline), onPressed: () => context.push(AppRoutes.profile)),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FutureBuilder<List<ProjectModel>>(
            future: _pendingProjectsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final projects = snapshot.data ?? [];
              if (projects.isEmpty) {
                return const Center(child: Text('لا توجد مشاريع بانتظار المراجعة'));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: projects.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final p = projects[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold))),
                              StatusBadge(status: p.status),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text('${p.sector} • ${p.country}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          const SizedBox(height: 6),
                          Text(p.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _updateProjectStatus(p.id, 'rejected'),
                                  icon: const Icon(Icons.close, size: 16, color: AppColors.danger),
                                  label: const Text('رفض', style: TextStyle(color: AppColors.danger)),
                                  style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.danger)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _updateProjectStatus(p.id, 'active'),
                                  icon: const Icon(Icons.check, size: 16),
                                  label: const Text('اعتماد'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _pendingKycFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final users = snapshot.data ?? [];
              if (users.isEmpty) {
                return const Center(child: Text('لا توجد طلبات تحقق هوية بانتظار المراجعة'));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: users.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final u = users[index];
                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(u['full_name'] ?? ''),
                      subtitle: Text(u['email'] ?? ''),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check_circle, color: AppColors.success),
                            onPressed: () => _updateKycStatus(u['id'], 'approved'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel, color: AppColors.danger),
                            onPressed: () => _updateKycStatus(u['id'], 'rejected'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
