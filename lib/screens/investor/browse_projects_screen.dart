import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/supabase_service.dart';
import '../../models/project_model.dart';
import '../../widgets/project_card.dart';
import '../../routes/app_router.dart';

class BrowseProjectsScreen extends StatefulWidget {
  const BrowseProjectsScreen({super.key});

  @override
  State<BrowseProjectsScreen> createState() => _BrowseProjectsScreenState();
}

class _BrowseProjectsScreenState extends State<BrowseProjectsScreen> {
  String? _sector;
  String? _country;
  late Future<List<ProjectModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<ProjectModel>> _load() async {
    final data = await SupabaseService.instance.fetchProjects(sector: _sector, country: _country);
    return data.map((e) => ProjectModel.fromMap(e)).toList();
  }

  void _applyFilters() {
    setState(() => _future = _load());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('استعرض المشاريع'),
        actions: [
          IconButton(
            icon: const Icon(Icons.pie_chart_outline),
            onPressed: () => context.push(AppRoutes.portfolio),
          ),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _FilterChip(
                    label: 'كل القطاعات',
                    selected: _sector == null,
                    onTap: () {
                      _sector = null;
                      _applyFilters();
                    },
                  ),
                  ...AppConstants.sectors.map(
                    (s) => _FilterChip(
                      label: s,
                      selected: _sector == s,
                      onTap: () {
                        _sector = s;
                        _applyFilters();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _FilterChip(
                    label: 'كل الدول',
                    selected: _country == null,
                    outlined: true,
                    onTap: () {
                      _country = null;
                      _applyFilters();
                    },
                  ),
                  ...AppConstants.targetCountries.map(
                    (c) => _FilterChip(
                      label: c,
                      selected: _country == c,
                      outlined: true,
                      onTap: () {
                        _country = c;
                        _applyFilters();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => _applyFilters(),
              child: FutureBuilder<List<ProjectModel>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final projects = snapshot.data ?? [];
                  if (projects.isEmpty) {
                    return ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        const SizedBox(height: 60),
                        Icon(Icons.search_off_rounded, size: 56, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        const Center(child: Text('لا توجد مشاريع مطابقة حالياً')),
                      ],
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: projects.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final p = projects[index];
                      return ProjectCard(
                        project: p,
                        onTap: () => context.push(
                          AppRoutes.projectDetails.replaceFirst(':id', p.id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool outlined;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 12.5)),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: outlined ? AppColors.gold.withOpacity(0.25) : AppColors.primaryGreen,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: selected ? (outlined ? AppColors.deepGreen : Colors.white) : AppColors.textPrimary,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
