import 'package:flutterproject/pages/dash_board_page.dart';
import 'package:flutterproject/pages/profile_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutterproject/pages/login_page.dart';
import 'package:flutterproject/pages/profile_creation_page.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpRequest {

  // set up http client to able to send requests to endpoints
  static final httpClient = http.Client();


  static handleSignUp(username, password, email, context) async {
    var signUpEndPoint = Uri.parse('http://127.0.0.1:5000/signup');
    //Change Local Host uri when running on an android device
    if (defaultTargetPlatform == TargetPlatform.android){
      signUpEndPoint = Uri.parse('http://10.0.2.2:5000/signup');
    }

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
      var json = jsonDecode(response.body);

      if (json[0] == 'Register success. Login now') {
        await EasyLoading.showSuccess(json[0]);

        await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      } else {
        EasyLoading.showError(json[0]);

      }

    }

  }

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

  static Future<void> saveCustomerIdToCookie(int customerId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('customer_id', customerId);
      print('Cookie created. Customer ID: $customerId');
    } catch (e) {
      print('Failed to create cookie: $e');
    }
  }

  static handleLogin(username, password, context) async {
    var loginEndPoint = Uri.parse('http://127.0.0.1:5000/login');
    if (defaultTargetPlatform == TargetPlatform.android){
      loginEndPoint = Uri.parse('http://10.0.2.2:5000/login');
    }

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
      var json = jsonDecode(response.body);

      if (json[0] == 'success') {
        await EasyLoading.showSuccess(json[0]);
        Map<String, dynamic> dataID = await HttpRequest.handleCustomerIdGet(username);
        int customerId = dataID['id'];
        // Replace this with the actual customer ID received from the response
        await saveCustomerIdToCookie(customerId);
        handleProfileCheck(customerId, context);
      } else {
        EasyLoading.showError(json[0]);
      }
    }
  }

  static handleCustomerIdGet(username) async {
    var profileIdCheckEndPoint = Uri.parse('http://127.0.0.1:5000/customerid/$username');
    if (defaultTargetPlatform == TargetPlatform.android){
      profileIdCheckEndPoint = Uri.parse('http://10.0.2.2:5000/customerid/$username');
    }
    http.Response response = await httpClient.get(profileIdCheckEndPoint);

    if (response.statusCode != 200) {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    } else {
      // response received by endpoint
      final decodedResponse = json.decode(response.body);
      Map<String, dynamic> map = json.decode(response.body);
      return (map);

    }
  }

//  userName,
  static handleProfileCheck(id, context) async {
    var profileCheckEndPoint = Uri.parse('http://127.0.0.1:5000/profileInfo/$id');
    if (defaultTargetPlatform == TargetPlatform.android){
      profileCheckEndPoint = Uri.parse('http://10.0.2.2:5000/profileInfo/$id');
    }

    // send post request
    http.Response response = await httpClient.get(profileCheckEndPoint);
    // error occurs
    if (response.statusCode != 200) {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    } else {
      // response received by endpoint
      var json = jsonDecode(response.body);
      if (json != null && json.isNotEmpty) {
        await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DashboardPage()));
      } else {
        await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileCreation()));
      }


    }

  }

  static handleQuotePost(userId, gallons, address, date, suggested, total, context) async {
    var quoteEndPoint = Uri.parse('http://127.0.0.1:5000/quote/$userId');
    //Change Local Host uri when running on an android device
    if (defaultTargetPlatform == TargetPlatform.android){
      quoteEndPoint = Uri.parse('http://10.0.2.2:5000/quote/$userId');
    }

    // send post request
    http.Response response = await httpClient.post(quoteEndPoint, body: {
      "gallons": gallons,
      "address" : address,
      "date" : date,
      "suggested" : suggested,
      "total" : total,
    });

    // error occurs
    if (response.statusCode != 200) {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    } else {
      // response received by endpoint
      var json = jsonDecode(response.body);

      if (json[0] == 'Fuel Quote created') {
        await EasyLoading.showSuccess(json[0]);

        await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DashboardPage()));
      } else {
        EasyLoading.showError(json[0]);

      }

    }

  }

  static handleQuoteGet(id) async {
    var quoteEndPoint = Uri.parse('http://127.0.0.1:5000/quote/$id');
    //Change Local Host uri when running on an android device
    if (defaultTargetPlatform == TargetPlatform.android){
      quoteEndPoint = Uri.parse('http://10.0.2.2:5000/quote/$id');
    }

    // send post request
    http.Response response = await httpClient.get(quoteEndPoint);

    // error occurs
    if (response.statusCode != 200) {
      await EasyLoading.showError(
          "Error Code : ${response.statusCode.toString()}");
    } else {
      // response received by endpoint
      final decodedResponse = json.decode(response.body);
      final List<Map<String, dynamic>> map = List.from(decodedResponse);
      return (map);

    }

  }

  static handleFuelQuoteGet(id) async {
    var fuelQuoteEndPoint = Uri.parse('http://127.0.0.1:5000/fuelquote/$id');
    //Change Local Host uri when running on an android device
    if (defaultTargetPlatform == TargetPlatform.android) {
      fuelQuoteEndPoint = Uri.parse('http://10.0.2.2:5000/fuelquote/$id');
    }

    // send post request
    http.Response response = await httpClient.get(fuelQuoteEndPoint);

    // error occurs
    if (response.statusCode != 200) {
      await EasyLoading.showError(
          "Error Code : Data Could Not Be Pulled");
    } else {
      // response received by endpoint
      Map<String, dynamic> map = json.decode(response.body);
      return (map);
    }
  }

  static handleDashGet(id) async {
    var dashboardEndPoint = Uri.parse('http://127.0.0.1:5000/dashboard/$id');
    //Change Local Host uri when running on an android device
    if (defaultTargetPlatform == TargetPlatform.android) {
      dashboardEndPoint = Uri.parse('http://10.0.2.2:5000/dashboard/$id');
    }

    // send post request
    http.Response response = await httpClient.get(dashboardEndPoint);

    // error occurs
    if (response.statusCode != 200) {
      await EasyLoading.showError(
          "Error Code : Data Could Not Be Pulled");
    } else {
      // response received by endpoint
      final decodedResponse = json.decode(response.body);
      final List<Map<String, dynamic>> map = List.from(decodedResponse);
      return (map);
    }
  }

  static handleQuoteCreate(id, gallons, address, date, context) async {
    var quoteCreateEndPoint = Uri.parse('http://127.0.0.1:5000/quoteCreate/$id');
    //Change Local Host uri when running on an android device
    if (defaultTargetPlatform == TargetPlatform.android) {
      quoteCreateEndPoint = Uri.parse('http://10.0.2.2:5000/quoteCreate/$id');
    }

    // send post request
    http.Response response = await httpClient.post(quoteCreateEndPoint, body: {
      "gallons": gallons,
      "address" : address,
      "date" : date,
    });

    // error occurs
    if (response.statusCode != 200) {
      await EasyLoading.showError(
          "Error Code : Data Could Not Be Pulled");
    } else {
      // response received by endpoint
      Map<String, dynamic> map = json.decode(response.body);
      return (map);
    }
  }

  static handleCustomerGet(id) async {
    var dashboardEndPoint = Uri.parse('http://127.0.0.1:5000/customer/$id');
    //Change Local Host uri when running on an android device
    if (defaultTargetPlatform == TargetPlatform.android) {
      dashboardEndPoint = Uri.parse('http://10.0.2.2:5000/customer/$id');
    }

    // send post request
    http.Response response = await httpClient.get(dashboardEndPoint);

    // error occurs
    if (response.statusCode != 200) {
      await EasyLoading.showError(
          "Error Code : Data Could Not Be Pulled");
    } else {
      // response received by endpoint
      Map<String, dynamic> map = json.decode(response.body);
      return (map);
    }
  }

  static handleProfileCreation(userId, fullname, address1, address2, city, stateCode, zipcode, context) async {
    var profileEndPoint = Uri.parse('http://127.0.0.1:5000/profileCreation/$userId');
    if (defaultTargetPlatform == TargetPlatform.android) {
      profileEndPoint = Uri.parse('http://10.0.2.2:5000/profileCreation/$userId');
    }
    http.Response response = await httpClient.post(profileEndPoint, body: {
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

      if (json[0] == 'Profile created') {
        await EasyLoading.showSuccess(json[0]);
        await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const DashboardPage()));
      } else {
        EasyLoading.showError(json[0]);
      }
    }
  }

  static handleQuoteAddress(id) async {
    var quoteAddressEndPoint = Uri.parse('http://127.0.0.1:5000/profileInfo/$id');
    //Change Local Host uri when running on an android device
    if (defaultTargetPlatform == TargetPlatform.android) {
      quoteAddressEndPoint = Uri.parse('http://10.0.2.2:5000/profileInfo/$id');
    }

    // send post request
    http.Response response = await httpClient.get(quoteAddressEndPoint);

    // error occurs
    if (response.statusCode != 200) {
      await EasyLoading.showError(
          "Error Code : Data Could Not Be Pulled");
    } else {
      // response received by endpoint
      Map<String, dynamic> map = json.decode(response.body);
      return (map);
    }
  }

  static handleProfileInfo(id) async {
    var profileEndPoint = Uri.parse('http://127.0.0.1:5000/profileInfo/$id');

    if (defaultTargetPlatform == TargetPlatform.android) {
      profileEndPoint = Uri.parse('http://10.0.2.2:5000/profileInfo/$id');
    }
    http.Response response = await httpClient.get(profileEndPoint);

    // error occurs
    if (response.statusCode != 200) {
      await EasyLoading.showError("Error: Profile Info Could not be pulled");
    } else {
      // response received by endpoint
      Map<String, dynamic> map = json.decode(response.body);
      return (map);
    }
  }

  static handleEditProfile(id, fullname, address1, address2, city, stateCode, zipcode, context) async {

    var editProfileEndPoint = Uri.parse('http://127.0.0.1:5000/editProfile/$id');

    if (defaultTargetPlatform == TargetPlatform.android) {
      editProfileEndPoint = Uri.parse('http://10.0.2.2:5000/editProfile/$id');
    }
    http.Response response = await httpClient.post(editProfileEndPoint, body: {
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
      }
    }
  }

}