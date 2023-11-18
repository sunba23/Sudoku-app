import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String email = '';

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         // const SizedBox(height: 24),
    //         buildEmail(email),
    //         // const SizedBox(height: 24),
    //         // buildUpdateEmail('Update Email', () => updateUserEmail(newEmail: email)),
    //       ],
    //     ),
    //   ),
    // );
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Profile page',
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
      ),
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   fetchAndSetUserEmail();
  // }
  //
  // Future<void> fetchAndSetUserEmail() async {
  //   final fetchedEmail = await fetchUserEmail();
  //   if (mounted) { // need to avoid calling `setState` if the widget is no longer in the widget tree
  //     setState(() {
  //       email = fetchedEmail;
  //     });
  //   }
  // }
  //
  // Future<String> fetchUserEmail() async {
  //   try {
  //     AuthUserAttributeKey attributeKey = AuthUserAttributeKey.email;
  //     final attributes = await Amplify.Auth.fetchUserAttributes();
  //     return attributes
  //         .singleWhere((attr) => attr.userAttributeKey == attributeKey)
  //         .value;
  //   } catch (e) {
  //     return 'Error fetching user email';
  //   }
  // }
  //
  // Widget buildEmail(String email) => Column(
  //   children: [
  //     Text(
  //       "Email:\n$email",
  //       style: const TextStyle(
  //         fontFamily: 'Poppins',
  //         fontSize: 24,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //   ],
  // );

  // Widget buildUpdateEmail(String text, Function() onClicked) => OutlinedButton(
  //       onPressed: onClicked,
  //       child: Text(
  //         text,
  //         style: const TextStyle(fontSize: 24, color: Colors.black),
  //       ),
  //     );
  //
  // Future<void> updateUserEmail({
  //   required String newEmail,
  // }) async {
  //   try {
  //     final result = await Amplify.Auth.updateUserAttribute(
  //       userAttributeKey: AuthUserAttributeKey.email,
  //       value: newEmail,
  //     );
  //     _handleUpdateUserAttributeResult(result);
  //   } on AuthException catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         backgroundColor: Colors.blueAccent,
  //         content: Text('Error updating user attribute: ${e.message}',
  //             style: const TextStyle(fontSize: 15)),
  //       ),
  //     );
  //   }
  // }
  //
  // void _handleUpdateUserAttributeResult(
  //   UpdateUserAttributeResult result,
  // ) {
  //   switch (result.nextStep.updateAttributeStep) {
  //     case AuthUpdateAttributeStep.confirmAttributeWithCode:
  //       final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
  //       _handleCodeDelivery(codeDeliveryDetails);
  //       break;
  //     case AuthUpdateAttributeStep.done:
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           backgroundColor: Colors.blueAccent,
  //           content: Text('Successfully updated attribute',
  //               style: TextStyle(fontSize: 15)),
  //         ),
  //       );
  //       break;
  //   }
  // }
  //
  // void _handleCodeDelivery(AuthCodeDeliveryDetails codeDeliveryDetails) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       backgroundColor: Colors.blueAccent,
  //       content: Text(
  //           'A confirmation code has been sent to ${codeDeliveryDetails.destination}. '
  //           'Please check your ${codeDeliveryDetails.deliveryMedium.name} for the code.',
  //           style: const TextStyle(fontSize: 15)),
  //     ),
  //   );
  // }
}
