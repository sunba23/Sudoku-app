import 'package:app/pages/camera_page.dart';
import 'package:app/pages/confirm.dart';
import 'package:app/pages/entry.dart';
import 'package:app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'helpers/configure_amplify.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureAmplify();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: EntryScreen(),
      routes: {
        '/entry': (context) => const EntryScreen(),
        '/home_page': (context) => const HomePage(),
        '/camera_page': (context) => const CameraPage(),
        '/confirm': (context) => ConfirmScreen(data: ModalRoute.of(context)!.settings.arguments as LoginData),
      }

    );
  }
}
