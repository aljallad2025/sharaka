import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/supabase_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Map<String, dynamic>>> _load() async {
    final uid = SupabaseService.instance.currentUser?.id;
    if (uid == null) return [];
    final data = await SupabaseService.instance.client
        .from('notifications')
        .select()
        .eq('user_id', uid)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'investment':
        return Icons.trending_up_rounded;
      case 'project_status':
        return Icons.storefront_outlined;
      case 'kyc':
        return Icons.verified_user_outlined;
      case 'payment':
        return Icons.payments_outlined;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإشعارات')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 80),
                Icon(Icons.notifications_none_rounded, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const Center(child: Text('لا توجد إشعارات حالياً')),
              ],
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final n = items[index];
              final isRead = n['is_read'] == true;
              return Container(
                decoration: BoxDecoration(
                  color: isRead ? Colors.white : AppColors.primaryGreen.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.gold.withOpacity(0.15),
                    child: Icon(_iconFor(n['type'] ?? ''), color: AppColors.deepGreen, size: 20),
                  ),
                  title: Text(n['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(n['body'] ?? '', style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
