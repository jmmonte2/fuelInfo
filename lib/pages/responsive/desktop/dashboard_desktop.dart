import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutterproject/pages/fuel_quote_page.dart';
import 'package:flutterproject/pages/fuel_quote_history_page.dart';
import 'package:flutterproject/pages/profile_page.dart';
import 'package:flutterproject/pages/login_page.dart';
import 'package:flutterproject/services/http_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardDesktop extends StatefulWidget{
  const DashboardDesktop({super.key});

  @override
  Dash createState() {
    return Dash();
  }
}

class Dash extends State<DashboardDesktop> {
  String username = "";
  String view = '';
  List<Map<String, dynamic>> quotes = [];
  List<Map<String, dynamic>> quoteOverview = [];
  List<Widget> quoteList = [];
  List<String> pastDates = [];
  List<String> currentDates = [];
  DateTime today = DateTime.now();
  num averageGallons = 0;
  double averageCost = 0;
  double totalFee = 0;
  num liveQuote = 0;
  num completedQuote = 0;


  @override
  void initState(){
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? customerId = prefs.getInt('customer_id');
    Map<String, dynamic> autoFillData = await HttpRequest.handleCustomerGet(customerId);
    quotes = await HttpRequest.handleDashGet(customerId);
    quoteOverview = await HttpRequest.handleQuoteGet(customerId);
    setState(() {
      username = autoFillData['username'];
      // Recent Quotes
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
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFEEEEEE),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.check_circle,
                      size: 30,
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
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    quotes[i]['gallons'].toString(),
                    style: const TextStyle(
                      fontSize: 17.0,
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
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 17.0,
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
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "\$${quotes[i]['total']}",
                    style: const TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
        quoteList.add(const SizedBox(height: 24));
      }
      // Overview
      for (var i = 0; i < quoteOverview.length; i++) {
        DateTime date = DateFormat('EEE, dd MMM yyyy HH:mm:ss').parse(quoteOverview[i]['date']);
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);
        if (date.isBefore(today)){
          pastDates.add(formattedDate);
        }
        else{
          currentDates.add(formattedDate);
        }
        averageGallons += quoteOverview[i]['gallons'];
        averageCost += quoteOverview[i]['total'];
        totalFee += quoteOverview[i]['total'];
      }
      // Overview Info
      if (quoteOverview.isNotEmpty){
        averageCost = double.parse((averageCost / quoteOverview.length).toStringAsFixed(2));
        averageGallons = double.parse((averageGallons / quoteOverview.length).toStringAsFixed(0));
        totalFee = double.parse(totalFee.toStringAsFixed(2));
      }
      if (quotes.isNotEmpty) {
        view = 'View More';
      }
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
                                username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Text(
                            "Dashboard",
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Row(
                  children: [
                    Flexible(
                      flex: 6,
                      child: Container(
                        height: 400,
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        child: LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints constraints){
                            final containerWidth = constraints.maxWidth;
                            final iconSize = containerWidth * 0.1;
                            final fontSize = containerWidth * 0.025;
                            final padding = containerWidth * 0.1;
                            return Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                children: [
                                  const Text(
                                    'Overview',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Divider(),
                                  const SizedBox(height: 24),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: padding),
                                        child: Row(
                                            children: [
                                              Icon(
                                                Icons.description_rounded,
                                                size: iconSize,
                                                color: Colors.blue,
                                              ),
                                              Text(
                                                "${quoteOverview.length} Quotes Created",
                                                style: TextStyle(
                                                  fontSize: fontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Spacer(),
                                              Container(
                                                height: 120,
                                                width: containerWidth * 0.3,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFEEEEEE),
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                alignment: Alignment.center,
                                                child: Padding (
                                                  padding: const EdgeInsets.all(10),
                                                  child: Column(
                                                    children: [
                                                      const Spacer(),
                                                      Text(
                                                        "Average Gallons: $averageGallons",
                                                        style: TextStyle(
                                                          fontSize: containerWidth * 0.02,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Text(
                                                        "Average Cost: \$$averageCost",
                                                        style: TextStyle(
                                                          fontSize: containerWidth * 0.02,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Text(
                                                        "Total Fees: \$$totalFee",
                                                        style: TextStyle(
                                                          fontSize: containerWidth * 0.02,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ]
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: padding),
                                        child: Row(
                                            children: [
                                              Container(
                                                height: 120,
                                                width: containerWidth * 0.3,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFEEEEEE),
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                alignment: Alignment.center,
                                                child: Padding (
                                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
                                                  child: Column(
                                                    children: [
                                                      const Spacer(),
                                                      Text(
                                                        "${currentDates.length}",
                                                        style: TextStyle(
                                                          fontSize: containerWidth * 0.03,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Ongoing Quotes",
                                                        style: TextStyle(
                                                          fontSize: containerWidth * 0.02,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              Container(
                                                height: 120,
                                                width: containerWidth * 0.3,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFEEEEEE),
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                alignment: Alignment.center,
                                                child: Padding (
                                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
                                                  child: Column(
                                                    children: [
                                                      const Spacer(),
                                                      Text(
                                                        "${pastDates.length}",
                                                        style: TextStyle(
                                                          fontSize: containerWidth * 0.03,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Past Quotes",
                                                        style: TextStyle(
                                                          fontSize: containerWidth * 0.02,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ]
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                        )
                      ),
                    ),
                    const Spacer(),
                    Flexible(
                      flex: 6,
                      child: Container(
                        height: 400,
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
                              const Divider(),
                              const SizedBox(height: 24),
                              Column(
                                children: quoteList,
                              ),
                              Row(
                                children: [
                                  const Spacer(),
                                  RichText(
                                    text: TextSpan(
                                        text: view,
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
                  ],
                ),
              ),
              const SizedBox(height: 60),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
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
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 40),
                                Container(
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.request_quote,
                                    size: 80,
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
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 40),
                                Container(
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.request_page,
                                    size: 80,
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
                                applicationVersion: '1.0.0',
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
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 40),
                                Container(
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.info,
                                    size: 80,
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