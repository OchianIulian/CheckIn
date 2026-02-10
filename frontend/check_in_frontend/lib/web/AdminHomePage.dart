import 'package:check_in_frontend/web/utilitars/AdminLocation.dart';
import 'package:check_in_frontend/web/utilitars/CompanyEditResult.dart';
import 'package:check_in_frontend/web/utilitars/SubscriptionPlan.dart';
import 'package:flutter/material.dart';

import 'custom_widgets/CardSetupCard.dart';
import 'custom_widgets/CompanyCard.dart';
import 'custom_widgets/CompanyEditDialog.dart';
import 'custom_widgets/ConfirmDialog.dart';
import 'custom_widgets/LocationEditDialog.dart';
import 'custom_widgets/LocationsCard.dart';
import 'custom_widgets/PlanEditDialog.dart';
import 'custom_widgets/PlansCard.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  // Company data
  String companyName = 'My Company';
  String companyLocation = 'Bucharest, RO';
  String companyDescription =
      'Short company description. Explain what you offer and what makes you unique.';

  // Card setup (placeholder state)
  bool cardConfigured = false;
  String? cardLast4;
  String? cardBrand;

  // Locations + plans
  final List<AdminLocation> locations = [
    AdminLocation(
      id: 'loc_1',
      name: 'Location 1',
      address: 'Str. Example 10',
      city: 'Bucharest',
      plans: [
        SubscriptionPlan(
          id: 'p1',
          title: 'Basic',
          priceRon: 99,
          durationDays: 30,
          description: 'Access during working hours.',
          active: true,
        ),
        SubscriptionPlan(
          id: 'p2',
          title: 'Premium',
          priceRon: 199,
          durationDays: 30,
          description: 'Extended hours + perks.',
          active: true,
        ),
      ],
    ),
    AdminLocation(
      id: 'loc_2',
      name: 'Location 2',
      address: 'Bd. Demo 25',
      city: 'Cluj-Napoca',
      plans: [],
    ),
  ];

  String? selectedLocationId;

  @override
  void initState() {
    super.initState();
    if (locations.isNotEmpty) {
      selectedLocationId = locations.first.id;
    }
  }

  AdminLocation? get selectedLocation {
    final id = selectedLocationId;
    if (id == null) return null;
    final idx = locations.indexWhere((l) => l.id == id);
    if (idx < 0) return null;
    return locations[idx];
  }

  @override
  Widget build(BuildContext context) {
    final loc = selectedLocation;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 1100;

          final left = _buildLeftColumn(context);
          final right = _buildRightColumn(context, loc);

          if (!isWide) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  left,
                  const SizedBox(height: 16),
                  right,
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 460, child: left),
                const SizedBox(width: 16),
                Expanded(child: right),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLeftColumn(BuildContext context) {
    return Column(
      children: [
        _cardContainer(
          child: CompanyCard(
            name: companyName,
            location: companyLocation,
            description: companyDescription,
            onEdit: () async {
              final res = await showDialog<CompanyEditResult>(
                context: context,
                builder: (_) => CompanyEditDialog(
                  initialName: companyName,
                  initialLocation: companyLocation,
                  initialDescription: companyDescription,
                ),
              );
              if (res == null) return;
              setState(() {
                companyName = res.name;
                companyLocation = res.location;
                companyDescription = res.description;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        _cardContainer(
          child: CardSetupCard(
            configured: cardConfigured,
            brand: cardBrand,
            last4: cardLast4,
            onConfigure: () async {
              // Placeholder: simulate card configuration
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => const ConfirmDialog(
                  title: 'Configure card',
                  message:
                  'This is a placeholder. In real app you would open Stripe/Netopia setup flow.\n\nSimulate successful card setup?',
                  confirmText: 'Yes',
                ),
              );
              if (ok != true) return;

              setState(() {
                cardConfigured = true;
                cardBrand = 'VISA';
                cardLast4 = '4242';
              });
            },
            onRemove: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => const ConfirmDialog(
                  title: 'Remove card',
                  message: 'Are you sure you want to remove the configured card?',
                  confirmText: 'Remove',
                ),
              );
              if (ok != true) return;
              setState(() {
                cardConfigured = false;
                cardBrand = null;
                cardLast4 = null;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRightColumn(BuildContext context, AdminLocation? loc) {
    return Column(
      children: [
        _cardContainer(
          child: LocationsCard(
            locations: locations,
            selectedId: selectedLocationId,
            onSelect: (id) => setState(() => selectedLocationId = id),
            onAdd: () async {
              final res = await showDialog<AdminLocation>(
                context: context,
                builder: (_) => LocationEditDialog(
                  title: 'Add location',
                  initial: null,
                ),
              );
              if (res == null) return;

              setState(() {
                locations.add(res);
                selectedLocationId = res.id;
              });
            },
            onEdit: (location) async {
              final res = await showDialog<AdminLocation>(
                context: context,
                builder: (_) => LocationEditDialog(
                  title: 'Edit location',
                  initial: location,
                ),
              );
              if (res == null) return;

              setState(() {
                final idx = locations.indexWhere((l) => l.id == location.id);
                if (idx >= 0) locations[idx] = res;
              });
            },
            onDelete: (location) async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => ConfirmDialog(
                  title: 'Delete location',
                  message:
                  'Delete "${location.name}"?\n\nPlans for this location will also be removed.',
                  confirmText: 'Delete',
                ),
              );
              if (ok != true) return;

              setState(() {
                locations.removeWhere((l) => l.id == location.id);
                if (selectedLocationId == location.id) {
                  selectedLocationId = locations.isEmpty ? null : locations.first.id;
                }
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        _cardContainer(
          child: PlansCard(
            location: loc,
            onAdd: (location) async {
              final plan = await showDialog<SubscriptionPlan>(
                context: context,
                builder: (_) => PlanEditDialog(
                  title: 'Add plan',
                  initial: null,
                ),
              );
              if (plan == null) return;

              setState(() {
                final idx = locations.indexWhere((l) => l.id == location.id);
                if (idx >= 0) {
                  locations[idx] = locations[idx].copyWith(
                    plans: [...locations[idx].plans, plan],
                  );
                }
              });
            },
            onEdit: (location, plan) async {
              final updated = await showDialog<SubscriptionPlan>(
                context: context,
                builder: (_) => PlanEditDialog(
                  title: 'Edit plan',
                  initial: plan,
                ),
              );
              if (updated == null) return;

              setState(() {
                final idx = locations.indexWhere((l) => l.id == location.id);
                if (idx >= 0) {
                  final plans = [...locations[idx].plans];
                  final pIdx = plans.indexWhere((p) => p.id == plan.id);
                  if (pIdx >= 0) plans[pIdx] = updated;
                  locations[idx] = locations[idx].copyWith(plans: plans);
                }
              });
            },
            onDelete: (location, plan) async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => ConfirmDialog(
                  title: 'Delete plan',
                  message: 'Delete plan "${plan.title}"?',
                  confirmText: 'Delete',
                ),
              );
              if (ok != true) return;

              setState(() {
                final idx = locations.indexWhere((l) => l.id == location.id);
                if (idx >= 0) {
                  final plans = locations[idx].plans.where((p) => p.id != plan.id).toList();
                  locations[idx] = locations[idx].copyWith(plans: plans);
                }
              });
            },
            onToggleActive: (location, plan) {
              setState(() {
                final idx = locations.indexWhere((l) => l.id == location.id);
                if (idx >= 0) {
                  final plans = [...locations[idx].plans];
                  final pIdx = plans.indexWhere((p) => p.id == plan.id);
                  if (pIdx >= 0) {
                    plans[pIdx] = plans[pIdx].copyWith(active: !plans[pIdx].active);
                  }
                  locations[idx] = locations[idx].copyWith(plans: plans);
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _cardContainer({required Widget child}) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}


