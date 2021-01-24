import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  final Stream<QuerySnapshot> chatMessages = FirebaseFirestore.instance
      .collection('chat')
      .orderBy(
        'createdAt',
        descending: true,
      )
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: chatMessages,
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
        if (chatSnapshot.hasError)
          return Center(
            child: Text('An error occurred...'),
          );
        if (chatSnapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        final chatDocs = chatSnapshot.data.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (context, index) => MessageBubble(
            userImageUrl: chatDocs[index].data()['userImage'],
            username: chatDocs[index].data()['username'],
            message: chatDocs[index].data()['text'],
            isMe: FirebaseAuth.instance.currentUser.uid ==
                chatDocs[index].data()['userId'],
            key: ValueKey(chatDocs[index].id),
          ),
        );
      },
    );
  }
}
