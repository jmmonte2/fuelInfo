import 'package:flutter/material.dart';
import 'package:flutterproject/pages/dash_board_page.dart';
import 'package:intl/intl.dart';
import 'package:flutterproject/services/http_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FuelQuoteFormMobile extends StatefulWidget {
  const FuelQuoteFormMobile({super.key});

  @override
  FuelQuote createState() {
    return FuelQuote();
  }
}

class FuelQuote extends State<FuelQuoteFormMobile> {
  String? gallons;
  String? address; // Non-Edit
  String? date;
  String? suggested; // Non-Edit
  String? total; // Non-Edit
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? zip;
  late int? customerId;
  List<DropdownMenuItem<String>> dropdownItems = [];


  TextEditingController dateInput = TextEditingController();
  final fuelInput = TextEditingController();
  final suggestedInput = TextEditingController();
  final addressInput = TextEditingController();
  final gallonsInput = TextEditingController();

  @override
  void initState(){
    // Real Time Variables for updating fields after input
    dateInput.text = "";
    fuelInput.text = "";
    suggestedInput.text = "";
    addressInput.text = "";
    gallonsInput.text = "";
    super.initState();
    fetchData();

  }

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt('customer_id');
    Map<String, dynamic> autoFillData = await HttpRequest.handleFuelQuoteGet(customerId);
    Map<String, dynamic> addressData = await HttpRequest.handleQuoteAddress(customerId);
    setState(() {
      city = addressData['city'];
      state = addressData['stateCode'];
      zip = addressData['zipcode'];
      address1 = autoFillData['address1'] + ", " + city + ", " + state + " " + zip;
      address = address1;
      addressInput.text = address1.toString();
      address2 = autoFillData['address2'] + ", " + city + ", " + state + " " + zip;
      suggested = autoFillData['suggested'];

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
  final GlobalKey<FormFieldState> _quoteCheckerGallons = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _quoteCheckerAddress = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _quoteCheckerDate = GlobalKey<FormFieldState>();

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
                    MaterialPageRoute(builder: (context) => const DashboardPage())
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
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        child: const Text("Get Quote",
                          style: TextStyle(color: Colors.blue, fontSize: 16,),),
                        onPressed: () async{
                          //Save Input and Sent to backend
                          if(gallons != null){
                            gallonsInput.text = gallons!;
                          }
                          _formKey.currentState!.reset();
                          _quoteCheckerGallons.currentState!.reset();_quoteCheckerAddress.currentState!.reset();_quoteCheckerDate.currentState!.reset();
                          if (_quoteCheckerGallons.currentState!.validate() & _quoteCheckerAddress.currentState!.validate() & _quoteCheckerDate.currentState!.validate()) {
                            _quoteCheckerGallons.currentState?.save(); _quoteCheckerAddress.currentState?.save(); _quoteCheckerDate.currentState?.save();
                            Map<String, dynamic> quoteCreate = await HttpRequest.handleQuoteCreate(customerId, gallons.toString(), address.toString(), date.toString(), context);
                            suggested = quoteCreate['suggested'].toString();
                            total = quoteCreate['total'].toStringAsFixed(2);

                            setState(() {
                              suggestedInput.text = suggested.toString();
                              fuelInput.text = total.toString();
                            });
                          }
                        }
                        ,),
                      const Spacer(),
                      ElevatedButton(
                        child: const Text("Submit",
                          style: TextStyle(color: Colors.blue, fontSize: 16,),),
                        onPressed: () async{
                          //Save Input and Sent to backend
                          if(gallons != null){
                            gallonsInput.text = gallons!;
                          }
                          _formKey.currentState!.reset();
                          _quoteCheckerGallons.currentState!.reset();_quoteCheckerAddress.currentState!.reset();_quoteCheckerDate.currentState!.reset();
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState?.save();
                            await HttpRequest.handleQuotePost(customerId, gallons.toString(), address.toString(), date.toString(), suggested.toString(), total.toString(), context);
                          }
                        }
                        ,),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }

  Widget buildGallons() {
    return TextFormField(
      key: _quoteCheckerGallons,
      controller: gallonsInput,
      decoration: const InputDecoration(
        labelText: "Gallons",
        contentPadding: EdgeInsets.all(20.0),
        isDense: true,
        border: OutlineInputBorder(),
      ),
      maxLines: 1,
      onChanged: (value) {
        setState(() {
          gallons = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Gallons Required';
        }
        if (!RegExp("^[0-9]").hasMatch(value)) {
          return 'Numeric Number Required';
        }
        return null;
      },
      // Set Variable for backend
      onSaved: (value) => setState(() => gallons = value),
    );
  }

  Widget buildAddress() {
    return DropdownButtonFormField(
      key: _quoteCheckerAddress,
      decoration: const InputDecoration(
        labelText: "Address",
        contentPadding: EdgeInsets.all(20.0),
        isDense: true,
        border: OutlineInputBorder(),
      ),
      value: address,
      isExpanded: true,
      onChanged: (value) {
        address = value;
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
      key: _quoteCheckerAddress,
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
      key: _quoteCheckerDate,
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
      readOnly: true,
      controller: suggestedInput,
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
          return 'Total Required';
        }
        return null;
      },
      // Set Variable for backend
      onSaved: (value) => setState(() => total = value),
    );
  }
}
