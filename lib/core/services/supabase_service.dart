import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'mock_data.dart';

/// نقطة الوصول الموحدة لكل بيانات التطبيق - Auth, Postgres, Storage.
///
/// [mockMode] لما تكون true (الوضع الافتراضي حالياً)، كل البيانات
/// بتيجي من [MockData] المحلية بدون أي اتصال إنترنت أو Supabase حقيقي —
/// مفيد لمعاينة تصميم التطبيق بسرعة. لما يصير عندك مشروع Supabase
/// حقيقي جاهز، خلي القيمة false وحط بيانات .env الصحيحة.
class SupabaseService {
  SupabaseService._();
  static final SupabaseService instance = SupabaseService._();

  static bool mockMode = true;

  SupabaseClient get client => Supabase.instance.client;

  // ---------------- حالة الجلسة (وضع Mock) ----------------
  String? _mockUserId;

  String? get currentUserId => mockMode ? _mockUserId : client.auth.currentUser?.id;
  bool get isLoggedIn => mockMode ? _mockUserId != null : client.auth.currentUser != null;

  static Future<void> initialize() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      dotenv.testLoad(fileInput: '');
    }
    if (mockMode) return; // ما في داعي نربط Supabase فعلياً بوضع المحاكاة

    final url = dotenv.env['SUPABASE_URL'];
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'];
    final hasRealConfig = url != null && url.startsWith('http') && anonKey != null && anonKey.isNotEmpty;

    await Supabase.initialize(
      url: hasRealConfig ? url : 'https://placeholder.supabase.co',
      anonKey: hasRealConfig ? anonKey! : 'placeholder-anon-key',
    );
  }

  // ---------------- Auth ----------------
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role, // investor | project_owner
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mockMode) {
      final normalized = email.trim().toLowerCase();
      final newId = 'mock-auto-${normalized.hashCode.abs()}';
      MockData.profiles[newId] = {
        'id': newId,
        'full_name': fullName,
        'email': normalized,
        'role': role,
        'kyc_status': 'not_submitted',
        'phone': null,
        'avatar_url': null,
        'created_at': DateTime.now().toIso8601String(),
      };
      _mockUserId = newId;
      return;
    }
    final res = await client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName, 'role': role},
    );
    if (res.user != null) {
      await client.from('profiles').insert({
        'id': res.user!.id,
        'full_name': fullName,
        'email': email,
        'role': role,
        'kyc_status': 'not_submitted',
      });
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mockMode) {
      _mockUserId = MockData.ensureProfileForEmail(email);
      return;
    }
    await client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    if (mockMode) {
      _mockUserId = null;
      return;
    }
    await client.auth.signOut();
  }

  // ---------------- Profile ----------------
  Future<Map<String, dynamic>?> getMyProfile() async {
    if (mockMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      final uid = currentUserId;
      if (uid == null) return null;
      return MockData.profiles[uid];
    }
    final uid = currentUserId;
    if (uid == null) return null;
    final data = await client.from('profiles').select().eq('id', uid).maybeSingle();
    return data;
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    if (mockMode) {
      final uid = currentUserId;
      if (uid == null) return;
      MockData.profiles[uid] = {...?MockData.profiles[uid], ...updates};
      return;
    }
    final uid = currentUserId;
    if (uid == null) return;
    await client.from('profiles').update(updates).eq('id', uid);
  }

  // ---------------- Projects ----------------
  Future<List<Map<String, dynamic>>> fetchProjects({
    String? sector,
    String? country,
    String status = 'active',
  }) async {
    if (mockMode) {
      await Future.delayed(const Duration(milliseconds: 400));
      return MockData.projects.where((p) {
        if (p['status'] != status) return false;
        if (sector != null && sector.isNotEmpty && p['sector'] != sector) return false;
        if (country != null && country.isNotEmpty && p['country'] != country) return false;
        return true;
      }).toList();
    }
    var query = client.from('projects').select().eq('status', status);
    if (sector != null && sector.isNotEmpty) {
      query = query.eq('sector', sector);
    }
    if (country != null && country.isNotEmpty) {
      query = query.eq('country', country);
    }
    final data = await query.order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  Future<List<Map<String, dynamic>>> fetchMyProjects() async {
    if (mockMode) {
      await Future.delayed(const Duration(milliseconds: 400));
      final uid = currentUserId;
      return MockData.projects.where((p) => p['owner_id'] == uid).toList();
    }
    final uid = currentUserId;
    if (uid == null) return [];
    final data = await client
        .from('projects')
        .select()
        .eq('owner_id', uid)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> createProject(Map<String, dynamic> project) async {
    if (mockMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      final uid = currentUserId;
      final newId = 'proj-mock-${DateTime.now().millisecondsSinceEpoch}';
      MockData.projects.insert(0, {
        'id': newId,
        'owner_id': uid,
        'status': 'pending_review',
        'amount_raised': 0,
        'created_at': DateTime.now().toIso8601String(),
        ...project,
      });
      return;
    }
    final uid = currentUserId;
    if (uid == null) return;
    await client.from('projects').insert({
      ...project,
      'owner_id': uid,
      'status': 'pending_review',
    });
  }

  Future<Map<String, dynamic>?> fetchProjectById(String id) async {
    if (mockMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      try {
        return MockData.projects.firstWhere((p) => p['id'] == id);
      } catch (_) {
        return null;
      }
    }
    return client.from('projects').select().eq('id', id).maybeSingle();
  }

  // ---------------- Investments ----------------
  Future<void> createInvestment({
    required String projectId,
    required double amount,
    required double sharesPercentage,
  }) async {
    if (mockMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      final uid = currentUserId;
      MockData.investments.insert(0, {
        'id': 'inv-mock-${DateTime.now().millisecondsSinceEpoch}',
        'investor_id': uid,
        'project_id': projectId,
        'amount': amount,
        'shares_percentage': sharesPercentage,
        'status': 'pending_payment',
        'created_at': DateTime.now().toIso8601String(),
      });
      return;
    }
    final uid = currentUserId;
    if (uid == null) return;
    await client.from('investments').insert({
      'investor_id': uid,
      'project_id': projectId,
      'amount': amount,
      'shares_percentage': sharesPercentage,
      'status': 'pending_payment',
    });
  }

  Future<List<Map<String, dynamic>>> fetchMyPortfolio() async {
    if (mockMode) {
      await Future.delayed(const Duration(milliseconds: 400));
      final uid = currentUserId;
      final mine = MockData.investments.where((i) => i['investor_id'] == uid).toList();
      return mine.map((inv) {
        Map<String, dynamic>? project;
        try {
          project = MockData.projects.firstWhere((p) => p['id'] == inv['project_id']);
        } catch (_) {
          project = null;
        }
        return {...inv, 'projects': project};
      }).toList();
    }
    final uid = currentUserId;
    if (uid == null) return [];
    final data = await client
        .from('investments')
        .select('*, projects(*)')
        .eq('investor_id', uid)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  Future<List<Map<String, dynamic>>> fetchProjectInvestors(String projectId) async {
    if (mockMode) {
      await Future.delayed(const Duration(milliseconds: 400));
      final list = MockData.investments.where((i) => i['project_id'] == projectId).toList();
      return list.map((inv) {
        final profile = MockData.profiles[inv['investor_id']];
        return {
          ...inv,
          'profiles': profile == null
              ? null
              : {'full_name': profile['full_name'], 'email': profile['email']},
        };
      }).toList();
    }
    final data = await client
        .from('investments')
        .select('*, profiles(full_name, email)')
        .eq('project_id', projectId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  // ---------------- Notifications ----------------
  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    if (mockMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      final uid = currentUserId;
      final list = MockData.notifications.where((n) => n['user_id'] == uid).toList();
      list.sort((a, b) => (b['created_at'] as String).compareTo(a['created_at'] as String));
      return list;
    }
    final uid = currentUserId;
    if (uid == null) return [];
    final data = await client
        .from('notifications')
        .select()
        .eq('user_id', uid)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  // ---------------- Admin ----------------
  Future<List<Map<String, dynamic>>> fetchPendingProjects() async {
    if (mockMode) {
      await Future.delayed(const Duration(milliseconds: 400));
      return MockData.projects.where((p) => p['status'] == 'pending_review').toList();
    }
    final data = await client
        .from('projects')
        .select()
        .eq('status', 'pending_review')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  Future<List<Map<String, dynamic>>> fetchPendingKycUsers() async {
    if (mockMode) {
      await Future.delayed(const Duration(milliseconds: 400));
      return MockData.profiles.values.where((p) => p['kyc_status'] == 'pending').toList();
    }
    final data = await client
        .from('profiles')
        .select()
        .eq('kyc_status', 'pending')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> updateProjectStatus(String id, String status) async {
    if (mockMode) {
      final idx = MockData.projects.indexWhere((p) => p['id'] == id);
      if (idx != -1) MockData.projects[idx]['status'] = status;
      return;
    }
    await client.from('projects').update({'status': status}).eq('id', id);
  }

  Future<void> updateKycStatus(String userId, String status) async {
    if (mockMode) {
      final profile = MockData.profiles[userId];
      if (profile != null) profile['kyc_status'] = status;
      return;
    }
    await client.from('profiles').update({'kyc_status': status}).eq('id', userId);
  }

  // ---------------- Storage (KYC docs, project files) ----------------
  Future<String> uploadFile({
    required String bucket,
    required String path,
    required Uint8List bytes,
  }) async {
    if (mockMode) {
      await Future.delayed(const Duration(milliseconds: 600));
      return 'https://picsum.photos/seed/${path.hashCode.abs()}/400/400';
    }
    await client.storage.from(bucket).uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(upsert: true),
        );
    return client.storage.from(bucket).getPublicUrl(path);
  }
}
