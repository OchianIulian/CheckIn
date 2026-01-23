import 'package:check_in_frontend/mobile/LocationPage.dart';
import 'package:check_in_frontend/utils_mobile/CustomColors.dart';
import 'package:flutter/material.dart';

import '../custom_widgets_mobile//LocationCard.dart';
import '../custom_widgets_mobile//SearchBar.dart';
import '../utilitars_mobile//LocationData.dart';


class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  final TextEditingController _searchController = TextEditingController();

  final List<LocationData> _locations = const [
    LocationData(name: "Aqua Park Solaris", type: "Parc de distractii", city: "Bucuresti"),
    LocationData(name: "Muzeul National", type: "Muzeu", city: "Iasi"),
    LocationData(name: "Escape Arena", type: "Escape room", city: "Cluj"),
    LocationData(name: "Sky Trampoline", type: "Trambuline", city: "Timisoara"),
    LocationData(name: "Art Gallery", type: "Galerie", city: "Bucuresti"),
    LocationData(name: "Zoo Park", type: "Gradina zoologica", city: "Iasi"),
    LocationData(name: "Laser Zone", type: "Arena", city: "Bucuresti"),
    LocationData(name: "Retro Museum", type: "Muzeu", city: "Iasi"),
  ];

  late List<bool> _saved;
  String _query = "";

  @override
  void initState() {
    super.initState();
    _saved = List<bool>.filled(_locations.length, false);

    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<int> _filteredIndexes() {
    if (_query.isEmpty) return List.generate(_locations.length, (i) => i);

    final result = <int>[];
    for (int i = 0; i < _locations.length; i++) {
      final l = _locations[i];
      final hay = "${l.name} ${l.type} ${l.city}".toLowerCase();
      if (hay.contains(_query)) result.add(i);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredIndexes();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              CustomColors.greenDark, // top
              Colors.white,            // bottom
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            const SizedBox(height: 86),

            // Header text block
            Center(
              child: Text(
                "Where do you want to go?",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),


            const SizedBox(height: 34),

            CustomSearchBar(controller: _searchController),
            const SizedBox(height: 14),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
              itemBuilder: (context, gridIndex) {
                final originalIndex = filtered[gridIndex];
                final loc = _locations[originalIndex];

                return LocationCard(
                  data: loc,
                  isSaved: _saved[originalIndex],
                  onSaveTap: () {
                    setState(() => _saved[originalIndex] = !_saved[originalIndex]);
                  },
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => LocationDetailsPage(location: loc),
                      ),
                    );

                  },
                );
              },
            ),
          ],
        ),
      )
    );
  }
}





