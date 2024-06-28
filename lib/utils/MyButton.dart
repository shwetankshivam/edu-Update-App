import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Function()? ontap;

  const MyButton({super.key, required this.text, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(12)),
      child: Center(
          child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 20),
      )),
    );
  }
}
