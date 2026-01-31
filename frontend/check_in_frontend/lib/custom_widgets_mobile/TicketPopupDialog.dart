import 'package:check_in_frontend/utils_mobile/CustomColors.dart';
import 'package:flutter/material.dart';

class TicketPopupDialog extends StatelessWidget {
  final String businessName;
  final String serviceName;
  final int remaining;
  final int total;
  final String expDateText;

  const TicketPopupDialog({
    super.key,
    required this.businessName,
    required this.serviceName,
    required this.remaining,
    required this.total,
    required this.expDateText,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            const SizedBox(height: 6),

            // Center image (later QR)
            Center(
              child: Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  color: CustomColors.black06,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(Icons.qr_code_2, size: 72),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              businessName,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              serviceName,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: CustomColors.black72,
              ),
            ),

            const SizedBox(height: 14),

            Text(
              "$remaining/$total",
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                expDateText,
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: CustomColors.black60,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
