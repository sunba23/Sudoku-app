import 'package:app/bloc/detect_solve_bloc/detect_solve_sudoku_bloc.dart';
import 'package:app/pages/camera_page.dart';
import 'package:app/pages/confirm.dart';
import 'package:app/pages/entry.dart';
import 'package:app/pages/history_page.dart';
import 'package:app/pages/login_or_main_page.dart';
import 'package:app/pages/main_page.dart';
import 'package:app/providers/navigation_provider.dart';
import 'package:app/themes/dark_theme.dart';
import 'package:app/themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';
import 'helpers/configure_amplify.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureAmplify();
  await dotenv.load();
  // runApp(const MyApp());
  runApp(
    MultiBlocProvider(
      providers:
      [
        BlocProvider<DetectSolveSudokuBloc>(
          create: (context) => DetectSolveSudokuBloc(),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<NavigationProvider>(
            create: (_) => NavigationProvider(),
          ),
        ],
        child: const MyApp(),
      )
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginOrMainPage(),
      theme: lightTheme,
      darkTheme: darkTheme,
      routes: {
        '/entry': (context) => const EntryScreen(),
        '/main_page': (context) => const MainPage(),
        '/history_page': (context) => const HistoryPage(),
        '/camera_page': (context) => CameraPage(),
        '/confirm': (context) => ConfirmScreen(data: ModalRoute.of(context)!.settings.arguments as LoginData),
      },
    );
  }
}
