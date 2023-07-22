import 'package:flutter/material.dart';
import './responsive/responsive.dart';
import './responsive/desktop/fuel_quote_desktop.dart';
import './responsive/mobile/fuel_quote_mobile.dart';

class FuelQuoteForm extends StatefulWidget{
  const FuelQuoteForm({super.key});

  @override
  FuelQuoteWidget createState() {
    return FuelQuoteWidget();
  }
}

class FuelQuoteWidget extends State<FuelQuoteForm> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsivePages(mobilePage: FuelQuoteFormMobile(), desktopPage: FuelQuoteFormDesktop()),
    );
  }

}
