import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/common_widgets.dart';

class _PortfolioItem {
  final String title;
  final String imageUrl;
  final double shares;
  final double invested;
  final double currentValue;

  _PortfolioItem(
      {required this.title,
      required this.imageUrl,
      required this.shares,
      required this.invested,
      required this.currentValue});
}

final _portfolio = [
  _PortfolioItem(
      title: 'مزرعة عمودية ذكية - مسقط',
      imageUrl: 'https://images.unsplash.com/photo-1530836369250-ef72a3f5cda8?w=400',
      shares: 6,
      invested: 300,
      currentValue: 342),
  _PortfolioItem(
      title: 'تطبيق توصيل صيدليات - صحار',
      imageUrl: 'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?w=400',
      shares: 10,
      invested: 200,
      currentValue: 224),
];

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final totalInvested = _portfolio.fold<double>(0, (s, e) => s + e.invested);
    final totalValue = _portfolio.fold<double>(0, (s, e) => s + e.currentValue);
    final profit = totalValue - totalInvested;
    final profitPct = totalInvested == 0 ? 0 : (profit / totalInvested) * 100;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('محفظتي الاستثمارية', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.circular(22)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('القيمة الحالية للمحفظة',
                    style: TextStyle(fontSize: 12.5, color: Color(0xFF1A1400), fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text('${totalValue.toStringAsFixed(0)} ر.ع',
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xFF1A1400))),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Icon(profit >= 0 ? Icons.arrow_upward : Icons.arrow_downward, size: 16, color: const Color(0xFF1A1400)),
                    const SizedBox(width: 4),
                    Text('${profit.toStringAsFixed(0)} ر.ع (${profitPct.toStringAsFixed(1)}٪) منذ البداية',
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF1A1400))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: StatTile(
                      label: 'إجمالي المستثمر',
                      value: '${totalInvested.toStringAsFixed(0)} ر.ع',
                      icon: Icons.savings_outlined)),
              const SizedBox(width: 12),
              Expanded(
                  child: StatTile(
                      label: 'عدد المشاريع',
                      value: '${_portfolio.length}',
                      icon: Icons.dashboard_outlined,
                      accent: AppColors.info)),
            ],
          ),
          const SizedBox(height: 28),
          const Text('توزيع المحفظة', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 40,
                sections: [
                  for (int i = 0; i < _portfolio.length; i++)
                    PieChartSectionData(
                      value: _portfolio[i].currentValue,
                      color: i == 0 ? AppColors.gold : AppColors.info,
                      title: '',
                      radius: 26,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Text('استثماراتي', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          for (final item in _portfolio) ...[
            _InvestmentTile(item: item),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _InvestmentTile extends StatelessWidget {
  final _PortfolioItem item;
  const _InvestmentTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final profit = item.currentValue - item.invested;
    final positive = profit >= 0;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(item.imageUrl, width: 56, height: 56, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('${item.shares.toStringAsFixed(0)} سهم', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${item.currentValue.toStringAsFixed(0)} ر.ع',
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              const SizedBox(height: 3),
              Text('${positive ? '+' : ''}${profit.toStringAsFixed(0)} ر.ع',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: positive ? AppColors.success : AppColors.danger)),
            ],
          ),
        ],
      ),
    );
  }
}
