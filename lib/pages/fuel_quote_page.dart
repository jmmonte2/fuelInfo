import 'package:flutter/material.dart';
import 'package:flutterproject/pages/signup_page.dart';
import 'package:intl/intl.dart';

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
  double suggested = 3.43; // Non-Edit
  String? total; // Non-Edit
  double fuelTotal = 0.00;

  TextEditingController dateInput = TextEditingController();
  final fuelInput = TextEditingController();

  @override
  void initState() {
    dateInput.text = "";
    fuelInput.text = "";
    super.initState();
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
                    MaterialPageRoute(builder: (context) => RegisterPage())
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
                  buildAddress(),
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        print(gallons);
                        print(address);
                        print(date);
                        print(total);
                        return;
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

  @override
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
      onChanged: (value) {
        setState(() {
          fuelTotal = double.parse(value.toString()) * suggested;
          setState(() => fuelInput.text = fuelTotal.toString());
        });
      },
      onSaved: (value) => setState(() => gallons = value),
    );
  }

  Widget buildAddress() {
    return TextFormField(
      enabled: false,
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
      onSaved: (value) => setState(() => address = value),
      initialValue: address ?? "Pulled Address",
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
      onTap: () async {
        DateTime? userDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2060)
        );
        if (userDate != null) {
          String validDate = DateFormat('yyyy-MM-dd').format(userDate);
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
      onSaved: (value) => setState(() => total = value),
    );
  }
}
