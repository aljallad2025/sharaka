import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/supabase_service.dart';
import '../../models/investment_model.dart';
import '../../widgets/status_badge.dart';
import '../../routes/app_router.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  late Future<List<InvestmentModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<InvestmentModel>> _load() async {
    final data = await SupabaseService.instance.fetchMyPortfolio();
    return data.map((e) => InvestmentModel.fromMap(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('محفظتي الاستثمارية')),
      body: FutureBuilder<List<InvestmentModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final investments = snapshot.data ?? [];

          final totalInvested = investments.fold<double>(0, (sum, i) => sum + i.amount);
          final totalShares = investments.fold<double>(0, (sum, i) => sum + i.sharesPercentage);

          return RefreshIndicator(
            onRefresh: () async => setState(() => _future = _load()),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryGreen, AppColors.deepGreen],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('إجمالي الاستثمار', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                          const SizedBox(height: 6),
                          Text('${totalInvested.toStringAsFixed(0)} ر.ع',
                              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('عدد المشاريع', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                          const SizedBox(height: 6),
                          Text('${investments.length}',
                              style: const TextStyle(color: AppColors.gold, fontSize: 22, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text('استثماراتي (${investments.length})',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 12),
                if (investments.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.pie_chart_outline, size: 56, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          const Text('محفظتك فارغة حالياً'),
                          const SizedBox(height: 4),
                          Text('استعرض المشاريع وابدأ استثمارك الأول',
                              style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ),
                  )
                else
                  ...investments.map((inv) {
                    final projectTitle = inv.project?['title'] ?? 'مشروع';
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        onTap: () => context.push(AppRoutes.projectDetails.replaceFirst(':id', inv.projectId)),
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFEFEFEF),
                          child: Icon(Icons.apartment_rounded, color: AppColors.primaryGreen),
                        ),
                        title: Text(projectTitle, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text(
                          '${inv.amount.toStringAsFixed(0)} ر.ع • ${inv.sharesPercentage.toStringAsFixed(2)}% أسهم',
                        ),
                        trailing: StatusBadge(status: inv.status),
                      ),
                    );
                  }),
              ],
            ),
          );
        },
      ),
    );
  }
}
