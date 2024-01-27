// import 'package:firebase_auth/firebase_auth.dart';
// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_messaging_app/component/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../component/alert.dart';
import '../../../../component/phone_field.dart';
import '/component/snacky.dart' as snackBarHelper;
import '../../../../utils/responsive/responsive_layout.dart';
import '../../domain/repositories/firebase_auth_service.dart';
import 'log_in.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _resetPasswordState();
}

class _resetPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: const ResponsiveLayout(
        desktopBody: DesktopForgotPassword(),
        mobileBody: MobileForgotPassword(),
        tabletBody: TabletForgotPassword(),
      ),
    );
  }
}

class MobileForgotPassword extends StatefulWidget {
  const MobileForgotPassword({
    super.key,
  });

  @override
  State<MobileForgotPassword> createState() => _MobileForgotPasswordState();
}

class _MobileForgotPasswordState extends State<MobileForgotPassword> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  // final TextEditingController _phonenumberController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  void resetPassword(String phoneNumber) async {
    final usersRef = FirebaseFirestore.instance.collection("agent");
    final userQuery = usersRef.where("phone", isEqualTo: phoneNumber);
    final userSnapshot = await userQuery.get();
    final snacky = snackBarHelper.SnackBarHelper(context);
    if (userSnapshot.docs.isNotEmpty) {
      // Generate a new password
      final newPassword = generatePassword();

      // Update the user's document with the new password
      final userDoc = userSnapshot.docs.first;
      await userDoc.reference.update({
        'password': newPassword,
      });

      // Send the new password to the user (e.g., via email or SMS)

      // Provide feedback to the user

      // await launchUrl(Uri.parse(
      //     'https://wa.me/$phoneNumber/?text=${Uri.encodecomponent('Your CS Chat Account Password is: \n\n *$newPassword*\n\nSave it for future logins')}'));

      // Navigate to the login screen
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LogInUser()));
      Alert.show(
        context,
        title: 'New Password',
        message: newPassword,
        isError: true,
      );
    } else {
      snacky.showSnackBar("User not found. Please check your phone number.",
          isError: true);
    }
  }

  String generatePassword() {
    const String capitalLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String smallLetters = 'abcdefghijklmnopqrstuvwxyz';
    const String specialCharacters = '!@#\$%^&*()_-+=<>?';
    const String numbers = '0123456789';

    const String passwordString =
        '$capitalLetters$smallLetters$specialCharacters$numbers';

    final random = Random.secure();

    // Generate one capital letter
    final capitalLetter = capitalLetters[random.nextInt(capitalLetters.length)];

    // Generate one small letter
    final smallLetter = smallLetters[random.nextInt(smallLetters.length)];

    // Generate one special character
    final specialCharacter =
        specialCharacters[random.nextInt(specialCharacters.length)];

    // Generate seven numbers
    final numbersList = List.generate(7, (index) {
      final randomIndex = random.nextInt(numbers.length);
      return numbers[randomIndex];
    });

    // Shuffle the numbers to randomize their order
    numbersList.shuffle(random);

    // Combine all the components to form the password
    final passwordcomponents = <String>[
      capitalLetter,
      smallLetter,
      specialCharacter,
      ...numbersList
    ];
    passwordcomponents.shuffle(random);

    final password = passwordcomponents.join(); // Convert the list to a string

    return password;
  }

  @override
  Widget build(BuildContext context) {
    // final ap = Provider.of<AuthProvider>(context, listen: false);

    return Center(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            Padding(
              padding: const EdgeInsets.all(8.0)
                  .add(const EdgeInsets.symmetric(vertical: 40)),
              child: Image.asset('assets/cs_messaging_app_logo_mark.png',
                  width: 250, height: 150),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                // Wrap the row with Center
                child: Text(
                  'Enter Phone number to reset Password',
                  style: TextStyle(
                    fontFamily: 'Gilmer',
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 400,
              child: Column(children: [
                PhoneField(
                  prefix: Icons.phone_iphone_rounded,
                  title: 'Enter PhoneNumber',
                  text: 'Enter PhoneNumber',
                  validator: (value) {
                    if (value == null) {
                      return 'Please Enter PhoneNumber';
                    }
                    return null;
                  },
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  controller: _phonenumberController,
                ),
              ]),
            ),
            FormButton(
              text: 'Reset Password',
              action: () {
                final phoneNumber = _phonenumberController.text.trim();
                resetPassword(phoneNumber);
              },
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class DesktopForgotPassword extends StatefulWidget {
  const DesktopForgotPassword({
    super.key,
  });

  @override
  State<DesktopForgotPassword> createState() => _DesktopForgotPasswordState();
}

class _DesktopForgotPasswordState extends State<DesktopForgotPassword> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  // final TextEditingController _phonenumberController = TextEditingController();
  void resetPassword(String phoneNumber) async {
    final usersRef = FirebaseFirestore.instance.collection("agent");
    final userQuery = usersRef.where("phone", isEqualTo: phoneNumber);
    final userSnapshot = await userQuery.get();
    final snacky = snackBarHelper.SnackBarHelper(context);

    if (userSnapshot.docs.isNotEmpty) {
      // Generate a new password
      final newPassword = generatePassword();

      // Update the user's document with the new password
      final userDoc = userSnapshot.docs.first;
      await userDoc.reference.update({
        'password': newPassword,
      });

      // Send the new password to the user (e.g., via email or SMS)

      // Provide feedback to the user

       await launchUrl(Uri.parse(
      'https://wa.me/$phoneNumber/?text=${Uri.encodeComponent('Your CS Chat Account Password is: \n\n *$newPassword*\n\nSave it for future logins')}',
    ));
      // Navigate to the login screen
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LogInUser()));
      Alert.show(
        context,
        title: 'New Password',
        message: newPassword,
        isError: true,
      );
    } else {
      snacky.showSnackBar("User not found. Please check your phone number.",
          isError: true);
    }
  }

  String generatePassword() {
    const String capitalLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String smallLetters = 'abcdefghijklmnopqrstuvwxyz';
    const String specialCharacters = '!@#\$%^&*()_-+=<>?';
    const String numbers = '0123456789';

    const String passwordString =
        '$capitalLetters$smallLetters$specialCharacters$numbers';

    final random = Random.secure();

    // Generate one capital letter
    final capitalLetter = capitalLetters[random.nextInt(capitalLetters.length)];

    // Generate one small letter
    final smallLetter = smallLetters[random.nextInt(smallLetters.length)];

    // Generate one special character
    final specialCharacter =
        specialCharacters[random.nextInt(specialCharacters.length)];

    // Generate seven numbers
    final numbersList = List.generate(7, (index) {
      final randomIndex = random.nextInt(numbers.length);
      return numbers[randomIndex];
    });

    // Shuffle the numbers to randomize their order
    numbersList.shuffle(random);

    // Combine all the components to form the password
    final passwordcomponents = <String>[
      capitalLetter,
      smallLetter,
      specialCharacter,
      ...numbersList
    ];
    passwordcomponents.shuffle(random);

    final password = passwordcomponents.join(); // Convert the list to a string

    return password;
  }

  @override
  Widget build(BuildContext context) {
    // final ap = Provider.of<AuthProvider>(context, listen: false);
    final formKey = GlobalKey<FormState>();

    return Center(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            Padding(
              padding: const EdgeInsets.all(8.0)
                  .add(const EdgeInsets.symmetric(vertical: 40)),
              child: Image.asset('assets/cs_messaging_app_logo_mark.png',
                  width: 250, height: 150),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                // Wrap the row with Center
                child: Text(
                  'Enter Phone number to reset Password',
                  style: TextStyle(
                    fontFamily: 'Gilmer',
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 400,
              child: Column(children: [
                PhoneField(
                  prefix: Icons.phone_iphone_rounded,
                  title: 'Enter PhoneNumber',
                  text: 'Enter PhoneNumber',
                  validator: (value) {
                    if (value == null) {
                      return 'Please Enter PhoneNumber';
                    }
                    return null;
                  },
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  controller: _phonenumberController,
                ),
              ]),
            ),
            FormButton(
              text: 'Reset Password',
              action: () {
                final phoneNumber = _phonenumberController.text.trim();
                resetPassword(phoneNumber);
              },
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class TabletForgotPassword extends StatefulWidget {
  const TabletForgotPassword({
    super.key,
  });

  @override
  State<TabletForgotPassword> createState() => _TabletForgotPasswordState();
}

class _TabletForgotPasswordState extends State<TabletForgotPassword> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  // final TextEditingController _phonenumberController = TextEditingController();
  void resetPassword(String phoneNumber) async {
    final usersRef = FirebaseFirestore.instance.collection("agent");
    final userQuery = usersRef.where("phone", isEqualTo: phoneNumber);
    final userSnapshot = await userQuery.get();
    final snacky = snackBarHelper.SnackBarHelper(context);

    if (userSnapshot.docs.isNotEmpty) {
      // Generate a new password
      final newPassword = generatePassword();

      // Update the user's document with the new password
      final userDoc = userSnapshot.docs.first;
      await userDoc.reference.update({
        'password': newPassword,
      });

      // Send the new password to the user (e.g., via email or SMS)

      // Provide feedback to the user

      
      // Navigate to the login screen
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LogInUser()));
      Alert.show(
        context,
        title: 'New Password',
        message: newPassword,
        isError: true,
      );
    } else {
      snacky.showSnackBar("User not found. Please check your phone number.",
          isError: true);
    }
  }

  String generatePassword() {
    const String capitalLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String smallLetters = 'abcdefghijklmnopqrstuvwxyz';
    const String specialCharacters = '!@#\$%^&*()_-+=<>?';
    const String numbers = '0123456789';

    const String passwordString =
        '$capitalLetters$smallLetters$specialCharacters$numbers';

    final random = Random.secure();

    // Generate one capital letter
    final capitalLetter = capitalLetters[random.nextInt(capitalLetters.length)];

    // Generate one small letter
    final smallLetter = smallLetters[random.nextInt(smallLetters.length)];

    // Generate one special character
    final specialCharacter =
        specialCharacters[random.nextInt(specialCharacters.length)];

    // Generate seven
    final numbersList = List.generate(7, (index) {
      final randomIndex = random.nextInt(numbers.length);
      return numbers[randomIndex];
    });

    // Shuffle the numbers to randomize their order
    numbersList.shuffle(random);

    // Combine all the components to form the password
    final passwordcomponents = <String>[
      capitalLetter,
      smallLetter,
      specialCharacter,
      ...numbersList
    ];
    passwordcomponents.shuffle(random);

    final password = passwordcomponents.join(); // Convert the list to a string

    return password;
  }

  @override
  Widget build(BuildContext context) {
    // final ap = Provider.of<AuthProvider>(context, listen: false);
    final formKey = GlobalKey<FormState>();

    return Center(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            Padding(
              padding: const EdgeInsets.all(8.0)
                  .add(const EdgeInsets.symmetric(vertical: 40)),
              child: Image.asset('assets/cs_messaging_app_logo_mark.png',
                  width: 250, height: 150),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                // Wrap the row with Center
                child: Text(
                  'Enter Phone number to reset Password',
                  style: TextStyle(
                    fontFamily: 'Gilmer',
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 400,
              child: Column(children: [
                PhoneField(
                  prefix: Icons.phone_iphone_rounded,
                  title: 'Enter PhoneNumber',
                  text: 'Enter PhoneNumber',
                  validator: (value) {
                    if (value == null) {
                      return 'Please Enter PhoneNumber';
                    }
                    return null;
                  },
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  controller: _phonenumberController,
                ),
              ]),
            ),
            FormButton(
              text: 'Reset Password',
              action: () {
                final phoneNumber = _phonenumberController.text.trim();
                resetPassword(phoneNumber);
              },
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
