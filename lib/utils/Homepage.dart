import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:update/utils/MyButton.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

//log out user
void signOut() {
  FirebaseAuth.instance.signOut();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text(
          'UPDATE',
          style: TextStyle(color: Colors.black),
        ),
        actions: const [
          TextButton(
            onPressed: signOut,
            child: Text(
              "sign out",
              style: TextStyle(
                  fontSize: 17, color: Colors.red, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
