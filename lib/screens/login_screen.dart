// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/components/show_dialog.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/shared/constants.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "loginScreen";

  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {

  bool isLogining = false;

  String? email;
  String? password;

  final _auth = FirebaseAuth.instance;

  Future<void> login() async {

    setState(() {
      isLogining = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      Navigator.pushNamed(context, ChatScreen.id);

      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showAlertDialog(
          context,
          "Login message",
          'No user found for that email.',
        );
      } else if (e.code == 'wrong-password') {
        showAlertDialog(
          context,
          "Login message",
          'Wrong password provided for that user.',
        );
      }
    } catch (e) {
      showAlertDialog(context, "Login message", e.toString());
    }

    setState(() {
      isLogining = false;
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
              decoration:
                  kInputDecoration.copyWith(hintText: "Enter your email"),
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
              decoration:
                  kInputDecoration.copyWith(hintText: "Enter your password"),
            ),
            const SizedBox(
              height: 24.0,
            ),
            isLogining ? const Center(
              child: CircularProgressIndicator(),
            ) : RoundedButton(
              buttonColor: Colors.blueAccent,
              onPressed: () {
                login();
              },
              labelText: "Log In",
            ),
          ],
        ),
      ),
    );
  }
}
