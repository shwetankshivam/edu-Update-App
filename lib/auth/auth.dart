import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:update/auth/email_verifiy.dart';
import 'package:update/auth/login_or_register.dart';
import 'package:update/utils/Homepage.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator
                    .adaptive()); // Show loading while checking
          }

          final user = snapshot.data;

          if (user == null) {
            return const LoginOrRegister(); // Show login/register screen
          } else if (!user.emailVerified) {
            return EmailVerificationPage(
                user: user); // Force email verification
          } else {
            return Homepage(); // Navigate to home if verified
          }
        },
      ),
    );
  }
}
