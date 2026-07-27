class AppConstants {
  static const String appName = 'شراكة | Sharaka';

  // Supabase - يتم تحميلها من ملف .env (لا تكتب المفاتيح هنا مباشرة)
  static const String supabaseUrlEnvKey = 'SUPABASE_URL';
  static const String supabaseAnonKeyEnvKey = 'SUPABASE_ANON_KEY';

  // أدوار المستخدمين
  static const String roleInvestor = 'investor';
  static const String roleOwner = 'project_owner';
  static const String roleAdmin = 'admin';

  // حالات المشروع
  static const String projectPending = 'pending_review';
  static const String projectApproved = 'active';
  static const String projectFunded = 'funded';
  static const String projectRejected = 'rejected';
  static const String projectClosed = 'closed';

  // حالات KYC
  static const String kycNotSubmitted = 'not_submitted';
  static const String kycPending = 'pending';
  static const String kycApproved = 'approved';
  static const String kycRejected = 'rejected';

  // قطاعات المشاريع (قابلة للتوسعة)
  static const List<String> sectors = [
    'تجارة التجزئة',
    'مطاعم وضيافة',
    'تقنية',
    'عقارات',
    'صناعة وتصنيع',
    'خدمات لوجستية',
    'زراعة',
    'طاقة',
    'أخرى',
  ];

  // دول الخليج المستهدفة
  static const List<String> targetCountries = [
    'سلطنة عمان',
    'الإمارات',
    'السعودية',
    'البحرين',
    'الكويت',
    'قطر',
  ];
}
