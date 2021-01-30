import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'screens/chat_screen.dart';
import 'screens/auth_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = false;
      });
    }
  }

  void requestNotificationPers() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    messaging.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
  }

  Widget _buildHomeScreen() {
    if (_error) {
      return Center(
        child: Text('An error occured...'),
      );
    }
    if (!_initialized) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    requestNotificationPers();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a foreground message with data: ${message.data}');
      if (message.notification != null) {
        print('Message also contain a noti: ${message.notification}');
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Opened message with data: ${message.data}');
      if (message.notification != null) {
        print('Message also contain a noti: ${message.notification}');
      }
    });
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, user) {
        if (user.hasData) return ChatScreen();
        return AuthScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        backgroundColor: Colors.pink,
        accentColor: Colors.deepPurple,
        accentColorBrightness: Brightness.dark,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _buildHomeScreen(),
    );
  }
}
