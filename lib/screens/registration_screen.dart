// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/components/show_dialog.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/shared/constants.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = "registrationScreen";

  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  String? email;
  String? password;
  
  bool isRegistering = false;

  final _auth = FirebaseAuth.instance;

  Future<void> registerUser() async {
    setState(() {
      isRegistering = true; // set the flag to true when registration begins
    });

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      Navigator.pushNamed(context, ChatScreen.id);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showAlertDialog(
            context, "Registration message", "You entered a weak password");
      } else if (e.code == 'email-already-in-use') {
        showAlertDialog(context, "Registration message",
            'The account already exists for that email.');
      }
    } catch (e) {
      showAlertDialog(context, "Registration message", e.toString());
    }

    setState(() {
      isRegistering =
          false; // set the flag back to false when registration completes
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: "logo",
                child: SizedBox(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
            ),
            const SizedBox(
              height: 48.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                email = value;
              },
              decoration: kInputDecoration.copyWith(
                hintText: "Enter your email",
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true,
              obscuringCharacter: "*",
              textAlign: TextAlign.center,
              onChanged: (value) {
                password = value;
              },
              decoration: kInputDecoration.copyWith(
                hintText: "Enter your password",
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            isRegistering
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RoundedButton(
                    buttonColor: Colors.blueAccent,
                    labelText: "Register",
                    onPressed: () {
                      registerUser();
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
