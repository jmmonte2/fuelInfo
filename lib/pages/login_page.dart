import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';
  bool usernameIsValid = true;
  bool passwordIsValid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(116, 116, 116, 0.1),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            height: 400,
            width: 300,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Form(
              key: _formKey, // Assign the form key to the Form widget
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome!',
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
                      if (value != 'fabian') {
                        setState(() {
                          usernameIsValid = false;
                        });
                        return 'Username does not exist';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        username = value;
                        usernameIsValid = true;
                      });
                    },
                    style: TextStyle(
                      color: usernameIsValid ? Colors.black : Colors.red,
                    ),
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
                      if (username == 'fabian' && value != 'password') {
                        setState(() {
                          passwordIsValid = false;
                        });
                        return 'Incorrect password';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        password = value;
                        passwordIsValid = true;
                      });
                    },
                    style: TextStyle(
                      color: passwordIsValid ? Colors.black : Colors.red,
                    ),
                  ),
                  SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (username == 'fabian' && password == 'password') {
                          print('Login successful');
                        } else {
                          print('Invalid credentials');
                        }
                      }
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(Size(300, 40)),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Set the desired background color
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Click here to create an account.',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => RegisterPage()),
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
    );
  }
}
