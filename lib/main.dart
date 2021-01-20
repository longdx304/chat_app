import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/chat_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  Widget _buildHomeScreen(AsyncSnapshot snapshot) {
    if (snapshot.hasError) {
      return Center(
        child: Text('An error occured...'),
      );
    }
    if (snapshot.connectionState == ConnectionState.done) {
      return ChatScreen();
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'FlutterChat',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: _buildHomeScreen(snapshot),
        );
      },
    );
  }
}
