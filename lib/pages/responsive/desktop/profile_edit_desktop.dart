import 'package:flutterproject/pages/login_page.dart';
import 'package:flutterproject/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/services/http_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileEditDesktop extends StatefulWidget {
  const ProfileEditDesktop({super.key});

  @override
  State<ProfileEditDesktop> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEditDesktop> {
  String? fullname;
  String? address1;
  String address2 = ""; //optional
  String? city;
  String? stateCode;
  String? zipcode;
  late int? customerId;

  final nameInput = TextEditingController();
  final address1Input = TextEditingController();
  final address2Input = TextEditingController();
  final cityInput = TextEditingController();
  // final stateInput = TextEditingController(); // TEST: Not needed for dropdown
  final zipcodeInput = TextEditingController();

  final Map<String, String> _stateCodesList = {
    'Alabama': 'AL',
    'Alaska': 'AK',
    'Arizona': 'AZ',
    'Arkansas': 'AR',
    'California': 'CA',
    'Colorado': 'CO',
    'Connecticut': 'CT',
    'Delaware': 'DE',
    'Washington D.C': 'DC',
    'Florida': 'FL',
    'Georgia': 'GA',
    'Hawaii': 'HI',
    'Idaho': 'ID',
    'Illinois': 'IL',
    'Indiana': 'IN',
    'Iowa': 'IA',
    'Kansas': 'KS',
    'Kentucky': 'KY',
    'Louisiana': 'LA',
    'Maine': 'ME',
    'Maryland': 'MD',
    'Massachusetts': 'MA',
    'Michigan': 'MI',
    'Minnesota': 'MN',
    'Mississippi': 'MS',
    'Missouri': 'MO',
    'Montana': 'MT',
    'Nebraska': 'NE',
    'Nevada': 'NV',
    'New Hampshire': 'NH',
    'New Jersey': 'NJ',
    'New Mexico': 'NM',
    'New York': 'NY',
    'North Carolina': 'NC',
    'North Dakota': 'ND',
    'Ohio': 'OH',
    'Oklahoma': 'OK',
    'Oregon': 'OR',
    'Pennsylvania': 'PA',
    'Rhode Island': 'RI',
    'South Carolina': 'SC',
    'South Dakota': 'SD',
    'Tennessee': 'TN',
    'Texas': 'TX',
    'Utah': 'UT',
    'Vermont': 'VT',
    'Virginia': 'VA',
    'Washington': 'WA',
    'West Virginia': 'WV',
    'Wisconsin': 'WI',
    'Wyoming': 'WY',
  };

  @override
  void initState() {
    nameInput.text = '';
    address1Input.text = '';
    address2Input.text = '';
    cityInput.text = '';
    // stateInput.text = ''; // TEST: Not needed for dropdown
    zipcodeInput.text = '';
    super.initState();
    getProfile();
  }

  Future<void> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt('customer_id');
    Map<String, dynamic> profileData = await HttpRequest.handleProfileInfo(customerId);
    setState(() {
      fullname = profileData['fullname'];
      address1 = profileData['address1'];
      if (profileData['address2'] != null){
        address2 = profileData['address2'];
      }
      city = profileData['city'];
      stateCode = profileData['stateCode'];
      zipcode = profileData['zipcode'];

      nameInput.text = fullname.toString();
      address1Input.text = address1.toString();
      address2Input.text = address2.toString();
      cityInput.text = city.toString();
      // stateInput.text = stateCode.toString(); // TEST: Not needed for dropdown
      zipcodeInput.text = zipcode.toString();
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget buildFullName() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Full Name",
        contentPadding: EdgeInsets.all(20.0),
        isDense: true,
        border: OutlineInputBorder(),
      ),
      controller: nameInput,
      maxLength: 50,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Full Name Required";
        }

        if (!RegExp(r"^[a-zA-Z]").hasMatch(value)) {
          return "Please enter a valid name";
        }

        return null;
      },
      onSaved: (value) {
        fullname = value;
      },
    );
  }

  Widget buildAddress1() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Address 1",
        contentPadding: EdgeInsets.all(20.0),
        isDense: true,
        border: OutlineInputBorder(),
      ),
      controller: address1Input,
      maxLength: 100,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Address Required";
        }

        if (!RegExp(r"^[a-zA-Z0-9]").hasMatch(value)) {
          return "Please enter a valid address";
        }

        return null;
      },
      onSaved: (value) {
        address1 = value;
      },
    );
  }

  Widget buildAddress2() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Address 2",
        contentPadding: EdgeInsets.all(20.0),
        isDense: true,
        border: OutlineInputBorder(),
      ),
      controller: address2Input,
      maxLength: 100,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return null;
        } else if (!RegExp(r"^[a-zA-Z0-9]").hasMatch(value)) {
          return "Please enter a valid address";
        }
        return null;
      },
      onSaved: (value) {
        address2 = value!;
      },
    );
  }

  Widget buildCity() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "City",
        contentPadding: EdgeInsets.all(20.0),
        isDense: true,
        border: OutlineInputBorder(),
      ),
      controller: cityInput,
      maxLength: 100,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "City Required";
        }

        if (!RegExp(r"^[a-zA-Z]").hasMatch(value)) {
          return "Please enter a valid city";
        }
        return null;
      },
      onSaved: (value) {
        city = value;
      },
    );
  }

  Widget buildStateCode() {
    return DropdownButtonFormField(
      decoration: const InputDecoration(
        labelText: "State",
        contentPadding: EdgeInsets.all(20.0),
        isDense: true,
        border: OutlineInputBorder(),
      ),
      items: _stateCodesList
          .map((description, value) {
        return MapEntry(
            value,
            DropdownMenuItem<String>(
              value: value,
              child: Text(description),
            ));
      })
          .values
          .toList(),
      // TODO Hardcode Remove Later
      //value: stateCode,
      value: stateCode,
      onChanged: (value) {
        setState(() {
          stateCode = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "State Required";
        }
        return null;
      },
      onSaved: (value) {
        stateCode = value;
      },
    );
  }

  Widget buildZipcode() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Zipcode",
        contentPadding: EdgeInsets.all(20.0),
        isDense: true,
        border: OutlineInputBorder(),
      ),
      controller: zipcodeInput,
      maxLength: 9,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Zipcode Required";
        }
        if (!RegExp(r"^[0-9]").hasMatch(value) || value.length < 5) {
          return "Please enter a valid zipcode";
        }
        return null;
      },
      onSaved: (value) {
        zipcode = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 30,
                    left: 24,
                    right: 24
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 12),
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 35,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ProfilePage())
                            );
                          },
                          tooltip: 'Go Back',
                        ),
                        const Spacer(),
                        const SizedBox(width: 50),
                        const Text(
                          "Profile Edit",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.settings),
                              iconSize: 35.0,
                              color: Colors.white,
                              onPressed: () {
                                Navigator.pop(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const ProfilePage()
                                    )
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              icon: const Icon(Icons.logout),
                              iconSize: 35.0,
                              color: Colors.white,
                              onPressed: () {
                                Navigator.of(context).popUntil((route) => route.isFirst);
                                Navigator.pop(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginPage())
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30,),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: 700,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        buildFullName(),
                        const SizedBox(height: 10),
                        buildAddress1(),
                        const SizedBox(height: 10),
                        buildAddress2(),
                        const SizedBox(height: 10),
                        buildCity(),
                        const SizedBox(height: 10),
                        buildStateCode(),
                        const SizedBox(height: 20),
                        buildZipcode(),
                        ElevatedButton(
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                            ),
                          ),
                          // TODO: Fix later to send to database instead of passing straight to profile
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState?.save();
                              // print(fullname);
                              // print(address1);
                              // print(address2);
                              // print(city);
                              // print(stateCode);
                              // print(zipcode);
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => const ProfilePage()));
                              await HttpRequest.handleEditProfile(
                                  customerId.toString(),
                                  fullname.toString(),
                                  address1.toString(),
                                  address2.toString(),
                                  city.toString(),
                                  stateCode.toString(),
                                  zipcode.toString(),
                                  context);
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  )),
            )
          ]
        ),
      ),
    );
  }
}