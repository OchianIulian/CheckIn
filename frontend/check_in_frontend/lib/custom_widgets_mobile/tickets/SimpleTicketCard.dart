import 'package:check_in_frontend/custom_widgets_mobile//tickets/TicketData.dart';
import 'package:flutter/material.dart';

class SimpleTicketCard extends StatelessWidget {
  final TicketData data;

  const SimpleTicketCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Small height so ~3 fit on most screens.
    return SizedBox(
      height: 110,
      child: ClipPath(
        clipper: _TicketNotchClipper(
          cornerRadius: 14,
          notchRadius: 10,
          notchCenterY: 55,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.85),
            border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(14),
            // ignored by ClipPath, but ok
          ),
          child: Row(
            children: [
              // Left block (placeholder for icon / image later)
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.confirmation_number_outlined),
              ),
              const SizedBox(width: 12),

              // Middle text
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      data.subtitle,
                      style: const TextStyle(fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Right side small chevron
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _TicketNotchClipper extends CustomClipper<Path> {
  final double cornerRadius;
  final double notchRadius;
  final double notchCenterY;

  const _TicketNotchClipper({
    required this.cornerRadius,
    required this.notchRadius,
    required this.notchCenterY,
  });

  @override
  Path getClip(Size size) {
    final base = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(cornerRadius),
        ),
      );

    final holes = Path()
      ..addOval(Rect.fromCircle(center: Offset(0, notchCenterY), radius: notchRadius))
      ..addOval(Rect.fromCircle(center: Offset(size.width, notchCenterY), radius: notchRadius));

    return Path.combine(PathOperation.difference, base, holes);
  }

  @override
  bool shouldReclip(covariant _TicketNotchClipper oldClipper) {
    return cornerRadius != oldClipper.cornerRadius ||
        notchRadius != oldClipper.notchRadius ||
        notchCenterY != oldClipper.notchCenterY;
  }
}

