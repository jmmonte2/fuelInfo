import 'package:flutter/material.dart';
import './responsive/responsive.dart';
import 'responsive/desktop/dashboard_desktop.dart';
import 'responsive/mobile/dashboard_mobile.dart';

class DashboardPage extends StatefulWidget{
  const DashboardPage({super.key});

  @override
  DashboardWidget createState() {
    return DashboardWidget();
  }
}

class DashboardWidget extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsivePages(mobilePage: DashboardMobile(), desktopPage: DashboardDesktop()),
    );
  }

}
