import 'package:app/components/gesture_detector_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

import '../components/title_area.dart';
import '../providers/navigation_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _displayNameController = TextEditingController();

  void goToProfile() {
    final NavigationProvider navigationProvider =
    Provider.of<NavigationProvider>(context, listen: false);
    navigationProvider.currentIndex = 2;
  }

  Future<void> _changeDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('displayName', _displayNameController.text);
  }

  void showChangeDisplayNameDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Display Name'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.width * 0.2,
          child: TextField(
            controller: _displayNameController,
            decoration: const InputDecoration(hintText: 'Enter new display name'),
          ),
        ),
        actions: [
          ElevatedButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            onPressed: () {
              _changeDisplayName();
              Navigator.of(context).pop();
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void shareApp() {
    final box = context.findRenderObject() as RenderBox?;
    Share.share(
      'Check out this awesome app called Sudoku Solver!',
      subject: 'Sudoku Solver',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    double vw = MediaQuery.of(context).size.width / 100;
    double vh = MediaQuery.of(context).size.height / 100;

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
              title: "Settings",
              onTap: () {
                goToProfile();
              },
              icon: Icons.arrow_back_rounded,
            ),
            const SizedBox(height: 24),
            gestureDetectorButton(CupertinoIcons.pencil_outline, "Change display name", showChangeDisplayNameDialog, vw, vh, context),
            SizedBox(height: 3 * vh),
            gestureDetectorButton(Icons.share, "Share app", shareApp, vw, vh, context),
          ],
        ),
      ),
    );
  }
}