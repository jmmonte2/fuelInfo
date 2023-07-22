import 'package:flutter/material.dart';

class ResponsivePages extends StatelessWidget {
  final Widget mobilePage;
  final Widget desktopPage;

  const ResponsivePages({super.key, required this.mobilePage, required this.desktopPage});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 900) {
            return mobilePage;
          }
          else {
            return desktopPage;
          }
        }
    );
  }
}