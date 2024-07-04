import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final bool isliked;
  final Function()? onTap;
  const LikeButton({super.key, required this.isliked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isliked ? Icons.favorite : Icons.favorite_border,
        size: 20,
        color: isliked ? Colors.red.shade400 : Colors.grey,
      ),
    );
  }
}
