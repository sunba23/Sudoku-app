import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/navigation_provider.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({super.key});

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  bool _isDarkMode = false;

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
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 223, 225, 238),
        body: Column(
          children: [
            const SizedBox(height: 24),
            buildDarkModeSwitch(),
          ],
        ),
      ),
    );
  }

  Widget buildDarkModeSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Dark Mode',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Switch(
          value: _isDarkMode,
          onChanged: (value) {
            setState(() {
              _isDarkMode = value;
            });
          },
          activeColor: const Color.fromARGB(255, 57, 64, 83),
        ),
      ],
    );
  }
}