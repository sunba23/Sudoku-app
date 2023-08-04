import 'package:app/pages/camera_page.dart';
import 'package:app/pages/confirm.dart';
import 'package:app/pages/entry.dart';
import 'package:app/pages/home_page.dart';
import 'package:app/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'helpers/configure_amplify.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureAmplify();
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          secondary: Colors.white,
          primary: Colors.white,
        )
      ),
      home: const EntryScreen(),
      routes: {
        '/entry': (context) => const EntryScreen(),
        '/main_page': (context) => const MainPage(),
        '/home_page': (context) => const HomePage(),
        '/camera_page': (context) => const CameraPage(),
        '/confirm': (context) => ConfirmScreen(data: ModalRoute.of(context)!.settings.arguments as LoginData),
      },
    );
  }
}
