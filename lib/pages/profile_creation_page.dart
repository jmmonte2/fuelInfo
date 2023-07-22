import 'package:flutter/material.dart';
import './responsive/responsive.dart';
import './responsive/desktop/profile_creation_desktop.dart';
import './responsive/mobile/profile_creation_mobile.dart';

class ProfileCreation extends StatefulWidget{
  const ProfileCreation({super.key});


  @override
  ProfileWidget createState() {
    return ProfileWidget();
  }
}

class ProfileWidget extends State<ProfileCreation> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsivePages(mobilePage: ProfileCreationMobile(), desktopPage: ProfileCreationDesktop()),
    );
  }

}
