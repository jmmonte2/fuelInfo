import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'signup_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(116, 116, 116, 0.1),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            height: 300,
            width: 300,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 1),  // Set the desired background color for the container
              borderRadius: BorderRadius.circular(8.0),  // Set the desired border radius
            ),
     
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                // text welcoming user
                Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                
                // username text field
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.black), // Set the desired text color
                  ),
                ),
                SizedBox(height: 16.0),
              
                // password text field
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.black), // Set the desired text color
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 32.0),
                
                // button
                ElevatedButton(
                
                  onPressed: () {
                    // Implement login functionality here
                  },
                  child: Text('Login'),
                  
                  style: ButtonStyle(
    minimumSize: MaterialStateProperty.all<Size>(Size(300, 40)), // Set the desired width and height
  ),
                ),
                
                // text for sign up link
                
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
                                MaterialPageRoute(builder: (context)=> RegisterPage())
                              );
                            }
                        ),
    ],
  ),
)
                )
              ],
              
            ),
          ),
        ),
      ),
    );
  }
}
