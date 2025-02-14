import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:update/auth/auth.dart';
import 'package:update/utils/Homepage.dart';
// import 'package:update/auth/login_or_register.dart';
// import 'package:update/utils/Homepage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'UPDATE',
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
