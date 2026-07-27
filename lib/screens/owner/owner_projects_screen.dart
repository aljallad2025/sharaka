import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/mock_data.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/project_card.dart';

class OwnerProjectsScreen extends StatefulWidget {
  const OwnerProjectsScreen({super.key});

  @override
  State<OwnerProjectsScreen> createState() => _OwnerProjectsScreenState();
}

class _OwnerProjectsScreenState extends State<OwnerProjectsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 3, vsync: this);

  @override
  Widget build(BuildContext context) {
    final active = mockProjects.take(2).toList();

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('مشاريعي', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                IconButton(
                  onPressed: () => context.push('/owner/add-project'),
                  icon: const Icon(Icons.add_circle, color: AppColors.gold, size: 28),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: AppColors.gold,
            unselectedLabelColor: AppColors.textMuted,
            indicatorColor: AppColors.gold,
            labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            tabs: const [
              Tab(text: 'قيد التمويل'),
              Tab(text: 'قيد المراجعة'),
              Tab(text: 'مكتملة'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: active.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, i) => ProjectCard(
                    project: active[i],
                    onTap: () => context.push('/owner/project-tracking/${active[i].id}'),
                  ),
                ),
                const EmptyState(
                    icon: Icons.hourglass_empty_rounded,
                    title: 'ماكو مشاريع قيد المراجعة',
                    subtitle: 'أي مشروع جديد ترسله رح يظهر هنا لحد ما يتم اعتماده'),
                const EmptyState(
                    icon: Icons.task_alt_rounded,
                    title: 'ماكو مشاريع مكتملة بعد',
                    subtitle: 'المشاريع اللي توصل لهدف التمويل بالكامل رح تظهر هنا'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
