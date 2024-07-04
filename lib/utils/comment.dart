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
        margin: EdgeInsets.only(top: 6),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //comment
              Text(
                text,
                style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
              ),
              //user and time
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    user,
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.normal),
                  ),
                  const Text("  "),
                  Text(
                    time,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
