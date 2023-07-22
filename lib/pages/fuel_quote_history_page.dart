import 'package:flutter/material.dart';
import './responsive/responsive.dart';
import 'responsive/desktop/fuel_history_desktop.dart';
import 'responsive/mobile/fuel_history_mobile.dart';

class FuelHistory extends StatefulWidget{
  const FuelHistory({super.key});

  @override
  FuelHistoryWidget createState() {
    return FuelHistoryWidget();
  }
}

class FuelHistoryWidget extends State<FuelHistory> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsivePages(mobilePage: FuelHistoryMobile(), desktopPage: FuelHistoryDesktop()),
    );
  }

}
