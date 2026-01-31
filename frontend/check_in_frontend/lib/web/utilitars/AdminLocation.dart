import 'SubscriptionPlan.dart';

class AdminLocation {
  final String id;
  final String name;
  final String address;
  final String city;
  final List<SubscriptionPlan> plans;

  AdminLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.plans,
  });

  AdminLocation copyWith({
    String? id,
    String? name,
    String? address,
    String? city,
    List<SubscriptionPlan>? plans,
  }) {
    return AdminLocation(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      city: city ?? this.city,
      plans: plans ?? this.plans,
    );
  }
}