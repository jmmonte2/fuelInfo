import 'dart:js';
import 'package:flutter/services.dart';
import 'package:flutterproject/pages/dash_board_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutterproject/pages/login_page.dart';
import 'package:flutterproject/pages/profile_creation_page.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpRequest {
  static final httpClient = http.Client();
  static var loginEndPoint = Uri.parse('http://127.0.0.1:5000/login');
  static var signUpEndPoint = Uri.parse('http://127.0.0.1:5000/signup');

  static var profileEndPoint = Uri.parse(
      'http://127.0.0.1:5000/profileCreation');

  static handleSignUp(username, password, email, context) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      signUpEndPoint = Uri.parse('http://10.0.2.2:5000/signup');
    }

    http.Response response = await httpClient.post(signUpEndPoint, body: {
      "username": username,
      "password": password,
      "email": email,
    });

    if (response.statusCode != 200) {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    } else {
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

        // Save the customer ID as a cookie
        int customerId = 1; // Replace this with the actual customer ID received from the response
        await saveCustomerIdToCookie(customerId);

        handleProfileCheck(1, context);
      } else {
        EasyLoading.showError(json[0]);
      }
    }
  }


  static handleProfileCheck(id, context) async {
    var profileCheckEndPoint = Uri.parse(
        'http://127.0.0.1:5000/profileInfo/$id');
    http.Response response = await httpClient.get(profileCheckEndPoint);

    if (response.statusCode != 200) {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    } else {
      var json = jsonDecode(response.body);
      if (json != null) {
        await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()));
      } else {
        await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileCreation()));
      }
    }
  }

  static handleQuotePost(userId, gallons, address, date, suggested, total,
      context) async {
    var quoteEndPoint = Uri.parse('http://127.0.0.1:5000/quote/$userId');
    if (defaultTargetPlatform == TargetPlatform.android) {
      quoteEndPoint = Uri.parse('http://10.0.2.2:5000/quote/$userId');
    }

    http.Response response = await httpClient.post(quoteEndPoint, body: {
      "gallons": gallons,
      "address": address,
      "date": date,
      "suggested": suggested,
      "total": total,
    });

    if (response.statusCode != 200) {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    } else {
      var json = jsonDecode(response.body);

      if (json[0] == 'Fuel Quote created') {
        await EasyLoading.showSuccess(json[0]);
        await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Dashboard()));
      } else {
        EasyLoading.showError(json[0]);
        print(json[0]);
      }
    }
  }

  static handleQuoteGet(id) async {
    var quoteEndPoint = Uri.parse('http://127.0.0.1:5000/quote/$id');
    if (defaultTargetPlatform == TargetPlatform.android) {
      quoteEndPoint = Uri.parse('http://10.0.2.2:5000/quote/$id');
    }

    http.Response response = await httpClient.get(quoteEndPoint);

    if (response.statusCode != 200) {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    } else {
      final decodedResponse = json.decode(response.body);
      final List<Map<String, dynamic>> map = List.from(decodedResponse);
      return (map);
    }
  }

  static handleFuelQuoteGet(id) async {
    var fuelQuoteEndPoint = Uri.parse('http://127.0.0.1:5000/fuelquote/$id');
    if (defaultTargetPlatform == TargetPlatform.android) {
      fuelQuoteEndPoint = Uri.parse('http://10.0.2.2:5000/fuelquote/$id');
    }

    http.Response response = await httpClient.get(fuelQuoteEndPoint);

    if (response.statusCode != 200) {
      await EasyLoading.showError("Error Code : Data Could Not Be Pulled");
    } else {
      Map<String, dynamic> map = json.decode(response.body);
      return (map);
    }
  }

  static handleDashGet(id) async {
    var dashboardEndPoint = Uri.parse('http://127.0.0.1:5000/dashboard/$id');
    if (defaultTargetPlatform == TargetPlatform.android) {
      dashboardEndPoint = Uri.parse('http://10.0.2.2:5000/dashboard/$id');
    }

    http.Response response = await httpClient.get(dashboardEndPoint);

    if (response.statusCode != 200) {
      await EasyLoading.showError("Error Code : Data Could Not Be Pulled");
    } else {
      final decodedResponse = json.decode(response.body);
      final List<Map<String, dynamic>> map = List.from(decodedResponse);
      return (map);
    }
  }

  static handleCustomerGet(id) async {
    var dashboardEndPoint = Uri.parse('http://127.0.0.1:5000/customer/$id');
    if (defaultTargetPlatform == TargetPlatform.android) {
      dashboardEndPoint = Uri.parse('http://10.0.2.2:5000/customer/$id');
    }

    http.Response response = await httpClient.get(dashboardEndPoint);

    if (response.statusCode != 200) {
      await EasyLoading.showError("Error Code : Data Could Not Be Pulled");
    } else {
      Map<String, dynamic> map = json.decode(response.body);
      return (map);
    }
  }

  static handleProfileCreation(userId, fullname, address1, address2, city,
      stateCode, zipcode, context) async {

    var profileEndPoint =
        Uri.parse('http://127.0.0.1:5000/profileCreation/$userId');

    if (defaultTargetPlatform == TargetPlatform.android) {
      quoteEndPoint = Uri.parse('http://10.0.2.2:5000/profileCreation/$userId');
    }
    http.Response response = await httpClient.post(profileEndPoint, body: {
      "user_id": userId,
      "fullname": fullname,
      "address1": address1,
      "address2": address2,
      "city": city,
      "stateCode": stateCode,
      "zipcode": zipcode,
    });

    if (response.statusCode != 200) {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    } else {
      var json = jsonDecode(response.body);

      if (json[0] == 'Profile created') {
        await EasyLoading.showSuccess(json[0]);
        await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Dashboard()));
      } else {
        EasyLoading.showError(json[0]);
        print(json[0]);
      }
    }
  }

  // Function to save customer ID as a cookie using shared_preferences
  static Future<void> saveCustomerIdToCookie(int customerId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('customer_id', customerId);
      print('Cookie created. Customer ID: $customerId');
    } catch (e) {
      print('Failed to create cookie: $e');
    }
  }

  static handleEditProfile(userId, fullname, address1, address2, city,
      stateCode, zipcode, context) async {
    var editProfileEndPoint =
        Uri.parse('http://127.0.0.1:5000/editProfile/$userId');

    if (defaultTargetPlatform == TargetPlatform.android) {
      quoteEndPoint = Uri.parse('http://10.0.2.2:5000/editProfile/$userId');
    }
    http.Response response = await httpClient.post(editProfileEndPoint, body: {
      "user_id": userId,
      "fullname": fullname,
      "address1": address1,
      "address2": address2,
      "city": city,
      "stateCode": stateCode,
      "zipcode": zipcode,
    });
    if (response.statusCode != 200) {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    } else {
      // response received by endpoint
      var json = jsonDecode(response.body);

      if (json[0] == 'Profile edited') {
        await EasyLoading.showSuccess(json[0]);
        await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProfilePage()));
      } else {
        EasyLoading.showError(json[0]);
        print(json[0]);
      }

  // Function to get customer ID from the cookie using shared_preferences
  static Future<int?> getCustomerIdFromCookie() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? customerId = prefs.getInt('customer_id');
      return customerId;
    } catch (e) {
      print('Failed to get customer ID from cookie: $e');
      return null;
    }
  }
}

