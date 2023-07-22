import 'package:flutterproject/pages/dash_board_page.dart';
import 'package:flutterproject/pages/login_page.dart';
import 'package:flutterproject/pages/profile_page.dart';
import 'package:flutterproject/services/http_request.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutterproject/pages/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FuelHistoryDesktop extends StatefulWidget {
  const FuelHistoryDesktop({super.key});

  @override
  FuelQuoteHistory createState() {
    return FuelQuoteHistory();
  }
}

class FuelQuoteHistory extends State<FuelHistoryDesktop> {
  List<Map<String, dynamic>> quotes = [];
  final List<Quote> data = [];

  @override
  void initState(){
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? customerId = prefs.getInt('customer_id');
    quotes = await HttpRequest.handleQuoteGet(customerId);
    setState(() {
      for (var i = 0; i < quotes.length; i++) {
        DateTime date = DateFormat('EEE, dd MMM yyyy HH:mm:ss').parse(quotes[i]['date']);
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);
        final quote = Quote(
          id: quotes[i]['id'],
          gallons: quotes[i]['gallons'],
          address: quotes[i]['address'],
          date: formattedDate,
          suggested: quotes[i]['suggested'],
          total: quotes[i]['total'],
        );
        data.add(quote);
      }
    });
  }

  int sortColumn = 0;
  bool isAscending = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
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
                                  "Fuel Quote History",
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
                    SizedBox(
                    width: constraints.maxWidth,
                      child: DataTable(
                        sortColumnIndex: sortColumn,
                        sortAscending: isAscending,
                        headingRowColor: MaterialStateProperty.all(const Color(0xFFE0E0E0)),
                        columns: [
                          DataColumn(
                              label: const Text(
                                'ID',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              onSort: (columnIndex, _) {
                                setState(() {
                                  sortColumn = columnIndex;
                                  if (isAscending == true) {
                                    isAscending = false;
                                    data.sort((quoteA, quoteB) => quoteB.id.compareTo(quoteA.id));
                                  } else {
                                    isAscending = true;
                                    data.sort((quoteA, quoteB) => quoteA.id.compareTo(quoteB.id));
                                  }
                                });
                              }),
                          DataColumn(
                              label: const Text(
                                'Gallons',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              onSort: (columnIndex, _) {
                                setState(() {
                                  sortColumn = columnIndex;
                                  if (isAscending == true) {
                                    isAscending = false;
                                    data.sort((quoteA, quoteB) => quoteB.gallons.compareTo(quoteA.gallons));
                                  } else {
                                    isAscending = true;
                                    data.sort((quoteA, quoteB) => quoteA.gallons.compareTo(quoteB.gallons));
                                  }
                                });
                              }),
                          DataColumn(
                              label: const Text(
                                'Address',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              onSort: (columnIndex, _) {
                                setState(() {
                                  sortColumn = columnIndex;
                                  if (isAscending == true) {
                                    isAscending = false;
                                    data.sort((quoteA, quoteB) => quoteB.address.compareTo(quoteA.address));
                                  } else {
                                    isAscending = true;
                                    data.sort((quoteA, quoteB) => quoteA.address.compareTo(quoteB.address));
                                  }
                                });
                              }
                          ),
                          DataColumn(
                              label: const Text(
                                'Date',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              onSort: (columnIndex, _) {
                                setState(() {
                                  sortColumn = columnIndex;
                                  if (isAscending == true) {
                                    isAscending = false;
                                    data.sort((quoteA, quoteB) => quoteB.date.compareTo(quoteA.date));
                                  } else {
                                    isAscending = true;
                                    data.sort((quoteA, quoteB) => quoteA.date.compareTo(quoteB.date));
                                  }
                                });
                              }),
                          DataColumn(
                              label: const Text(
                                'Suggested',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              onSort: (columnIndex, _) {
                                setState(() {
                                  sortColumn = columnIndex;
                                  if (isAscending == true) {
                                    isAscending = false;
                                    data.sort((quoteA, quoteB) => quoteB.suggested.compareTo(quoteA.suggested));
                                  } else {
                                    isAscending = true;
                                    data.sort((quoteA, quoteB) => quoteA.suggested.compareTo(quoteB.suggested));
                                  }
                                });
                              }
                          ),
                          DataColumn(
                              label: const Text(
                                'Total',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              onSort: (columnIndex, _) {
                                setState(() {
                                  sortColumn = columnIndex;
                                  if (isAscending == true) {
                                    isAscending = false;
                                    data.sort((quoteA, quoteB) => quoteB.total.compareTo(quoteA.total));
                                  } else {
                                    isAscending = true;
                                    data.sort((quoteA, quoteB) => quoteA.total.compareTo(quoteB.total));
                                  }
                                });
                              }),
                        ],
                        rows: data.map((item) {
                          return DataRow(cells: [
                            DataCell(Text(item.id.toString())),
                            DataCell(Text(item.gallons.toString())),
                            DataCell(Text(item.address)),
                            DataCell(Text(item.date)),
                            DataCell(Text('\$${item.suggested}/gal')),
                            DataCell(Text('\$${item.total}')),
                          ]);
                        }).toList(),
                      ),
                    )
                  ],
                ),
              );
            }
        )
    );
  }
}