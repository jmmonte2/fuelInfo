import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dash_board_page.dart';
import 'signup_page.dart';
import '/services/http_request.dart';

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
      backgroundColor: const Color(0xFFEEEEEE),
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
                            // if (value != 'tester') {
                            //   setState(() {
                            //     usernameIsValid = false;
                            //   });
                            //   return 'Username does not exist';
                            // }
                            // return null;
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
                            // if (username == 'tester' && value != 'test1234') {
                            //   setState(() {
                            //     passwordIsValid = false;
                            //   });
                            //   return 'Incorrect password';
                            // }
                            // return null;
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
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              print(username);
                              print(password);
                              // makes call
                              await HttpRequest.handleLogin(username, password, context);
                              // if (username == 'tester' && password == 'test1234') {
                              //   print('Login successful');
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(builder: (context) => const Dashboard()),
                              //   );
                              // } else {
                              //   print('Invalid credentials');
                              // }
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
            )
          )
        )
      )
    )
    );
  }
}