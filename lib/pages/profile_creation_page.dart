import 'signup_page.dart';
import 'dash_board_page.dart';
import 'package:flutter/material.dart';
import '/services/http_request.dart';

class ProfileCreation extends StatefulWidget {
  const ProfileCreation({super.key});

  @override
  State<ProfileCreation> createState() => _ProfileCreationState();
}

class _ProfileCreationState extends State<ProfileCreation> {
  String? fullname;
  String? address1;
  String? address2; //optional
  String? city;
  String? stateCode;
  String? zipcode;

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget buildFullName() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Full Name",
        contentPadding: EdgeInsets.all(20.0),
        isDense: true,
        border: OutlineInputBorder(),
      ),
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
        address2 = value;
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
      appBar: AppBar(
        title: const Text("Profile Creation",
            style: TextStyle(
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterPage()));
              },
              tooltip: 'Go Back',
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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

                        // Testing
                        // print(fullname);
                        // print(address1);
                        // print(address2);
                        // print(city);
                        // print(stateCode);
                        // print(zipcode);
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(builder: (context) => const Dashboard())
                        // );

                        // Save and send to
                        await HttpRequest.handleProfileCreation(
                            "1",
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
      ),
    );
  }
}
