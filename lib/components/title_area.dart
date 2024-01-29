import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleArea extends StatelessWidget {
  const TitleArea({
    super.key,
    required this.title,
    this.icon,
    this.onTap,
    this.heroOne,
    this.heroTwo,
  });

  final String title;
  final IconData? icon;
  final VoidCallback? onTap;
  final Hero? heroOne;
  final Hero? heroTwo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 70, 0, 16),
      child: Row(
        children: [
          (icon != null) ? Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: GestureDetector(
              onTap: onTap,
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ) : const SizedBox(width: 30),
          onTap == null ? const SizedBox(width: 0) : const SizedBox(width: 16),
          Text(title,
              style: GoogleFonts.nunito(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              )),
          if (heroOne != null) heroOne!,
          if (heroTwo != null) heroTwo!,
        ],
      ),
    );
  }
}
