import 'package:flutter/material.dart';
import './responsive/responsive.dart';
import 'responsive/desktop/signup_desktop.dart';
import 'responsive/mobile/signup_mobile.dart';

class RegisterPage extends StatefulWidget{
  const RegisterPage({super.key});

  @override
  RegisterWidget createState() {
    return RegisterWidget();
  }
}

class RegisterWidget extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsivePages(mobilePage: RegisterPageMobile(), desktopPage: RegisterPageDesktop()),
    );
  }

}
