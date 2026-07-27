class ProjectModel {
  final String id;
  final String ownerId;
  final String title;
  final String description;
  final String sector;
  final String country;
  final double fundingGoal;
  final double amountRaised;
  final double sharesOfferedPercentage;
  final double pricePerSharePercent; // سعر كل 1% من الأسهم
  final String status; // pending_review | active | funded | rejected | closed
  final List<String> imageUrls;
  final List<String> documentUrls;
  final DateTime? deadline;
  final DateTime? createdAt;

  ProjectModel({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.sector,
    required this.country,
    required this.fundingGoal,
    required this.amountRaised,
    required this.sharesOfferedPercentage,
    required this.pricePerSharePercent,
    required this.status,
    this.imageUrls = const [],
    this.documentUrls = const [],
    this.deadline,
    this.createdAt,
  });

  double get progressRatio =>
      fundingGoal <= 0 ? 0 : (amountRaised / fundingGoal).clamp(0, 1);

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'].toString(),
      ownerId: map['owner_id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      sector: map['sector'] ?? '',
      country: map['country'] ?? '',
      fundingGoal: (map['funding_goal'] ?? 0).toDouble(),
      amountRaised: (map['amount_raised'] ?? 0).toDouble(),
      sharesOfferedPercentage: (map['shares_offered_percentage'] ?? 0).toDouble(),
      pricePerSharePercent: (map['price_per_share_percent'] ?? 0).toDouble(),
      status: map['status'] ?? 'pending_review',
      imageUrls: List<String>.from(map['image_urls'] ?? []),
      documentUrls: List<String>.from(map['document_urls'] ?? []),
      deadline: map['deadline'] != null ? DateTime.tryParse(map['deadline']) : null,
      createdAt: map['created_at'] != null ? DateTime.tryParse(map['created_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'sector': sector,
      'country': country,
      'funding_goal': fundingGoal,
      'shares_offered_percentage': sharesOfferedPercentage,
      'price_per_share_percent': pricePerSharePercent,
      'image_urls': imageUrls,
      'document_urls': documentUrls,
      'deadline': deadline?.toIso8601String(),
    };
  }
}
