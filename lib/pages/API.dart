import 'package:flutter/material.dart';
import 'login_page.dart';
import 'APIRequestTest.dart';
import 'dart:convert';

class APITest extends StatefulWidget {
  const APITest({super.key});

  @override
  APIForm createState() {
    return APIForm  ();
  }
}

class APIForm extends State<APITest> {
  String? query;
  // Variable to set url request
  var url;
  // Variable to retrieve json data from API
  var data;
  // Test Variable
  String? apiTest = 'Api Test';

  late final apiInput = TextEditingController();

  @override
  void initState() {
    // Real Time Variables for updating fields after input
    apiInput.text = "";
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("API Test", style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        )),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage())
                );
              },
              tooltip: 'Go Back',
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(key: _formKey,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),
                  buildGallons(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text("Submit",
                      style: TextStyle(color: Colors.blue, fontSize: 16,),),
                    onPressed: () async{
                      //Save Input and Sent to backend
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        // Cal function from APIRequestTest Class
                        data = await Getdata(url);
                        // Create a map to take apart json data
                        Map<String, dynamic> map = jsonDecode(data);
                        // Convert Raw Json to String values (Can be any value needed, not exclusive to strings)
                        String decodedData = map['Query'];
                        // Debug Testing, will change the input on the form to the input + API CALL, this will let you know it works
                        apiInput.text = decodedData;
                        print(decodedData);
                        return;
                      }
                    }
                    ,)
                ],
              ),
            )
        ),
      ),
    );
  }

  Widget buildGallons() {
    return TextFormField(
      controller: apiInput,
      decoration: const InputDecoration(
        labelText: "Query",
        contentPadding: EdgeInsets.all(20.0),
        isDense: true,
        border: OutlineInputBorder(),
      ),
      maxLines: 1,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Type Something Here';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          //Url will not match the localhost url given in flask, you NEED to change the ip to that seen below if you are using an android emulator
          // If you are using a web version use the default url given by flask
          url = Uri.parse('http://10.0.2.2:5000/test?Query=$value');
        });
      },
      // Set Variable for backend
      onSaved: (value) => setState(() => query = value),
    );
  }
}