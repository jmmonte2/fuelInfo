import 'package:flutter/material.dart';
import './responsive/responsive.dart';
import './responsive/desktop/login_desktop.dart';
import './responsive/mobile/login_mobile.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});


  @override
  LoginWidget createState() {
    return LoginWidget();
  }
}

class LoginWidget extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsivePages(mobilePage: LoginPageMobile(), desktopPage: LoginPageDesktop()),
    );
  }

}
