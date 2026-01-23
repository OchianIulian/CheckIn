import 'package:flutter/material.dart';
import '../custom_widgets/OfferCard.dart';
import '../utilitars/LocationData.dart';
import '../utilitars/OfferData.dart';



class LocationDetailsPage extends StatelessWidget {
  final LocationData location;

  const LocationDetailsPage({super.key, required this.location});

  // Demo offers; le vei lua din backend mai tarziu
  List<OfferData> _offersFor(LocationData l) {
    return const [
      OfferData(
        title: "Single pass",
        subtitle: "1 entry • valid 7 days",
        priceText: "35 RON",
        badge: "Popular",
      ),
      OfferData(
        title: "Monthly",
        subtitle: "Unlimited entries • 30 days",
        priceText: "149 RON",
      ),
      OfferData(
        title: "Family pack",
        subtitle: "4 entries • valid 30 days",
        priceText: "99 RON",
      ),
    ];
  }

  void _openInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(location.name),
        content: Text(
          "Aici poti vedea abonamentele si ticketele disponibile pentru aceasta locatie.\n\n"
              "Mai tarziu poti pune descriere, program, reguli, adresa etc.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final offers = _offersFor(location);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _openInfo(context),
            tooltip: "Info",
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Column(
            children: [
              Text(
                location.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "${location.type} • ${location.city}",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 34),
            ],
          ),

          const SizedBox(height: 10),

          ...offers.map(
                (o) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: OfferCard(
                offer: o,
                onTap: () {
                  // TODO: open checkout / details
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


