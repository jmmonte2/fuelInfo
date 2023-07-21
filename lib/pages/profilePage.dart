import 'dash_board_page.dart';
import 'profile_edit_page.dart';
import 'package:flutterproject/services/http_request.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //TODO: username TEMP FIX FOR AUTHETIFCATION
  final String currentUser = "Tester";
  String fullname = "test";
  String address1 = " test";
  String address2 = "test";
  String city = "test";
  String stateCode = "test";
  String zipcode = "test";

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  // final _formkey = GlobalKey<FormState>();
  // final TextEditingController _textEditingController = TextEditingController();

  // TODO: Replace hardcoded value for http request for current user id
  Future<void> getProfile() async {
    Map<String, dynamic> profileData = await HttpRequest.handleProfileInfo(1);
    Map<String, dynamic> userData = await HttpRequest.handleCustomerGet(1);
    setState(() {
      currentUser = userData['username'];
      fullname = profileData['fullname'];
      address1 = profileData['address1'];
      address2 = profileData['address2'];
      city = profileData['city'];
      stateCode = profileData['stateCode'];
      zipcode = profileData['zipcode'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFEEEEEE),
        appBar: AppBar(
          title: const Text(
            "Profile Page",
            style: TextStyle(color: Colors.white),
          ),
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
                      MaterialPageRoute(
                          builder: (context) => const Dashboard()));
                },
                tooltip: 'Go Back',
              );
            },
          ),
        ),
        body: ListView(
          children: [
            const SizedBox(height: 30),

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
                    color: Colors.white,
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
                    Text(fullname),
                  ],
                )),

            //user address info
            // TODO: Update later to access info from database instead of passing straight from creation
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
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
                    Text(address1),
                    const SizedBox(height: 10),

                    //user address 2
                    Text(
                      'Address Line 2 (Optional):',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 5),
                    Text(address2),
                    const SizedBox(height: 10),

                    //user city
                    Text(
                      'City:',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 5),
                    Text(city),
                    const SizedBox(height: 10),

                    //user state
                    //FIX ME: Implement Drop down menu for state codes
                    Text(
                      'State:',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 5),
                    Text(stateCode),
                    const SizedBox(height: 10),

                    // user zipcode
                    Text(
                      'Zipcode:',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 5),
                    Text(zipcode),
                  ],
                )),
            // Navigation Buttons
            // TODO: Update later to grab info from database
            Container(
                padding: const EdgeInsets.only(top: 5, left: 15, bottom: 15),
                margin: const EdgeInsets.only(top: 5, left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                      builder: (context) =>
                                          const ProfileEdit()));
                            }),
                      ],
                    ),
                  ],
                )),
          ],
        ));
  }
}
