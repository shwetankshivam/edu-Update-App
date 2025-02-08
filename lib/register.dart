import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:update/auth/email_verifiy.dart';
import 'package:update/utils/MyButton.dart';
import 'package:update/utils/TextField.dart';

class Register extends StatefulWidget {
  final Function()? onTap;
  const Register({super.key, required this.onTap});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  void signUp() async {
    showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (context) =>
          const Center(child: CircularProgressIndicator.adaptive()),
    );

    if (!emailTextController.text.endsWith('.edu')) {
      Navigator.pop(context);
      displayMessage("Please use an '.edu' email address!");
      return;
    }

    if (passwordTextController.text != confirmPasswordTextController.text) {
      Navigator.pop(context);
      displayMessage("Passwords don't match!");
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text.trim(),
        password: passwordTextController.text.trim(),
      );

      User? user = userCredential.user;
      await user?.sendEmailVerification();

      if (context.mounted) {
        Navigator.pop(context); // Close progress dialog
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => EmailVerificationPage(user: user)),
        );
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessage(e.message ?? "Registration failed");
    }
  }

  // Improved Firebase error messages
  String _getFirebaseErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return "This email is already in use!";
      case 'weak-password':
        return "Your password is too weak!";
      case 'invalid-email':
        return "Invalid email format!";
      case 'operation-not-allowed':
        return "Sign-up is currently disabled!";
      default:
        return "Registration failed! Please try again.";
    }
  }

  // Display error messages
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
                // App logo
                const Icon(
                  CupertinoIcons.person_crop_circle_badge_plus,
                  size: 60,
                  color: Colors.black,
                ),
                const SizedBox(height: 8),
                // Registration message
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Please register using ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w300),
                    ),
                    Text(
                      '.edu email',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Email field
                MyTextField(
                    controller: emailTextController,
                    obsecureText: false,
                    hintText: "name@s.amity.edu"),
                const SizedBox(height: 20),

                // Password field
                MyTextField(
                    controller: passwordTextController,
                    obsecureText: true,
                    hintText: "Password"),
                const SizedBox(height: 20),

                // Confirm Password field
                MyTextField(
                    controller: confirmPasswordTextController,
                    obsecureText: true,
                    hintText: "Confirm Password"),
                const SizedBox(height: 20),

                // Sign-up button
                MyButton(text: "Sign up", onTap: signUp),
                const SizedBox(height: 20),

                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Login here.',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
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
