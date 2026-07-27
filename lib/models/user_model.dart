enum UserRole { investor, projectOwner, admin }

enum KycStatus { notSubmitted, pending, approved, rejected }

class AppUser {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String country;
  final UserRole role;
  final KycStatus kycStatus;
  final String? avatarUrl;
  final DateTime createdAt;
  final double walletBalance;

  AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.country,
    required this.role,
    this.kycStatus = KycStatus.notSubmitted,
    this.avatarUrl,
    required this.createdAt,
    this.walletBalance = 0,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      fullName: map['full_name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      country: map['country'] as String? ?? '',
      role: UserRole.values.firstWhere(
        (r) => r.name == (map['role'] ?? 'investor'),
        orElse: () => UserRole.investor,
      ),
      kycStatus: KycStatus.values.firstWhere(
        (k) => k.name == (map['kyc_status'] ?? 'notSubmitted'),
        orElse: () => KycStatus.notSubmitted,
      ),
      avatarUrl: map['avatar_url'] as String?,
      createdAt: DateTime.tryParse(map['created_at']?.toString() ?? '') ?? DateTime.now(),
      walletBalance: (map['wallet_balance'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'country': country,
        'role': role.name,
        'kyc_status': kycStatus.name,
        'avatar_url': avatarUrl,
        'wallet_balance': walletBalance,
      };
}
