/// بيانات وهمية (Mock) لعرض تصميم التطبيق بدون ربط Supabase حقيقي.
/// كل الصور هون صور حقيقية (من خدمة Picsum) بس البيانات النصية تجريبية بالكامل.
library mock_data;

class MockData {
  MockData._();

  // ---------------- حسابات تجريبية جاهزة ----------------
  // سجّل دخول بأي وحدة من هاي (كلمة المرور: أي شي 6 أحرف فأكثر، مثلاً 123456)
  static const Map<String, String> demoAccounts = {
    'investor@sharaka.com': 'mock-investor-1',
    'owner@sharaka.com': 'mock-owner-1',
    'admin@sharaka.com': 'mock-admin-1',
  };

  // ---------------- الملفات الشخصية ----------------
  static final Map<String, Map<String, dynamic>> profiles = {
    'mock-investor-1': {
      'id': 'mock-investor-1',
      'full_name': 'سالم المستثمر',
      'email': 'investor@sharaka.com',
      'role': 'investor',
      'kyc_status': 'approved',
      'phone': '+968 9123 4567',
      'avatar_url': null,
      'created_at': DateTime.now().subtract(const Duration(days: 120)).toIso8601String(),
    },
    'mock-investor-2': {
      'id': 'mock-investor-2',
      'full_name': 'ليلى الهاشمي',
      'email': 'laila@example.com',
      'role': 'investor',
      'kyc_status': 'pending',
      'phone': '+968 9876 5432',
      'avatar_url': null,
      'created_at': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
    },
    'mock-owner-1': {
      'id': 'mock-owner-1',
      'full_name': 'خالد صاحب المشروع',
      'email': 'owner@sharaka.com',
      'role': 'project_owner',
      'kyc_status': 'approved',
      'phone': '+971 50 123 4567',
      'avatar_url': null,
      'created_at': DateTime.now().subtract(const Duration(days: 200)).toIso8601String(),
    },
    'mock-admin-1': {
      'id': 'mock-admin-1',
      'full_name': 'إدارة شراكة',
      'email': 'admin@sharaka.com',
      'role': 'admin',
      'kyc_status': 'approved',
      'phone': null,
      'avatar_url': null,
      'created_at': DateTime.now().subtract(const Duration(days: 365)).toIso8601String(),
    },
  };

  // ---------------- المشاريع ----------------
  static final List<Map<String, dynamic>> projects = [
    {
      'id': 'proj-1',
      'owner_id': 'mock-owner-1',
      'title': 'توسعة مطعم البيت العُماني',
      'description':
          'مطعم شعبي معروف بمسقط بدّه يفتح فرع ثاني بمنطقة الموج، مع تحديث المطبخ وزيادة الطاقة الاستيعابية للزبائن.',
      'sector': 'مطاعم وضيافة',
      'country': 'سلطنة عمان',
      'funding_goal': 50000,
      'amount_raised': 32000,
      'shares_offered_percentage': 20,
      'price_per_share_percent': 2500,
      'status': 'active',
      'image_urls': ['https://picsum.photos/seed/omanirestaurant/800/500'],
      'document_urls': <String>[],
      'deadline': DateTime.now().add(const Duration(days: 25)).toIso8601String(),
      'created_at': DateTime.now().subtract(const Duration(days: 10)).toIso8601String(),
    },
    {
      'id': 'proj-2',
      'owner_id': 'mock-owner-2',
      'title': 'منصة توصيل خضار وفواكه طازجة',
      'description':
          'تطبيق يربط المزارعين المحليين مباشرة بالمستهلكين بمنطقة دبي، مع خدمة توصيل خلال ساعتين.',
      'sector': 'تجارة التجزئة',
      'country': 'الإمارات',
      'funding_goal': 80000,
      'amount_raised': 80000,
      'shares_offered_percentage': 15,
      'price_per_share_percent': 5333,
      'status': 'funded',
      'image_urls': ['https://picsum.photos/seed/freshveggies/800/500'],
      'document_urls': <String>[],
      'deadline': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
      'created_at': DateTime.now().subtract(const Duration(days: 60)).toIso8601String(),
    },
    {
      'id': 'proj-3',
      'owner_id': 'mock-owner-1',
      'title': 'مزرعة عمودية ذكية',
      'description':
          'مشروع زراعة عمودية بتقنية الهيدروبونيك داخل مستودعات مكيّفة، لإنتاج خضار ورقية طوال السنة بجودة ثابتة.',
      'sector': 'زراعة',
      'country': 'السعودية',
      'funding_goal': 120000,
      'amount_raised': 45000,
      'shares_offered_percentage': 25,
      'price_per_share_percent': 4800,
      'status': 'active',
      'image_urls': ['https://picsum.photos/seed/verticalfarm/800/500'],
      'document_urls': <String>[],
      'deadline': DateTime.now().add(const Duration(days: 40)).toIso8601String(),
      'created_at': DateTime.now().subtract(const Duration(days: 20)).toIso8601String(),
    },
    {
      'id': 'proj-4',
      'owner_id': 'mock-owner-3',
      'title': 'تطبيق حجز خدمات صيانة منزلية',
      'description':
          'منصة توصل أصحاب المنازل بفنيين معتمدين (كهرباء، سباكة، تكييف) بالبحرين مع تقييم وضمان جودة.',
      'sector': 'تقنية',
      'country': 'البحرين',
      'funding_goal': 60000,
      'amount_raised': 15000,
      'shares_offered_percentage': 18,
      'price_per_share_percent': 3333,
      'status': 'active',
      'image_urls': ['https://picsum.photos/seed/homerepairapp/800/500'],
      'document_urls': <String>[],
      'deadline': DateTime.now().add(const Duration(days: 55)).toIso8601String(),
      'created_at': DateTime.now().subtract(const Duration(days: 8)).toIso8601String(),
    },
    {
      'id': 'proj-5',
      'owner_id': 'mock-owner-2',
      'title': 'مصنع تعبئة وتغليف تمور',
      'description':
          'خط إنتاج آلي لتعبئة التمور الفاخرة للتصدير، بمعايير غذائية عالمية ومنتجات جاهزة للأسواق الخليجية والدولية.',
      'sector': 'صناعة وتصنيع',
      'country': 'الكويت',
      'funding_goal': 200000,
      'amount_raised': 0,
      'shares_offered_percentage': 30,
      'price_per_share_percent': 6666,
      'status': 'pending_review',
      'image_urls': ['https://picsum.photos/seed/datespacking/800/500'],
      'document_urls': <String>[],
      'deadline': DateTime.now().add(const Duration(days: 60)).toIso8601String(),
      'created_at': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
    },
    {
      'id': 'proj-6',
      'owner_id': 'mock-owner-1',
      'title': 'محطة طاقة شمسية صغيرة',
      'description':
          'محطة كهرباء شمسية بسعة 500 كيلوواط لتزويد مجمع تجاري بقطر بالطاقة النظيفة وتقليل فاتورة الكهرباء.',
      'sector': 'طاقة',
      'country': 'قطر',
      'funding_goal': 150000,
      'amount_raised': 90000,
      'shares_offered_percentage': 22,
      'price_per_share_percent': 6818,
      'status': 'active',
      'image_urls': ['https://picsum.photos/seed/solarenergy/800/500'],
      'document_urls': <String>[],
      'deadline': DateTime.now().add(const Duration(days: 15)).toIso8601String(),
      'created_at': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
    },
    {
      'id': 'proj-7',
      'owner_id': 'mock-owner-4',
      'title': 'شركة نقل لوجستي للمشاريع الصغيرة',
      'description':
          'أسطول شاحنات صغيرة لخدمة التجار والمتاجر الإلكترونية بالإمارات بأسعار تنافسية وتتبع لحظي للشحنات.',
      'sector': 'خدمات لوجستية',
      'country': 'الإمارات',
      'funding_goal': 70000,
      'amount_raised': 10000,
      'shares_offered_percentage': 20,
      'price_per_share_percent': 3500,
      'status': 'rejected',
      'image_urls': ['https://picsum.photos/seed/logisticstrucks/800/500'],
      'document_urls': <String>[],
      'deadline': DateTime.now().add(const Duration(days: 5)).toIso8601String(),
      'created_at': DateTime.now().subtract(const Duration(days: 45)).toIso8601String(),
    },
  ];

  // ---------------- الاستثمارات ----------------
  static final List<Map<String, dynamic>> investments = [
    {
      'id': 'inv-1',
      'investor_id': 'mock-investor-1',
      'project_id': 'proj-1',
      'amount': 5000,
      'shares_percentage': 2.0,
      'status': 'completed',
      'created_at': DateTime.now().subtract(const Duration(days: 9)).toIso8601String(),
    },
    {
      'id': 'inv-2',
      'investor_id': 'mock-investor-1',
      'project_id': 'proj-3',
      'amount': 8000,
      'shares_percentage': 1.5,
      'status': 'completed',
      'created_at': DateTime.now().subtract(const Duration(days: 15)).toIso8601String(),
    },
    {
      'id': 'inv-3',
      'investor_id': 'mock-investor-1',
      'project_id': 'proj-6',
      'amount': 3000,
      'shares_percentage': 0.8,
      'status': 'pending_payment',
      'created_at': DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
    },
    {
      'id': 'inv-4',
      'investor_id': 'mock-investor-2',
      'project_id': 'proj-1',
      'amount': 10000,
      'shares_percentage': 4.0,
      'status': 'completed',
      'created_at': DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
    },
  ];

  // ---------------- الإشعارات ----------------
  static final List<Map<String, dynamic>> notifications = [
    {
      'id': 'notif-1',
      'user_id': 'mock-investor-1',
      'type': 'investment',
      'title': 'تم تأكيد استثمارك',
      'body': 'استثمارك بمبلغ 5000 ر.ع في مشروع "توسعة مطعم البيت العُماني" تم تأكيده بنجاح.',
      'is_read': false,
      'created_at': DateTime.now().subtract(const Duration(days: 9)).toIso8601String(),
    },
    {
      'id': 'notif-2',
      'user_id': 'mock-investor-1',
      'type': 'project_status',
      'title': 'تحديث حالة مشروع',
      'body': 'مشروع "مزرعة عمودية ذكية" وصل لـ 37% من هدف التمويل.',
      'is_read': false,
      'created_at': DateTime.now().subtract(const Duration(days: 4)).toIso8601String(),
    },
    {
      'id': 'notif-3',
      'user_id': 'mock-investor-1',
      'type': 'kyc',
      'title': 'تم اعتماد حسابك',
      'body': 'تم التحقق من هويتك بنجاح، صرت تقدر تستثمر بكل المشاريع النشطة.',
      'is_read': true,
      'created_at': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
    },
    {
      'id': 'notif-4',
      'user_id': 'mock-investor-1',
      'type': 'payment',
      'title': 'بانتظار إتمام الدفع',
      'body': 'استثمارك بمشروع "محطة طاقة شمسية صغيرة" بانتظار تأكيد الدفع.',
      'is_read': false,
      'created_at': DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
    },
  ];

  /// يتأكد إنه في بروفايل مرتبط بالإيميل، وإذا مش موجود يسوي وحدة جديدة تلقائياً
  /// (مفيد لما تسجّل دخول بإيميل مش من الحسابات الجاهزة فوق).
  static String ensureProfileForEmail(String email) {
    final normalized = email.trim().toLowerCase();

    if (demoAccounts.containsKey(normalized)) {
      return demoAccounts[normalized]!;
    }

    final existing = profiles.entries.firstWhere(
      (e) => (e.value['email'] as String?)?.toLowerCase() == normalized,
      orElse: () => const MapEntry('', {}),
    );
    if (existing.key.isNotEmpty) return existing.key;

    final role = normalized.contains('admin')
        ? 'admin'
        : normalized.contains('owner')
            ? 'project_owner'
            : 'investor';

    final newId = 'mock-auto-${normalized.hashCode.abs()}';
    profiles[newId] = {
      'id': newId,
      'full_name': normalized.split('@').first,
      'email': normalized,
      'role': role,
      'kyc_status': 'not_submitted',
      'phone': null,
      'avatar_url': null,
      'created_at': DateTime.now().toIso8601String(),
    };
    return newId;
  }
}
