import 'package:app/components/title_area.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/navigation_provider.dart';
import '../providers/theme_notifier.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({super.key});

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {

  void goToProfile() {
    final NavigationProvider navigationProvider =
    Provider.of<NavigationProvider>(context, listen: false);
    navigationProvider.currentIndex = 2;
  }

  @override
  Widget build(BuildContext context) {

    final double vw = MediaQuery.of(context).size.width / 100;
    final double vh = MediaQuery.of(context).size.height / 100;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        goToProfile();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          children: [
            TitleArea(
              title: "Appearance",
              onTap: () {
                goToProfile();
              },
              icon: Icons.arrow_back_rounded,
            ),
            const SizedBox(height: 24),
            buildDarkModeSwitch(vw, vh),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget buildDarkModeSwitch(double vw, double vh) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) => Container(
        height: 8 * vh,
        width: 85 * vw,
        padding: EdgeInsets.fromLTRB(3 * vw, 1 * vh, 3 * vw, 1 * vh),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.dark_mode_rounded,
              size: 30,
            ),
            SizedBox(width: 5 * vw),
            Text(
              'Dark Mode',
              style: GoogleFonts.nunito(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Spacer(),
            Switch(
              value: theme.isDarkMode(),
              onChanged: (value) {
                theme.toggleTheme();
              },
              activeColor: Theme.of(context).colorScheme.onPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
