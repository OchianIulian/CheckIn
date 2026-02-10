class OfferData {
  final String title;       // ex: "Single pass"
  final String subtitle;    // ex: "1 entry • valid 30 days"
  final String priceText;   // ex: "39 RON"
  final String? badge;      // ex: "Popular"

  const OfferData({
    required this.title,
    required this.subtitle,
    required this.priceText,
    this.badge,
  });
}