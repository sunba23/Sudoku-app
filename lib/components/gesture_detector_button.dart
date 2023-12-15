import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget gestureDetectorButton(
    IconData icon,
    String text,
    void Function()? onTap,
    double vw,
    double vh,
    BuildContext context,
    ) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 85*vw,
      height: 8*vh,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xffebebf5)
      ),
      child: Row(
        children: [
          text == "Sign Out" ? Expanded( // sign out should look different
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(5*vw, 0, 5*vw, 0),
                  child: Icon(
                    icon,
                    size: 25,
                    color: const Color.fromARGB(255, 57, 64, 83),
                  ),
                ),
              ],
            ),
          ) : Container(
            padding: EdgeInsets.fromLTRB(5*vw, 0, 5*vw, 0),
            child: Icon(
              icon,
              size: 25,
              color: const Color.fromARGB(255, 57, 64, 83),
            ),
          ),
          Text(text,
              style: GoogleFonts.nunito(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                // color: const Color(0xffdfe1ee)
                color: const Color.fromARGB(255, 57, 64, 83),
              )),
          const Spacer(),
        ],
      ),
    ),
  );
}