import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleArea extends StatelessWidget {
  const TitleArea({
    Key? key,
    required this.title,
    this.icon,
    this.onTap,
  }) : super(key: key);

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
              color: const Color.fromARGB(255, 57, 64, 83),
            ),
          ),
          onTap == null ? const SizedBox(width: 0) : const SizedBox(width: 16),
          Text(
            title,
            style: GoogleFonts.nunito(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 57, 64, 83),
            )
          ),
        ],
      ),
    );
  }
}