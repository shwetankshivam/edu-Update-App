
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    //progress circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );

    if (passwordTextController.text != confirmPasswordTextController.text) {
      //pop progress circle
      Navigator.pop(context);

      //show error message
      displayMessage("Passwords don't match!");
      return;
    }

    //try creating the user

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextController.text,
          password: passwordTextController.text);

      //pop progrss circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop progress circle
      Navigator.pop(context);

      //show user the error message
      displayMessage(e.code);
    }
  }
  // error message

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
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
            padding: EdgeInsets.symmetric(horizontal: 35.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),

                //app logo
                const Icon(
                  CupertinoIcons.person_crop_circle_badge_plus,
                  size: 60,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 8,
                ),
                //welcome back message
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

                //email
                MyTextField(
                    controller: emailTextController,
                    obsecureText: false,
                    hintText: "name@s.amity.edu"),

                const SizedBox(height: 20),

                //password
                MyTextField(
                    controller: passwordTextController,
                    obsecureText: true,
                    hintText: "Password"),
                const SizedBox(height: 20),
                // confirm password
                MyTextField(
                    controller: confirmPasswordTextController,
                    obsecureText: true,
                    hintText: "Confirm Password"),
                const SizedBox(height: 20),

                //sign up button

                MyButton(text: "Sign up", onTap: signUp),
                const SizedBox(height: 20),

                //register page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'already have an account?',
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
