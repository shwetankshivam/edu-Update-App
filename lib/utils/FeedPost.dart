import 'package:flutter/material.dart';

class FeedPost extends StatelessWidget {
  final String message;
  final String user;
  // final String time;
  const FeedPost({
    super.key,
    required this.message,
    required this.user,
    // required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.only(top: 20, left: 25, right: 25),
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          // message and user email
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user,
                style: TextStyle(color: Colors.black45),
              ),
              const SizedBox(height: 8),
              Text(message),
            ],
          )
        ],
      ),
    );
  }
}
