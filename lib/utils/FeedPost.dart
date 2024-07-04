import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:update/utils/Like_Button.dart';
import 'package:update/utils/comment_button.dart';

class FeedPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;

  // final String time;
  const FeedPost({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,

    // required this.time,
  });

  @override
  State<FeedPost> createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> {
  //user
  final cureentUser = FirebaseAuth.instance.currentUser!;
  bool isliked = false;
  //comment text controller
  final commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isliked = widget.likes.contains(cureentUser.email);
  }

  //toggle likes
  void toggleLike() {
    setState(() {
      isliked = !isliked;
    });

    //add a comment
    void addComment(String commentText) {
      //write a comment in comment collection in firestore
      FirebaseFirestore.instance
          .collection('User Posts')
          .doc(widget.postId)
          .collection("comments")
          .add({
        "CommentText": commentText,
        "CommentedBy": cureentUser.email,
        "CommentTime": Timestamp.now()
      });
    }

    //dialog to add a comment

    void showCommentBox() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Add Comment"),
          content: TextField(
            controller: commentTextController,
            decoration: const InputDecoration(hintText: "reply to this Update"),
          ),
          actions: [
            //save
            TextButton(
              onPressed: () {
                addComment(commentTextController.text);
                commentTextController.clear();
              },
              child: const Text("reply"),
            ),

            //cancel
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                commentTextController.clear();
              },
              child: const Text("cancel"),
            ),
          ],
        ),
      );

      //access document in firebase
      DocumentReference postRef = FirebaseFirestore.instance
          .collection('User Posts')
          .doc(widget.postId);

      if (isliked) {
        //if post is liked, add user's email to the likes field
        postRef.update({
          'Likes': FieldValue.arrayUnion([cureentUser.email])
        });
      } else {
        //if post is unliked, remove user's email to the likes field
        postRef.update({
          'Likes': FieldValue.arrayRemove([cureentUser.email])
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(top: 20, left: 25, right: 25),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          // message and user email
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //user and post
              Text(
                widget.user,
                style: const TextStyle(color: Colors.black45),
              ),
              const SizedBox(height: 8),
              Text(widget.message),
            ],
          ),
          const SizedBox(width: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //like
              Column(
                children: [
                  //like button
                  LikeButton(
                    isliked: isliked,
                    onTap: toggleLike,
                  ),
                  const SizedBox(height: 1),
                  //like counter
                  Text(
                    widget.likes.length.toString(),
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              //comment
              Column(
                children: [
                  //comment button,
                  CommentButton(onTap: () {}),
                  const SizedBox(height: 1),
                  //comment counter
                  Text(
                    '0',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
