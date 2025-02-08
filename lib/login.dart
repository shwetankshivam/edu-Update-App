import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:update/auth/auth.dart';
import 'package:update/auth/email_verifiy.dart';
import 'package:update/utils/MyButton.dart';
import 'package:update/utils/TextField.dart';

class Login extends StatefulWidget {
  final Function()? onTap;
  const Login({super.key, required this.onTap});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  void signIn() async {
    // Show progress circle
    showDialog(
      context: context,
      // barrierDismissible: false, // Prevents closing by tapping outside
      builder: (context) => Center(child: CircularProgressIndicator.adaptive()),
    );

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text.trim(),
        password: passwordTextController.text.trim(),
      );
      if (context.mounted) {
        Navigator.pop(context); // Close progress indicator
      }

      User? user = FirebaseAuth.instance.currentUser;
      await user?.reload(); // Ensure user data is refreshed
      user = FirebaseAuth.instance.currentUser;

      if (context.mounted) {
        Navigator.pop(context); // Close progress indicator
      }

      if (user != null) {
        if (user.emailVerified) {
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AuthPage()),
            );
          }
        } else {
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => EmailVerificationPage(user: user)),
            );
          }
        }
      } else {
        if (context.mounted) {
          displayMessage("User not found!");
        }
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close progress indicator on error
        displayMessage(e.message ?? "Login failed");
      }
    }
  }

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0),
            child: Column(
              children: [
                const SizedBox(height: 100),
                const Icon(
                  CupertinoIcons.person_crop_circle,
                  size: 60,
                  color: Colors.black,
                ),
                const SizedBox(height: 15),
                const Text(
                  'Please use .edu email to login',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w300),
                ),
                const SizedBox(height: 25),
                MyTextField(
                    controller: emailTextController,
                    obsecureText: false,
                    hintText: "name@s.amity.edu"),
                const SizedBox(height: 15),
                MyTextField(
                    controller: passwordTextController,
                    obsecureText: true,
                    hintText: "Password"),
                const SizedBox(height: 30),
                MyButton(
                  text: "Login",
                  onTap: signIn,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'New user?',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Register here',
                        style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
