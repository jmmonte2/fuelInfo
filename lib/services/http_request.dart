

import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:untitled/pages/login_page.dart';
import 'package:untitled/pages/profile_creation_page.dart';


class HttpRequest {
  // set up http client to able to send requests to endpoints
  static final httpClient = http.Client();
  static var loginEndPoint = Uri.parse('http://127.0.0.1:5000/login');
  static var signUpEndPoint = Uri.parse('http://127.0.0.1:5000/signup');

  static handleSignUp(username, password, email, context) async {
    // send post request
    http.Response response = await httpClient.post(signUpEndPoint, body: {
    "username": username,
    "password": password,
      "email" : email,
    });

    // error occurs
    if (response.statusCode != 200) {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    } else {
        // response received by endpoint
        print(jsonDecode(response.body));
        var json = jsonDecode(response.body);

        if (json[0] == 'Register success. Login now') {
          await EasyLoading.showSuccess(json[0]);

          await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()));
        } else {
          EasyLoading.showError(json[0]);

        }

    }

  }


  static handleLogin(username, password, context) async {
    // send post request
    http.Response response = await httpClient.post(loginEndPoint, body: {
      "username": username,
      "password": password,
    });
    print(response);

    // error occurs
    if (response.statusCode != 200) {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    } else {
      // response received by endpoint
      print(jsonDecode(response.body));
      var json = jsonDecode(response.body);

      if (json[0] == 'success') {
        await EasyLoading.showSuccess(json[0]);
        await Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfileCreation()));
      } else {
        EasyLoading.showError(json[0]);
      }


    }

  }
//  userName,


}