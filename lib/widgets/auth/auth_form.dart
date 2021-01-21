import 'package:flutter/material.dart';

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

  void _submitForm() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return;
    FocusScope.of(context).unfocus();
    _formKey.currentState.save();
    print(_userEmail);
    print(_userPassword);
    print(_userName);
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
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(_isLoginMode ? 'Login' : 'Signup'),
                  ),
                  TextButton(
                    onPressed: () =>
                        setState(() => _isLoginMode = !_isLoginMode),
                    child: Text(_isLoginMode
                        ? 'Create new account'
                        : 'I already have an account'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
