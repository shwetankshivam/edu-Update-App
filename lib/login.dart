import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    //progress circle
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator.adaptive(),
            ));

    //try signing in

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextController.text,
          password: passwordTextController.text);

      //pop progrss circle

      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop progress circle
      Navigator.pop(context);

      //display error message
      displayMessage(e.code);
    }
  }

  // error message

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
              fontSize: 18,
              fontWeight: FontWeight.w500,
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
            padding: EdgeInsets.symmetric(horizontal: 35.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),

                //app logo
                const Icon(
                  CupertinoIcons.person_crop_circle,
                  size: 60,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 10,
                ),
                //welcome back message
                const Text(
                  'Please login to continue',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w300),
                ),

                const SizedBox(height: 40),

                //email
                MyTextField(
                    controller: emailTextController,
                    obsecureText: false,
                    hintText: "name@s.amity.edu"),

                const SizedBox(height: 15),

                //password
                MyTextField(
                    controller: passwordTextController,
                    obsecureText: true,
                    hintText: "Password"),
                const SizedBox(height: 30),

                //sign in button

                MyButton(
                  text: "Login",
                  onTap: signIn,
                ),
                const SizedBox(height: 20),

                //register page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'new user?',
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
