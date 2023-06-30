import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'login_page.dart';

import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String email = '';
  String password = '';

  bool usernameIsAlreadyInUse = false;
  bool emailIsAlreadyInUse = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(116, 116, 116, 0.1),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Flexible(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height - 80.0,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sign up!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a username';
                            }
                            if (usernameIsAlreadyInUse) {
                              return 'Username already in use';
                            }
                            return null;
                          },
                          style: TextStyle(
                            color: usernameIsAlreadyInUse ? Colors.red : Colors.black,
                          ),
                          onChanged: (value) {
                            setState(() {
                              username = value;
                              usernameIsAlreadyInUse = checkUsernameAvailability(username);
                            });
                          },
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter an email address';
                            }
                            if (emailIsAlreadyInUse) {
                              return 'Email already in use';
                            }
                            return null;
                          },
                          style: TextStyle(
                            color: emailIsAlreadyInUse ? Colors.red : Colors.black,
                          ),
                          onChanged: (value) {
                            setState(() {
                              email = value;
                              emailIsAlreadyInUse = checkEmailAvailability(email);
                            });
                          },
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                        ),
                        SizedBox(height: 32.0),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Form is valid, perform registration functionality here
                              // Since we don't have a backend, print the user information
                              print('Username: $username');
                              print('Email: $email');
                              print('Password: $password');
                            }
                          },
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all<Size>(Size(300, 40)),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Click here if already have an account',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => LoginPage()),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool checkUsernameAvailability(String username) {
    // check if username is already in use
    return username == 'fabian';
  }

  bool checkEmailAvailability(String email) {
    // check if email is already in use
    return email == 'fabian.silva@live.com';
  }
}
