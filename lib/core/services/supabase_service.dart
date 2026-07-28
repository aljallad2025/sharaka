import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// نقطة الوصول الموحدة لـ Supabase - Auth, Postgres, Storage
class SupabaseService {
  SupabaseService._();
  static final SupabaseService instance = SupabaseService._();

  SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    // نحاول نحمّل ملف .env، بس إذا مش موجود (مثلاً وضع معاينة بدون باكند)
    // ما بنوقف تشغيل التطبيق.
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      dotenv.testLoad(fileInput: ''); // يهيّئ dotenv بقيم فاضية بدل ما يفشل
    }
    // قيم وهمية صالحة الشكل (placeholder) تمنع Supabase.initialize من
    // رمي استثناء وقت التشغيل لما ما يكون في URL حقيقي — كافي لعرض
    // الشاشات، بس أي طلب فعلي للسيرفر رح يفشل لحد ما تربط مشروعك.
    final url = dotenv.env['SUPABASE_URL'];
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'];
    final hasRealConfig = url != null && url.startsWith('http') && anonKey != null && anonKey.isNotEmpty;

    await Supabase.initialize(
      url: hasRealConfig ? url : 'https://placeholder.supabase.co',
      anonKey: hasRealConfig ? anonKey! : 'placeholder-anon-key',
    );
  }

  // ---------------- Auth ----------------
  User? get currentUser => client.auth.currentUser;
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role, // investor | project_owner
  }) async {
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
    return res;
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() => client.auth.signOut();

  // ---------------- Profile ----------------
  Future<Map<String, dynamic>?> getMyProfile() async {
    final uid = currentUser?.id;
    if (uid == null) return null;
    final data = await client.from('profiles').select().eq('id', uid).maybeSingle();
    return data;
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    final uid = currentUser?.id;
    if (uid == null) return;
    await client.from('profiles').update(updates).eq('id', uid);
  }

  // ---------------- Projects ----------------
  Future<List<Map<String, dynamic>>> fetchProjects({
    String? sector,
    String? country,
    String status = 'active',
  }) async {
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
    final uid = currentUser?.id;
    if (uid == null) return [];
    final data = await client
        .from('projects')
        .select()
        .eq('owner_id', uid)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> createProject(Map<String, dynamic> project) async {
    final uid = currentUser?.id;
    if (uid == null) return;
    await client.from('projects').insert({
      ...project,
      'owner_id': uid,
      'status': 'pending_review',
    });
  }

  Future<Map<String, dynamic>?> fetchProjectById(String id) async {
    return client.from('projects').select().eq('id', id).maybeSingle();
  }

  // ---------------- Investments ----------------
  Future<void> createInvestment({
    required String projectId,
    required double amount,
    required double sharesPercentage,
  }) async {
    final uid = currentUser?.id;
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
    final uid = currentUser?.id;
    if (uid == null) return [];
    final data = await client
        .from('investments')
        .select('*, projects(*)')
        .eq('investor_id', uid)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  // ---------------- Storage (KYC docs, project files) ----------------
  Future<String> uploadFile({
    required String bucket,
    required String path,
    required Uint8List bytes,
  }) async {
    await client.storage.from(bucket).uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(upsert: true),
        );
    return client.storage.from(bucket).getPublicUrl(path);
  }
}
