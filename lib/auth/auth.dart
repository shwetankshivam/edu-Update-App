import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:update/auth/login_or_register.dart';
import 'package:update/utils/Homepage.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        // Initialize FlutterFire

        builder: (context, snapshot) {
          //user is logged in
          if (snapshot.hasData) {
            return const Homepage();
          } else {
            //not logged in
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
