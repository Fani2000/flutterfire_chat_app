import 'package:chat/widgets/chat/constants.dart';
import 'package:chat/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(collectionID)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        var docs = snapshot.data!.docs;

        return ListView.builder(
          reverse: true,
          itemCount: docs.length,
          itemBuilder: (ctx, i) => MessageBubble(
            message: docs[i]['text'],
            isMe: FirebaseAuth.instance.currentUser!.uid == docs[i]['userId'],
            key: ValueKey(docs[i].id),
            userId: docs[i]['userId'],
          ),
        );
      },
    );
  }
}
