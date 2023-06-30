import 'package:flutter/material.dart';
import 'data.dart';
import 'dash_board_page.dart';

class FuelHistory extends StatefulWidget {
  const FuelHistory({super.key});

  @override
  FuelQuoteHistory createState() {
    return FuelQuoteHistory();
  }
}

class FuelQuoteHistory extends State<FuelHistory> {
  final List<Quote> _data = [
    const Quote(id: 1, gallons: 3, address: '321 Elmo Street', date: '2023-05-30', suggested: 100, total: 300),
    const Quote(id: 2, gallons: 12, address: '321 Elmo Street', date: '2023-06-02', suggested: 100, total: 1200),
    const Quote(id: 3, gallons: 15, address: '321 Elmo Street', date: '2023-06-14', suggested: 100, total: 1500),
    const Quote(id: 4, gallons: 6, address: '461 Art Avenue', date: '2023-06-19', suggested: 200, total: 1200),
    const Quote(id: 5, gallons: 1, address: '321 Elmo Street', date: '2023-06-25', suggested: 100, total: 100),
    const Quote(id: 6, gallons: 4, address: '461 Art Avenue', date: '2023-06-27', suggested: 50, total: 200),
    const Quote(id: 7, gallons: 7, address: '461 Art Avenue', date: '2023-06-30', suggested: 100, total: 700),
  ];

  int sortColumn = 0;
  bool isAscending = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Fuel Quote History", style: TextStyle(
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
                      MaterialPageRoute(builder: (context) => const Dashboard())
                  );
                },
                tooltip: 'Go Back',
              );
            },
          ),
        ),
        body: SizedBox(
          width: double.infinity,
          child: ListView(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
                              _data.sort((quoteA, quoteB) => quoteB.id.compareTo(quoteA.id));
                            } else {
                              isAscending = true;
                              _data.sort((quoteA, quoteB) => quoteA.id.compareTo(quoteB.id));
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
                              _data.sort((quoteA, quoteB) => quoteB.gallons.compareTo(quoteA.gallons));
                            } else {
                              isAscending = true;
                              _data.sort((quoteA, quoteB) => quoteA.gallons.compareTo(quoteB.gallons));
                            }
                          });
                        }),
                    const DataColumn(label: Text('Address')),
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
                              _data.sort((quoteA, quoteB) => quoteB.date.compareTo(quoteA.date));
                            } else {
                              isAscending = true;
                              _data.sort((quoteA, quoteB) => quoteA.date.compareTo(quoteB.date));
                            }
                          });
                        }),
                    const DataColumn(label: Text('Suggested')),
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
                              _data.sort((quoteA, quoteB) => quoteB.total.compareTo(quoteA.total));
                            } else {
                              isAscending = true;
                              _data.sort((quoteA, quoteB) => quoteA.total.compareTo(quoteB.total));
                            }
                          });
                        }),
                  ],
                  rows: _data.map((item) {
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
        ));
  }
}