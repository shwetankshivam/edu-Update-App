import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String user;
  final String text;
  final String time;
  const Comment(
      {super.key, required this.text, required this.time, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            //comment
            Text(text),
            //user and time
            Row(
              children: [
                Text(user),
                const Text(" · "),
                Text(time),
              ],
            ),
          ],
        ));
  }
}
