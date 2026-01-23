import 'package:check_in_frontend/custom_widgets_mobile//tickets/SimpleTicketCard.dart';
import 'package:check_in_frontend/custom_widgets_mobile//tickets/TicketData.dart';
import 'package:check_in_frontend/utils_mobile/CustomColors.dart';
import 'package:flutter/material.dart';

import '../custom_widgets_mobile//TicketPopupDialog.dart';
import '../custom_widgets_mobile//WaveClipper.dart';

class ClientHomePage extends StatelessWidget {
  const ClientHomePage({super.key});
  final tickets = const [
    TicketData(title: "Ticket #1", subtitle: "Short info"),
    TicketData(title: "Ticket #2", subtitle: "Short info"),
    TicketData(title: "Ticket #3", subtitle: "Short info"),
    TicketData(title: "Ticket #4", subtitle: "Short info"),
    TicketData(title: "Ticket #1", subtitle: "Short info"),
    TicketData(title: "Ticket #2", subtitle: "Short info"),
    TicketData(title: "Ticket #3", subtitle: "Short info"),
    TicketData(title: "Ticket #4", subtitle: "Short info"),
    TicketData(title: "Ticket #1", subtitle: "Short info"),
    TicketData(title: "Ticket #2", subtitle: "Short info"),
    TicketData(title: "Ticket #3", subtitle: "Short info"),
    TicketData(title: "Ticket #4", subtitle: "Short info"),
  ];

  void _openTicketDialog(BuildContext context, TicketData t) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => TicketPopupDialog(
        businessName: t.title,
        serviceName: t.subtitle,
        remaining: 0,
        total: 1,
        expDateText: "EXP: 12 Feb 2026",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 320,
                color: CustomColors.greenDark,
              ),
            ),
          ),
          ListView(
            padding: const EdgeInsets.all(12),
            children: [
              const SizedBox(height: 46),

              // Header text block
              Text(
                "Tickets & Subscriptions",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Choose your fighter to create new memories!",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),

              const SizedBox(height: 18),

              // Tickets
              ...tickets.map(
                    (t) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _openTicketDialog(context, t),
                    child: (SimpleTicketCard(data: t))
                  ),
                ),
              ),
            ],
          ),


        ],
      )
    );
  }
}

