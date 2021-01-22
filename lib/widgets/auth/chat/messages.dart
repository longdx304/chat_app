import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chat').snapshots(),
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
          itemCount: chatDocs.length,
          itemBuilder: (context, index) => Container(
            padding: EdgeInsets.all(8),
            child: Text(chatDocs[index].data()['text']),
          ),
        );
      },
    );
  }
}
