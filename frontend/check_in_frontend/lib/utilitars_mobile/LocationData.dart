class LocationData {
  final String name;
  final String type;
  final String city;
  final String? imageUrl;

  const LocationData({
    required this.name,
    required this.type,
    required this.city,
    this.imageUrl,
  });
}
