import 'package:app/pages/entry.dart';
import 'package:app/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class LoginOrMainPage extends StatelessWidget {
  const LoginOrMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Amplify.Auth.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const MainPage();
        } else {
          return const EntryScreen();
        }
      },
    );
  }
}