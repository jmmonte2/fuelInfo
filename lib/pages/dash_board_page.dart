import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'fuel_quote_page.dart';
import 'fuel_quote_history_page.dart';
import 'profilePage.dart';
import 'login_page.dart';
import 'package:flutterproject/services/http_request.dart';

class Dashboard extends StatefulWidget{
  const Dashboard({super.key});

  @override
  Dash createState() {
    return Dash();
  }
}

class Dash extends State<Dashboard> {
  String username = "debug";
  List<Map<String, dynamic>> quotes = [];

  @override
  void initState(){
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    Map<String, dynamic> autoFillData = await HttpRequest.handleCustomerGet(1);
    quotes = await HttpRequest.handleDashGet(1);
    setState(() {
      username = autoFillData['username'];
    });
  }


  @override
  Widget build(BuildContext context) {
    List<Widget> quoteList = [];
    for (var i = 0; i < quotes.length; i++) {
      DateTime date = DateFormat('EEE, dd MMM yyyy HH:mm:ss').parse(quotes[i]['date']);
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      quoteList.add(
        Row(
          children: [
            Column(
              children: [
                const Text(
                  "Invoiced",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  height: 20,
                  width: 20,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEEEEEE),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.check_circle,
                    size: 20,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                const Text(
                  "Gallons",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  quotes[i]['gallons'].toString(),
                  style: const TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                const Text(
                  "Date",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                const Text(
                  "Total",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "\$${quotes[i]['total']}",
                  style: const TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
      quoteList.add(const SizedBox(height: 24));
    }
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 145,
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
                    top: 60,
                    left: 24,
                    right: 24
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.account_circle,
                            size: 40.0,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Hello",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              username!,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
                                            const ProfilePage())
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              icon: const Icon(Icons.logout),
                              iconSize: 35.0,
                              color: Colors.white,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoginPage())
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      const Text(
                        'Recent Quotes',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Column(
                        children: quoteList,
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          RichText(
                            text: TextSpan(
                              text: 'View More',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context)=> const FuelHistory())
                                );
                              }
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const FuelQuoteForm())
                          );
                        },
                        child:
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Container(
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.request_quote,
                                  size: 40,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              const Text(
                                "Request \nQuote",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const FuelHistory())
                          );
                        },
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Container(
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.request_page,
                                  size: 40,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              const Text(
                                "Quote \nHistory",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          showAboutDialog(
                            context: context,
                            applicationIcon: const FlutterLogo(),
                            applicationName: 'Fuel Quote App',
                            applicationVersion: '0.0.1',
                            applicationLegalese: 'Developed by Group 9',
                            children: <Widget>[
                              const SizedBox(height: 12),
                              const Text(
                                'Project creates and manages fuel quotes created by users utilizing Flutter, Flask, and SQLite',
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Project developed for COSC 4353 - University of Houston by: \n Fabian Silva \n Hunter McPherson \n Jacob Montemayor \n Lawrence Castacio',
                              ),
                            ]
                          );
                        },
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Container(
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.info,
                                  size: 40,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "About",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
          ],
        )
      ),
    );
  }
}
