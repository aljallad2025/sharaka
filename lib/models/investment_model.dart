class InvestmentModel {
  final String id;
  final String investorId;
  final String projectId;
  final double amount;
  final double sharesPercentage;
  final String status; // pending_payment | completed | failed | refunded
  final DateTime? createdAt;
  final Map<String, dynamic>? project; // بيانات المشروع المرفقة (join)

  InvestmentModel({
    required this.id,
    required this.investorId,
    required this.projectId,
    required this.amount,
    required this.sharesPercentage,
    required this.status,
    this.createdAt,
    this.project,
  });

  factory InvestmentModel.fromMap(Map<String, dynamic> map) {
    return InvestmentModel(
      id: map['id'].toString(),
      investorId: map['investor_id'] ?? '',
      projectId: map['project_id'].toString(),
      amount: (map['amount'] ?? 0).toDouble(),
      sharesPercentage: (map['shares_percentage'] ?? 0).toDouble(),
      status: map['status'] ?? 'pending_payment',
      createdAt: map['created_at'] != null ? DateTime.tryParse(map['created_at']) : null,
      project: map['projects'] as Map<String, dynamic>?,
    );
  }
}
