enum InvestmentStatus { pending, confirmed, cancelled, refunded }

class Investment {
  final String id;
  final String investorId;
  final String projectId;
  final String projectTitle;
  final String projectCoverUrl;
  final double sharesCount;
  final double amount;
  final double ownershipPercentage;
  final InvestmentStatus status;
  final DateTime createdAt;

  Investment({
    required this.id,
    required this.investorId,
    required this.projectId,
    required this.projectTitle,
    required this.projectCoverUrl,
    required this.sharesCount,
    required this.amount,
    required this.ownershipPercentage,
    this.status = InvestmentStatus.pending,
    required this.createdAt,
  });

  factory Investment.fromMap(Map<String, dynamic> map) {
    return Investment(
      id: map['id'] as String,
      investorId: map['investor_id'] as String,
      projectId: map['project_id'] as String,
      projectTitle: map['project_title'] as String? ?? '',
      projectCoverUrl: map['project_cover_url'] as String? ?? '',
      sharesCount: (map['shares_count'] as num?)?.toDouble() ?? 0,
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      ownershipPercentage: (map['ownership_percentage'] as num?)?.toDouble() ?? 0,
      status: InvestmentStatus.values.firstWhere(
        (s) => s.name == (map['status'] ?? 'pending'),
        orElse: () => InvestmentStatus.pending,
      ),
      createdAt: DateTime.tryParse(map['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}
