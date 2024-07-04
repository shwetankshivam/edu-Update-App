import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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

  // final String time;
  const FeedPost(
      {super.key,
      required this.message,
      required this.user,
      required this.postId,
      required this.likes,
      required this.time

      // required this.time,
      });

  @override
  State<FeedPost> createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isliked = false;
  //comment text controller
  final commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isliked = widget.likes.contains(currentUser.email);
  }

  //toggle likes
  void toggleLike() {
    setState(() {
      isliked = !isliked;
    });

    //access document in firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isliked) {
      //if post is liked, add user's email to the likes field
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      //if post is unliked, remove user's email to the likes field
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

//add a comment
  void addComment(String commentText) {
    //write a comment in comment collection in firestore
    FirebaseFirestore.instance
        .collection('User Posts')
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentTime": Timestamp.now()
    });
  }

  //dialog to add a comment

  void showCommentBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          "Update",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        content: TextField(
          controller: commentTextController,
          decoration: const InputDecoration(
            hintText: "reply to this update..",
          ),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        actions: [
          //cancel
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              commentTextController.clear();
            },
            child: const Text(
              "Cancel",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          //save
          TextButton(
            onPressed: () {
              addComment(commentTextController.text);
              //pop comment box
              Navigator.pop(context);

              //clear comment line
              commentTextController.clear();
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

//delete post method

  void deletePost() {
    //show a confirmation dialog box
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Delete Update"),
              content:
                  const Text("Are you sure you want to delete this Update?"),
              actions: [
                //cancel button
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel")),

                //Delete button
                TextButton(
                    onPressed: () async {
                      //delete the comments first
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

                      //delete the post
                      FirebaseFirestore.instance
                          .collection("User Posts")
                          .doc(widget.postId)
                          .delete()
                          .then((value) => print("Update deleted"))
                          .catchError((error) =>
                              print("failed to delete Update: $error"));

                      //dismiss the dialog box
                      Navigator.pop(context);
                    },
                    child: const Text("Delete")),
              ],
            ));
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
                    DeleteButton(onTap: deletePost),
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
              const SizedBox(width: 12),
              //comment
              Column(
                children: [
                  //comment button,
                  CommentButton(onTap: showCommentBox),
                  const SizedBox(height: 1),
                  //comment counter
                  Text(
                    'reply',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),

          //comments under post
          Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("User Posts")
                      .doc(widget.postId)
                      .collection("Comments")
                      .orderBy("CommentTime", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    //show the loading circle if data empty
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    return ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: snapshot.data!.docs.map((doc) {
                        //get the comments from firebase
                        final commentData = doc.data() as Map<String, dynamic>;

                        //return to the listview
                        return Comment(
                          text: commentData["CommentText"],
                          time: commentData["CommentedBy"],
                          user: formatDate(commentData["CommentTime"]),
                        );
                      }).toList(),
                    );
                  }),
            ],
          )
        ],
      ),
    );
  }
}
