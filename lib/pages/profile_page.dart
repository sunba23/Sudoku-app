import 'package:app/components/gesture_detector_button.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/title_area.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<AuthUserAttribute> userAttributes = [];
  Future<void>? fetchAttributesFuture;

  @override
  void initState() {
    super.initState();
    fetchAttributesFuture = fetchAndSetUserAttributes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 225, 238),
      body: Column(
        children: [
          const TitleArea(title: 'Profile'),
          const SizedBox(height: 24),
          buildProfileUI(userAttributes),
        ],
      ),
    );
  }

  Future<void> fetchAndSetUserAttributes() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      if (mounted){
        setState(() {
          userAttributes = attributes;
        });
      }
      return;
    } catch (e) {
      debugPrint( 'Error fetching user attributes: $e' );
      rethrow;
    }
  }

  Widget buildSignOut() {
    return gestureDetectorButton(
      Icons.logout,
      'Sign Out',
      () async {
        try {
          await Amplify.Auth.signOut();
          if (mounted){
            setState(() {
              userAttributes = [];
            });
            Navigator.of(context).pushNamedAndRemoveUntil('/entry', (route) => false);
          }
        } on AuthException catch (e) {
          debugPrint(e.message);
        }
      },
      MediaQuery.of(context).size.width/100,
      MediaQuery.of(context).size.height/100,
      context,
    );
  }

  Widget buildAdditionalButtons() {
    return Column(
      children: [
        gestureDetectorButton(
          Icons.settings_rounded,
          'Settings',
          () {}, //TODO: navigation
          MediaQuery.of(context).size.width/100,
          MediaQuery.of(context).size.height/100,
          context,
        ),
        const SizedBox(height: 24),
        gestureDetectorButton(
          Icons.palette_rounded,
          'Appearance',
          () {}, //TODO: navigation
          MediaQuery.of(context).size.width/100,
          MediaQuery.of(context).size.height/100,
          context,
        ),
      ],
    );
  }

  Widget buildMainProfileArea() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xffebebf5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.78,
          height: MediaQuery.of(context).size.height * 0.15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xfff4f4fc),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                future: fetchAttributesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    if (snapshot.error != null) {
                      return const Text('An error occurred retrieving user attributes');
                    } else {
                      return Column (
                        children: [
                          Text(
                            userAttributes[2].value, //TODO: use username
                            style: GoogleFonts.nunito(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromARGB(255, 57, 64, 83),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 7, 20, 7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color(0xffebebf5),
                            ),
                            child: Text(
                              userAttributes[2].value,
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromARGB(255, 57, 64, 83),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }
                }
              ),
            ],
          )
        ),
      )
    );
  }

  Widget buildProfileUI(List<AuthUserAttribute> userAttributes) {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildMainProfileArea(),
            const Spacer(),
            buildAdditionalButtons(),
            const Spacer(),
            buildSignOut(),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
