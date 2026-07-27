import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/mock_data.dart';
import '../../widgets/common_widgets.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة تحكم الإدارة')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                      child: StatTile(
                          label: 'إجمالي المشاريع', value: '${mockProjects.length}', icon: Icons.folder_outlined)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: StatTile(
                          label: 'إجمالي التمويل',
                          value:
                              '${mockProjects.fold<double>(0, (s, p) => s + p.raisedAmount).toStringAsFixed(0)} ر.ع',
                          icon: Icons.account_balance_outlined,
                          accent: AppColors.success)),
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
                Tab(text: 'مشاريع بانتظار الاعتماد'),
                Tab(text: 'طلبات توثيق الهوية'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: mockProjects.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final p = mockProjects[i];
                      return Container(
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
                                      Text(p.title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                                      const SizedBox(height: 4),
                                      Text('${p.sector} · ${p.city}', style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
                                    ],
                                  ),
                                ),
                                StatusBadge(label: 'بانتظار المراجعة', color: AppColors.warning),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(
                                        minimumSize: const Size.fromHeight(42), side: const BorderSide(color: AppColors.danger)),
                                    child: const Text('رفض', style: TextStyle(color: AppColors.danger, fontSize: 13)),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.success, minimumSize: const Size.fromHeight(42)),
                                    child: const Text('اعتماد', style: TextStyle(fontSize: 13)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: 3,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final names = ['فاطمة الكندية', 'يوسف الحارثي', 'نورة الشحية'];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: const BoxDecoration(color: AppColors.surfaceElevated, shape: BoxShape.circle),
                              child: const Icon(Icons.person_outline, color: AppColors.textMuted),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(names[i], style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                            ),
                            TextButton(onPressed: () {}, child: const Text('مراجعة المستندات')),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
