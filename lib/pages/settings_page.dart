import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../components/title_area.dart';
import '../providers/navigation_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  void goToProfile() {
    final NavigationProvider navigationProvider =
      Provider.of<NavigationProvider>(context, listen: false);
    navigationProvider.currentIndex = 2;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        goToProfile();
      },
      child: const Scaffold(
        backgroundColor: Color.fromARGB(255, 223, 225, 238),
        body: Column(
          children: [
            TitleArea(title: 'Settings'),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
