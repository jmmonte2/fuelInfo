import 'package:flutter/material.dart';
import 'dash_board_page.dart';
import 'package:intl/intl.dart';
import 'package:flutterproject/services/http_request.dart';

class FuelQuoteForm extends StatefulWidget {
  const FuelQuoteForm({super.key});

  @override
  FuelQuote createState() {
    return FuelQuote();
  }
}

class FuelQuote extends State<FuelQuoteForm> {
  String? gallons;
  String? address; // Non-Edit
  String? date;
  double suggested = 3.14; // Non-Edit
  String? total; // Non-Edit
  double fuelTotal = 0.00;
  String? address1;
  String? address2;
  List<DropdownMenuItem<String>> dropdownItems = [];


  TextEditingController dateInput = TextEditingController();
  final fuelInput = TextEditingController();
  final addressInput = TextEditingController();

  @override
  void initState(){
    // Real Time Variables for updating fields after input
    dateInput.text = "";
    fuelInput.text = "";
    addressInput.text = "";
    super.initState();
    fetchData();

  }

  Future<void> fetchData() async {
    Map<String, dynamic> autoFillData = await HttpRequest.handleFuelQuoteGet(1);
    setState(() {
      address1 = autoFillData['address1'];
      addressInput.text = address1.toString();
      address2 = autoFillData['address2'];
      suggested = double.parse(autoFillData['suggested']);

      dropdownItems = [
        DropdownMenuItem<String>(
          value: address1,
          child: Text(address1!),
        ),
      ];

      if (address2 != null) {
        dropdownItems.add(
          DropdownMenuItem<String>(
            value: address2,
            child: Text(address2!),
          ),
        );
      }
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fuel Quote", style: TextStyle(
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
                  const SizedBox(height: 10),
                  if (address2 != null) buildAddress(),
                  if (address2 == null) buildAddressStatic(),
                  const SizedBox(height: 10),
                  buildDate(),
                  const SizedBox(height: 10),
                  buildSuggested(),
                  const SizedBox(height: 10),
                  buildTotal(),
                  const SizedBox(height: 100),
                  ElevatedButton(
                    child: const Text("Submit",
                      style: TextStyle(color: Colors.blue, fontSize: 16,),),
                    onPressed: () async{
                      //Save Input and Sent to backend
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        await HttpRequest.handleQuotePost("1", gallons.toString(), address.toString(), date.toString(), suggested.toString(), total.toString(), context);
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
      decoration: const InputDecoration(
        labelText: "Gallons",
        contentPadding: EdgeInsets.all(20.0),
        isDense: true,
        border: OutlineInputBorder(),
      ),
      maxLines: 1,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Gallons Required';
        }
        if (!RegExp("^[0-9]").hasMatch(value)) {
          return 'Numeric Number Required';
        }
        return null;
      },
      // Real Time Update
      onChanged: (value) {
        setState(() {
          fuelTotal = double.parse(value.toString()) * suggested;
          setState(() => fuelInput.text = fuelTotal.toStringAsFixed(2));
        });
      },
      // Set Variable for backend
      onSaved: (value) => setState(() => gallons = value),
    );
  }

  Widget buildAddress() {
    return DropdownButtonFormField(
      decoration: const InputDecoration(
        labelText: "Address",
        contentPadding: EdgeInsets.all(20.0),
        isDense: true,
        border: OutlineInputBorder(),
      ),
      value: address1,
      onChanged: (value) {
        setState(() {
        });
      },
      items: dropdownItems,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Address Required';
        }
        return null;
      },
      // Set Variable for backend
      onSaved: (value) => setState(() => address = value),
    );
  }

  Widget buildAddressStatic() {
    return TextFormField(
      enabled: false,
      controller: addressInput,
      decoration: const InputDecoration(
        labelText: "Address",
        contentPadding: EdgeInsets.all(20.0),
        isDense: true,
        border: OutlineInputBorder(),
      ),
      maxLines: 1,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Address Required';
        }
        return null;
      },
      // Set Variable for backend
      onSaved: (value) => setState(() => address = value),
    );
  }

  Widget buildDate() {
    return TextFormField(
      controller: dateInput,
      decoration: const InputDecoration(
        labelText: "Date",
        contentPadding: EdgeInsets.all(20.0),
        isDense: true,
        border: OutlineInputBorder(),
      ),
      readOnly: true,
      maxLines: 1,
      // DateTime class to create a on tap calender picker
      onTap: () async {
        DateTime? userDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2060)
        );
        if (userDate != null) {
          String validDate = DateFormat('yyyy-MM-dd').format(userDate);
          // Real Time Variable
          setState(() => dateInput.text = validDate);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Date Required';
        }
        if (!RegExp("^[0-9]").hasMatch(value)) {
          return 'Numeric Number Required';
        }
        return null;
      },
      // Set Variable for backend
      onSaved: (value) => setState(() => date = value),
    );
  }

  Widget buildSuggested() {
    return TextFormField(
      enabled: false,
      decoration: const InputDecoration(
        labelText: "Suggested Price Per Gallon",
        contentPadding: EdgeInsets.all(20.0),
        isDense: true,
        border: OutlineInputBorder(),
      ),
      maxLines: 1,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Suggested Required';
        }
        if (!RegExp("^[0-9]").hasMatch(value)) {
          return 'Numeric Number Required';
        }
        return null;
      },
      initialValue: suggested.toString(),
    );
  }

  Widget buildTotal() {
    return TextFormField(
      readOnly: true,
      controller: fuelInput,
      decoration: const InputDecoration(
        labelText: "Total",
        contentPadding: EdgeInsets.all(20.0),
        isDense: true,
        border: OutlineInputBorder(),
      ),
      maxLines: 1,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Missing Fields';
        }
        return null;
      },
      // Set Variable for backend
      onSaved: (value) => setState(() => total = value),
    );
  }
}
