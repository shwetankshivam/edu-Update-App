import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Add this import
import 'package:update/helper/helper_method.dart';
import 'package:update/utils/Delete_Button.dart';
import 'package:update/utils/Like_Button.dart';
import 'package:update/utils/comment.dart';
import 'package:update/utils/comment_button.dart';

class FeedPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final String time;
  final List<String> likes;
  final VoidCallback? onDelete; // Add onDelete callback

  const FeedPost({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
    required this.time,
    this.onDelete, // Initialize onDelete callback
  });

  @override
  State<FeedPost> createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isliked = false;
  final commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isliked = widget.likes.contains(currentUser.email);
  }

  void showToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
    );
  }

  void toggleLike() {
    setState(() {
      isliked = !isliked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isliked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  void addComment(String commentText) {
    String trimmedComment = commentText.trim();

    if (trimmedComment.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('User Posts')
          .doc(widget.postId)
          .collection("Comments")
          .add({
        "CommentText": trimmedComment,
        "CommentedBy": currentUser.email,
        "CommentTime": Timestamp.now()
      }).then((_) {
        showToastMessage("Posted...");
        commentTextController.clear();
        Navigator.pop(context); // Close dialog
      }).catchError((error) {
        print("Error posting comment: $error");
      });
    } else {
      showToastMessage("Comment cannot be empty.");
    }
  }

  void showCommentBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          "Share your thoughts..",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        content: TextField(
          controller: commentTextController,
          decoration: const InputDecoration(hintText: "Reply to this update.."),
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              commentTextController.clear();
            },
            child: const Text(
              "Cancel",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w300),
            ),
          ),
          TextButton(
            onPressed: () {
              addComment(commentTextController.text);
            },
            child: const Text(
              "Done",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void deletePost() {
    // Show a confirmation dialog box
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Update"),
        content: const Text("Are you sure you want to delete this Update?"),
        actions: [
          // Cancel button
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),

          // Delete button
          TextButton(
              onPressed: () async {
                // Delete the comments first
                final commentDocs = await FirebaseFirestore.instance
                    .collection("User Posts")
                    .doc(widget.postId)
                    .collection("Comments")
                    .get();

                for (var doc in commentDocs.docs) {
                  await FirebaseFirestore.instance
                      .collection("User Posts")
                      .doc(widget.postId)
                      .collection("Comments")
                      .doc(doc.id)
                      .delete();
                }

                // Delete the post
                FirebaseFirestore.instance
                    .collection("User Posts")
                    .doc(widget.postId)
                    .delete()
                    .then((value) {
                  // Show toast message after post is deleted
                  showToastMessage("Deleted...");
                  print("Update deleted");
                }).catchError(
                        (error) => print("Failed to delete update: $error"));

                // Dismiss the dialog box
                Navigator.pop(context);
              },
              child: const Text("Delete")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade900,
          width: 0.3,
        ),
      ),
      margin: const EdgeInsets.only(top: 20, left: 25, right: 25),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user,
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.time,
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.normal),
                  ),
                  const Spacer(),
                  if (widget.user == currentUser.email)
                    DeleteButton(
                        onTap: widget.onDelete ??
                            deletePost), // Pass the onDelete callback
                ],
              ),
              const SizedBox(height: 3),
              Text(widget.message),
            ],
          ),
          const SizedBox(width: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  LikeButton(
                    isliked: isliked,
                    onTap: toggleLike,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    widget.likes.length.toString(),
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  CommentButton(onTap: showCommentBox),
                  const SizedBox(height: 1),
                  Text(
                    'Reply',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .doc(widget.postId)
                    .collection("Comments")
                    .orderBy("CommentTime", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  }
                  return ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: snapshot.data!.docs.map((doc) {
                      final commentData = doc.data() as Map<String, dynamic>;
                      return Comment(
                        text: commentData["CommentText"],
                        time: commentData["CommentedBy"],
                        user: formatDate(commentData["CommentTime"]),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
