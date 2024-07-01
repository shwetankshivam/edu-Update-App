import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:update/utils/FeedPost.dart';
import 'package:update/utils/MyButton.dart';
import 'package:update/utils/TextField.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

//current user
final currentUser = FirebaseAuth.instance.currentUser!;
//test controller
final textController = TextEditingController();
//log out user
void signOut() {
  FirebaseAuth.instance.signOut();
}

//post message

postMessage() {
  //only post if there is a post in text field
  if (textController.text.isNotEmpty) {
    FirebaseFirestore.instance.collection("User Posts").add({
      'UserEmail': currentUser.email,
      'Message': textController.text,
      'TimeStamp': Timestamp.now(),
    });
  }

  //clear the text field
  textController.clear();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade100,
        title: const Text(
          'UPDATE',
          style: TextStyle(color: Colors.black),
        ),
        actions: const [
          TextButton(
            onPressed: signOut,
            child: Text(
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
            //UPDATE App posts from server
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .orderBy(
                      "TimeStamp",
                      descending: false,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];

                        //get the message
                        return FeedPost(
                          message: post["Message"],
                          user: post["UserEmail"],
                          // time: time)
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error} '),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                },
              ),
            ),

            //creating posts
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: textController,
                      hintText: "write an Update",
                      obsecureText: false,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const IconButton(
                    onPressed: postMessage,
                    icon: Icon(
                      CupertinoIcons.chevron_right_2,
                      size: 33,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
            //user logged in as
            SafeArea(
              child: Text(
                "logged in as ${currentUser.email!}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
