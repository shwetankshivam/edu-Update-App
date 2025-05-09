import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:update/helper/helper_method.dart';
import 'package:update/utils/FeedPost.dart';
import 'package:update/utils/TextField.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

// current user
final currentUser = FirebaseAuth.instance.currentUser!;
// text controller
final textController = TextEditingController();

class _HomepageState extends State<Homepage> {
  // ScrollController to manage scroll behavior
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  bool isDeleting = false;

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _scrollController.dispose();
    super.dispose();
  }

  // Log out user
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  postMessage() async {
    String trimmedText = textController.text.trim();

    if (trimmedText.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      try {
        await FirebaseFirestore.instance.collection("User Posts").add({
          'UserEmail': currentUser.email,
          'Message': trimmedText,
          'TimeStamp': Timestamp.now(),
          'Likes': [],
        });

        Fluttertoast.showToast(
          msg: "Post submitted!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } catch (e) {
        print("Error posting message: $e");
      } finally {
        setState(() {
          isLoading = false;
        });

        textController.clear();

        Future.delayed(Duration(milliseconds: 300), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    } else {
      Fluttertoast.showToast(
        msg: "Message cannot be empty.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  // Delete post
  deletePost(String postId) async {
    setState(() {
      isDeleting = true;
    });

    try {
      // Delete the post from Firestore
      await FirebaseFirestore.instance
          .collection("User Posts")
          .doc(postId)
          .delete();
      setState(() {
        isDeleting = false;
      });
    } catch (e) {
      print("Error deleting post: $e");
      setState(() {
        isDeleting = false;
      });
    }
  }

  // Confirm delete post
  confirmDelete(String postId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure?"),
          content: const Text(
              "Do you want to delete this post? This action cannot be undone."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deletePost(postId);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'UNINET',
          style: TextStyle(
            color: Colors.black,
            decoration: TextDecoration.underline,
            decorationThickness: .5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: signOut,
            child: const Text(
              "sign out",
              style: TextStyle(
                  fontSize: 17, color: Colors.red, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            // UPDATE App posts from server
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .orderBy("TimeStamp", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      controller: _scrollController, // Set controller here
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];

                        // Get the message
                        return FeedPost(
                          message: post["Message"],
                          user: post["UserEmail"],
                          postId: post.id,
                          likes: List<String>.from(post['Likes'] ?? []),
                          time: formatDate(post["TimeStamp"]),
                          onDelete: currentUser.email == post["UserEmail"]
                              ? () => confirmDelete(post.id)
                              : null,
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                          'Something went wrong. Please try again later.',
                          style: TextStyle(color: Colors.red)),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                },
              ),
            ),

            // Creating posts
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: textController,
                      hintText: "write a post..",
                      obsecureText: false,
                    ),
                  ),
                  const SizedBox(width: 5),
                  isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : IconButton(
                          onPressed: postMessage,
                          icon: const Icon(
                            CupertinoIcons.chevron_right_2,
                            size: 33,
                            color: Colors.black,
                          ),
                        ),
                ],
              ),
            ),
            // User logged in as
            SafeArea(
              child: Text(
                "Logged in as ${currentUser.email!}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            // Show progress indicator if deleting
            if (isDeleting)
              const Center(child: CircularProgressIndicator.adaptive()),
          ],
        ),
      ),
    );
  }
}
