import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleArea extends StatelessWidget {
  const TitleArea({
    super.key,
    required this.title,
    this.icon,
    this.onTap,
  });

  final String title;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 70, 0, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          onTap == null ? const SizedBox(width: 0) : const SizedBox(width: 16),
          Text(title,
              style: GoogleFonts.nunito(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              )),
        ],
      ),
    );
  }
}
