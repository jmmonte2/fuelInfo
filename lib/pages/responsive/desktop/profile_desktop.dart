import 'package:flutterproject/pages/dash_board_page.dart';
import 'package:flutterproject/pages/login_page.dart';
import 'package:flutterproject/pages/profile_page.dart';
import 'package:flutterproject/pages/profile_edit_page.dart';
import 'package:flutterproject/services/http_request.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePageDesktop extends StatefulWidget {
  const ProfilePageDesktop({
    super.key,
  });

  @override
  State<ProfilePageDesktop> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePageDesktop> {
  //TODO: username TEMP FIX FOR AUTHETIFCATION
  String currentUser = "";
  String fullname = "";
  String address1 = " ";
  String address2 = "";
  String city = "";
  String stateCode = "";
  String zipcode = "";

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  // final _formkey = GlobalKey<FormState>();
  // final TextEditingController _textEditingController = TextEditingController();

  Future<void> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? customerId = prefs.getInt('customer_id');
    Map<String, dynamic> profileData = await HttpRequest.handleProfileInfo(customerId);
    Map<String, dynamic> autoFillData = await HttpRequest.handleCustomerGet(customerId);
    currentUser = autoFillData['username'];
    setState(() {
      fullname = profileData['fullname'];
      address1 = profileData['address1'];
      if (profileData['address2'] != null){
        address2 = profileData['address2'];
      }
      city = profileData['city'];
      stateCode = profileData['stateCode'];
      zipcode = profileData['zipcode'];
    });
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
                                  MaterialPageRoute(builder: (context) => const DashboardPage())
                              );
                            },
                            tooltip: 'Go Back',
                          ),
                          const Spacer(),
                          const SizedBox(width: 50),
                          const Text(
                            "Profile",
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
                                  Navigator.push(
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
                                  Navigator.push(
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
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView(
                  children: [
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
                    const SizedBox(height: 25),
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
                ),
              ),
            ],
          ),
        ));
  }
}