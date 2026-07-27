import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/mock_data.dart';
import '../../widgets/project_card.dart';

class InvestorHomeScreen extends StatefulWidget {
  const InvestorHomeScreen({super.key});

  @override
  State<InvestorHomeScreen> createState() => _InvestorHomeScreenState();
}

class _InvestorHomeScreenState extends State<InvestorHomeScreen> {
  String _selectedSector = 'الكل';
  final _sectors = ['الكل', 'تقنية', 'عقارات', 'تجارة', 'صناعة', 'زراعة', 'سياحة'];

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedSector == 'الكل'
        ? mockProjects
        : mockProjects.where((p) => p.sector == _selectedSector).toList();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('أهلاً بك 👋', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                      const SizedBox(height: 2),
                      const Text('اكتشف فرصتك القادمة',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: AppColors.surfaceElevated, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.search, color: AppColors.textPrimary, size: 20),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _sectors.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final sector = _sectors[i];
                    final selected = sector == _selectedSector;
                    return ChoiceChip(
                      label: Text(sector),
                      selected: selected,
                      onSelected: (_) => setState(() => _selectedSector = sector),
                      selectedColor: AppColors.gold,
                      backgroundColor: AppColors.surfaceElevated,
                      labelStyle: TextStyle(
                          color: selected ? const Color(0xFF1A1400) : AppColors.textSecondary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: selected ? AppColors.gold : AppColors.border),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            sliver: SliverList.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, i) {
                final project = filtered[i];
                return ProjectCard(
                  project: project,
                  onTap: () => context.push('/investor/project/${project.id}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
