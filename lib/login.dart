import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:update/utils/MyButton.dart';
import 'package:update/utils/TextField.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  CupertinoIcons.person,
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

                const SizedBox(height: 30),

                //password
                MyTextField(
                    controller: passwordTextController,
                    obsecureText: true,
                    hintText: "Password"),
                const SizedBox(height: 30),
                //sign in button
                
                MyButton(text: "Login", ontap: () {})

                //register page
              ],
            ),
          ),
        ),
      ),
    );
  }
}
