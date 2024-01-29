import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginData _data = LoginData(name: '', password: '');
  bool _isSignedIn = false;

  Future<String?> _onLogin(LoginData data) async {
    try {
      // try { // if user session is still valid, sign out
      //   // final user = await Amplify.Auth.getCurrentUser();
      //   // await Amplify.Auth.signOut();
      //   // final username = user.username;
      //   // final password = user.password;
      //   // if (mounted) {
      //   //   Navigator.of(context).pushReplacementNamed(
      //   //     '/main_page',
      //   //     // arguments: LoginData(name: data.name, password: data.password),
      //   //   );
      //   // }
      // } catch (e) { // there is no user session, so do nothing
      //   print(e);
      // }
      final res = await Amplify.Auth.signIn(
        username: data.name,
        password: data.password,
      );
      _isSignedIn = res.isSignedIn;
    } on AuthException catch (e) {
      return (e.message);
    }
    _data = data;
    return '';
  }

  Future<String?> _onSignup(SignupData data) async {
    try {
      final name = data.name;
      final password = data.password;

      if (name == null || password == null) {
        return 'Name or password is null';
      }

      await Amplify.Auth.signUp(
        username: name,
        password: password,
        options: SignUpOptions(
          userAttributes: {
            AuthUserAttributeKey.email: name,
          },
        ),
      );
      _data = LoginData(name: name, password: password);
    } on AuthException catch (e) {
      return e.message;
    }
    return '';
  }

  Future<String> _onRecoverPassword(BuildContext context, String email) async {
    try {
      final res = await Amplify.Auth.resetPassword(username: email);

      if (res.nextStep.updateStep == 'CONFIRM_RESET_PASSWORD_WITH_CODE') {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(
            '/confirm-reset',
            arguments: LoginData(name: email, password: ''),
          );
        }
      }
    } on AuthException catch (e) {
      return (e.message);
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      //TODO: saved login & password
      title: 'SolveSudoku',
      // titleTag: 'title',
      onLogin: _onLogin,
      onSignup: _onSignup,
      onRecoverPassword: (String email) => _onRecoverPassword(context, email),
      // logo: 'lib/assets/images/logo.png',
      // logoTag: 'logo',
      theme: LoginTheme(
        // beforeHeroFontSize: 40,
        // afterHeroFontSize: 20,
        // primaryColor: Theme.of(context).colorScheme.primary,
        // textFieldStyle: GoogleFonts.nunito(
        //   color: Theme.of(context).colorScheme.primary,
        //   fontSize: 20,
        // ),
        // buttonTheme: LoginButtonTheme(
        //   backgroundColor: Theme.of(context).colorScheme.onPrimary,
        //   splashColor: Theme.of(context).colorScheme.onSurface,
        // ),
        pageColorDark: Theme.of(context).colorScheme.tertiary,
        pageColorLight: Theme.of(context).colorScheme.tertiary,
        titleStyle: GoogleFonts.nunito(
          color: Theme.of(context).colorScheme.background,
        ),
        // bodyStyle: GoogleFonts.nunito(
        //   color: Theme.of(context).colorScheme.primary,
        //   fontSize: 20,
        // ),
        cardTheme: CardTheme(
          color: Theme.of(context).colorScheme.background,
          elevation: 3,
        ),
        // buttonStyle: GoogleFonts.nunito(
        //   color: Theme.of(context).colorScheme.background,
        //   fontSize: 15,
        // ),
      ),
      onSubmitAnimationCompleted: () {
        if (context.mounted) {
          Navigator.of(context).pushNamed(
            _isSignedIn ? '/main_page' : '/confirm',
            arguments: {
              'data': _data,
              // 'logoHero': Hero(
              //   tag: 'logo',
              //   child: Image.asset(
              //     'lib/assets/images/logo.png',
              //     width: 40,
              //     height: 40,
              //   ),
              // ),
              // 'titleHero': const Hero(
              //   tag: 'title',
              //   child: Text('Sudoku Solver'),
              // ),
              // 'isFromLogin': true,
            },
          );
        }
      },
    );
  }
}
