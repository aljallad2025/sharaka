enum ProjectStatus { draft, pendingReview, funding, funded, closed, rejected }

class InvestmentProject {
  final String id;
  final String ownerId;
  final String title;
  final String sector;
  final String country;
  final String city;
  final String shortDescription;
  final String fullDescription;
  final String coverImageUrl;
  final List<String> galleryUrls;
  final double targetAmount;
  final double raisedAmount;
  final double sharePrice;
  final double totalShares;
  final double soldShares;
  final double minInvestment;
  final double expectedAnnualReturn; // نسبة العائد المتوقع %
  final DateTime fundingDeadline;
  final ProjectStatus status;
  final int investorsCount;
  final DateTime createdAt;

  InvestmentProject({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.sector,
    required this.country,
    required this.city,
    required this.shortDescription,
    required this.fullDescription,
    required this.coverImageUrl,
    this.galleryUrls = const [],
    required this.targetAmount,
    this.raisedAmount = 0,
    required this.sharePrice,
    required this.totalShares,
    this.soldShares = 0,
    required this.minInvestment,
    required this.expectedAnnualReturn,
    required this.fundingDeadline,
    this.status = ProjectStatus.pendingReview,
    this.investorsCount = 0,
    required this.createdAt,
  });

  double get fundingProgress => targetAmount == 0 ? 0 : (raisedAmount / targetAmount).clamp(0, 1);
  double get remainingShares => totalShares - soldShares;
  int get daysRemaining => fundingDeadline.difference(DateTime.now()).inDays;

  factory InvestmentProject.fromMap(Map<String, dynamic> map) {
    return InvestmentProject(
      id: map['id'] as String,
      ownerId: map['owner_id'] as String,
      title: map['title'] as String? ?? '',
      sector: map['sector'] as String? ?? '',
      country: map['country'] as String? ?? '',
      city: map['city'] as String? ?? '',
      shortDescription: map['short_description'] as String? ?? '',
      fullDescription: map['full_description'] as String? ?? '',
      coverImageUrl: map['cover_image_url'] as String? ?? '',
      galleryUrls: (map['gallery_urls'] as List?)?.cast<String>() ?? [],
      targetAmount: (map['target_amount'] as num?)?.toDouble() ?? 0,
      raisedAmount: (map['raised_amount'] as num?)?.toDouble() ?? 0,
      sharePrice: (map['share_price'] as num?)?.toDouble() ?? 0,
      totalShares: (map['total_shares'] as num?)?.toDouble() ?? 0,
      soldShares: (map['sold_shares'] as num?)?.toDouble() ?? 0,
      minInvestment: (map['min_investment'] as num?)?.toDouble() ?? 0,
      expectedAnnualReturn: (map['expected_annual_return'] as num?)?.toDouble() ?? 0,
      fundingDeadline: DateTime.tryParse(map['funding_deadline']?.toString() ?? '') ??
          DateTime.now().add(const Duration(days: 30)),
      status: ProjectStatus.values.firstWhere(
        (s) => s.name == (map['status'] ?? 'pendingReview'),
        orElse: () => ProjectStatus.pendingReview,
      ),
      investorsCount: map['investors_count'] as int? ?? 0,
      createdAt: DateTime.tryParse(map['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}
