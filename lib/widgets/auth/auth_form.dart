import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _userEmail = '';
  var _userPassword = '';
  var _userName = '';
  var _isLoginMode = true;
  var _isLoading = false;
  File _pickedFile;

  void _pickImage(File image) {
    _pickedFile = image;
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return;

    FocusScope.of(context).unfocus();
    _formKey.currentState.save();

    try {
      setState(() => _isLoading = true);
      UserCredential userCredential;
      if (!_isLoginMode) {
        userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _userEmail.trim(),
          password: _userPassword,
        );
        final storageRef = FirebaseStorage.instance
            .ref('user_images/${userCredential.user.uid}.jpg');
        await storageRef.putFile(_pickedFile);
        String imageUrl = await storageRef.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user.uid)
            .set({
          'username': _userName,
          'email': _userEmail,
          'image_url': imageUrl,
        });
      } else {
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _userEmail.trim(), password: _userPassword);
      }
    } on FirebaseAuthException catch (e) {
      var errorMessage = 'An error occurred, please check your credentials!';
      if (e.message != null) {
        errorMessage = e.message;
      }
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() => _isLoading = false);
    } catch (e) {
      print(e);
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLoginMode) UserImagePicker(_pickImage),
                  TextFormField(
                    key: ValueKey('email'),
                    onSaved: (newValue) => _userEmail = newValue,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@'))
                        return 'Please enter a valid email address';
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email address',
                    ),
                  ),
                  if (!_isLoginMode)
                    TextFormField(
                      key: ValueKey('username'),
                      onSaved: (newValue) => _userName = newValue,
                      validator: (value) {
                        if (value.isEmpty || value.length < 4)
                          return 'Please enter at least 4 characters';
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    onSaved: (newValue) => _userPassword = newValue,
                    validator: (value) {
                      if (value.isEmpty || value.length < 7)
                        return 'Password must be at least 7 character long';
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  SizedBox(height: 12),
                  if (_isLoading) CircularProgressIndicator(),
                  if (!_isLoading)
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(_isLoginMode ? 'Login' : 'Signup'),
                    ),
                  if (!_isLoading)
                    TextButton(
                      onPressed: () =>
                          setState(() => _isLoginMode = !_isLoginMode),
                      child: Text(_isLoginMode
                          ? 'Create new account'
                          : 'I already have an account'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
