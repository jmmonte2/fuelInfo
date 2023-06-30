import 'profile_creation_page.dart';
import 'fuel_quote_page.dart';
import 'login_page.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String userFullName;
  final String userAddress1;
  final String userAddress2;
  final String userCity;
  final String userStateCode;
  final String userZipcode;
  const ProfilePage({
    super.key,
    required this.userFullName,
    required this.userAddress1,
    required this.userAddress2,
    required this.userCity,
    required this.userStateCode,
    required this.userZipcode,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //TODO: username TEMP FIX FOR AUTHETIFCATION
  final String currentUser = "genericUsername";

  // final _formkey = GlobalKey<FormState>();
  // final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: const Text(
            "Profile Page",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: ListView(
          children: [
            const SizedBox(height: 50),

            //profilepic
            const Icon(
              Icons.person,
              size: 72,
            ),

            const SizedBox(height: 10),

            //username
            Text(
              currentUser,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700]),
            ),

            const SizedBox(height: 25),

            //userdetails
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Text(
                'My Details',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),

            //user full name
            // TODO: Update later to access info from database
            Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.only(left: 15, bottom: 15),
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //sectionName
                    Text(
                      'Full Name',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //text
                    Text(widget.userFullName),
                  ],
                )),

            //user address info
            // TODO: Update later to access info from database instead of passing straight from creation
            Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.only(left: 15, bottom: 15),
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Address Line 1:',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 5),
                    //user address 1
                    Text(widget.userAddress1),
                    const SizedBox(height: 10),

                    //user address 2
                    Text(
                      'Address Line 2 (Optional):',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 5),
                    Text(widget.userAddress2),
                    const SizedBox(height: 10),

                    //user city
                    Text(
                      'City:',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 5),
                    Text(widget.userCity),
                    const SizedBox(height: 10),

                    //user state
                    //FIX ME: Implement Drop down menu for state codes
                    Text(
                      'State:',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 5),
                    Text(widget.userStateCode),
                    const SizedBox(height: 10),

                    // user zipcode
                    Text(
                      'Zipcode:',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 5),
                    Text(widget.userZipcode),
                    const SizedBox(height: 10),
                  ],
                )),

            // Navigation Buttons
            // TODO: Update later to grab info from database
            Container(
                padding: const EdgeInsets.only(top: 10, left: 15, bottom: 15),
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // TODO: Update later to go to a new update info page
                        // that has options to edit individual fields
                        ElevatedButton(
                            child: const Text(
                              "Edit Profile",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileCreation()));
                            }),
                        ElevatedButton(
                          child: const Text(
                            "Go to Fuel Quote Page",
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FuelQuoteForm()));
                          },
                        ),
                        ElevatedButton(
                          child: const Text(
                            "Logout",
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                        )
                      ],
                    ),
                  ],
                )),
          ],
        ));
  }
}
