class SubscriptionPlan {
  final String id;
  final String title;
  final int priceRon;
  final int durationDays;
  final String description;
  final bool active;

  // null = unlimited
  final int? entriesLimit;

  SubscriptionPlan({
    required this.id,
    required this.title,
    required this.priceRon,
    required this.durationDays,
    required this.description,
    required this.active,
    this.entriesLimit,
  });

  SubscriptionPlan copyWith({
    String? id,
    String? title,
    int? priceRon,
    int? durationDays,
    String? description,
    bool? active,
    int? entriesLimit,
  }) {
    return SubscriptionPlan(
      id: id ?? this.id,
      title: title ?? this.title,
      priceRon: priceRon ?? this.priceRon,
      durationDays: durationDays ?? this.durationDays,
      description: description ?? this.description,
      active: active ?? this.active,
      entriesLimit: entriesLimit ?? this.entriesLimit,
    );
  }
}
