import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentButton extends StatelessWidget {
  final Function()? onTap;
  const CommentButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(
        size: 20,
        CupertinoIcons.arrow_turn_down_left,
        color: Colors.grey,
      ),
    );
  }
}
