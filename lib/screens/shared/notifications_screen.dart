import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/common_widgets.dart';

class _NotificationItem {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String time;
  final bool unread;

  _NotificationItem(
      {required this.icon,
      required this.color,
      required this.title,
      required this.subtitle,
      required this.time,
      this.unread = false});
}

final _notifications = [
  _NotificationItem(
      icon: Icons.check_circle_outline,
      color: AppColors.success,
      title: 'تم تأكيد استثمارك',
      subtitle: 'استثمارك بمشروع "مزرعة عمودية ذكية" تم تأكيده بنجاح',
      time: 'قبل ساعتين',
      unread: true),
  _NotificationItem(
      icon: Icons.trending_up,
      color: AppColors.gold,
      title: 'اقترب اكتمال التمويل',
      subtitle: 'مشروع "تطبيق توصيل صيدليات" وصل لـ85٪ من هدفه',
      time: 'قبل يوم',
      unread: true),
  _NotificationItem(
      icon: Icons.verified_user_outlined,
      color: AppColors.info,
      title: 'تم توثيق هويتك',
      subtitle: 'تمت الموافقة على مستندات التحقق من هويتك بنجاح',
      time: 'قبل 3 أيام'),
  _NotificationItem(
      icon: Icons.campaign_outlined,
      color: AppColors.warning,
      title: 'مشروع جديد بقطاعك المفضل',
      subtitle: 'مشروع جديد بقطاع التقنية متاح الآن للاستثمار',
      time: 'قبل أسبوع'),
];

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('الإشعارات', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                TextButton(onPressed: () {}, child: const Text('تعليم الكل كمقروء')),
              ],
            ),
          ),
          Expanded(
            child: _notifications.isEmpty
                ? const EmptyState(
                    icon: Icons.notifications_none_rounded,
                    title: 'ماكو إشعارات حالياً',
                    subtitle: 'رح تشوف هنا كل التحديثات عن استثماراتك ومشاريعك')
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: _notifications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final n = _notifications[i];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: n.unread ? AppColors.surfaceCard : AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: n.unread ? AppColors.gold.withOpacity(0.25) : AppColors.border),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: n.color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                              child: Icon(n.icon, size: 19, color: n.color),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(n.title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 4),
                                  Text(n.subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.4)),
                                  const SizedBox(height: 6),
                                  Text(n.time, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                ],
                              ),
                            ),
                            if (n.unread)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
