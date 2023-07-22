import 'package:flutter/material.dart';
import './responsive/responsive.dart';
import './responsive/desktop/profile_edit_desktop.dart';
import './responsive/mobile/profile_edit_mobile.dart';

class ProfileEdit extends StatefulWidget{
  const ProfileEdit({super.key});

  @override
  ProfileEditWidget createState() {
    return ProfileEditWidget();
  }
}

class ProfileEditWidget extends State<ProfileEdit> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsivePages(mobilePage: ProfileEditMobile(), desktopPage: ProfileEditDesktop()),
    );
  }

}
