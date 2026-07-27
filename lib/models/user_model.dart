class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String role; // investor | project_owner | admin
  final String kycStatus; // not_submitted | pending | approved | rejected
  final String? phone;
  final String? avatarUrl;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.kycStatus,
    this.phone,
    this.avatarUrl,
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      fullName: map['full_name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'investor',
      kycStatus: map['kyc_status'] ?? 'not_submitted',
      phone: map['phone'],
      avatarUrl: map['avatar_url'],
      createdAt: map['created_at'] != null ? DateTime.tryParse(map['created_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'role': role,
      'kyc_status': kycStatus,
      'phone': phone,
      'avatar_url': avatarUrl,
    };
  }

  bool get isOwner => role == 'project_owner';
  bool get isInvestor => role == 'investor';
  bool get isAdmin => role == 'admin';
  bool get isKycApproved => kycStatus == 'approved';
}
