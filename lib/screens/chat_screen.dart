import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference messages = FirebaseFirestore.instance
        .collection('chats/L6G6DeTGPzMla48dc3w0/messages');

    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => Container(
          padding: EdgeInsets.all(8),
          child: Text('This works!'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          messages.snapshots().listen((snapshop) {
            snapshop.docs.forEach((doc) {
              print(doc['text']);
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
