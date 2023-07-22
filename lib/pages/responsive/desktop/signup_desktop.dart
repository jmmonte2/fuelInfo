import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutterproject/pages/login_page.dart';
import 'package:flutterproject/services/http_request.dart';

class RegisterPageDesktop extends StatefulWidget {
  const RegisterPageDesktop({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPageDesktop> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: Center(
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.8,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 255, 255, 1),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Sign up!',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Username',
                                  labelStyle: TextStyle(color: Colors.black),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a username';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    username = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 16.0),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(color: Colors.black),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter an email address';
                                  }
                                  return null;
                                  // if (emailIsAlreadyInUse) {
                                  //   return 'Email already in use';
                                  // }f
                                  // return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 16.0),
                              TextFormField(
                                decoration: const InputDecoration(
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
                              const SizedBox(height: 32.0),
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    // Form is valid, perform registration functionality here
                                    // Since we don't have a backend, print the user information

                                    await HttpRequest.handleSignUp(username, password, email, context);
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(builder: (context) => ProfileCreation())
                                    // );
                                  }
                                },
                                style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all<Size>(const Size(300, 40)),
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                ),
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Click here if already have an account',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => const LoginPage()),
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}