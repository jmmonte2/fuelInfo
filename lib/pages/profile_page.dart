import 'package:flutter/material.dart';
import './responsive/responsive.dart';
import 'responsive/desktop/profile_desktop.dart';
import 'responsive/mobile/profile_mobile.dart';

class ProfilePage extends StatefulWidget{
  const ProfilePage({super.key});

  @override
  ProfileWidget createState() {
    return ProfileWidget();
  }
}

class ProfileWidget extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsivePages(mobilePage: ProfilePageMobile(), desktopPage: ProfilePageDesktop()),
    );
  }

}
