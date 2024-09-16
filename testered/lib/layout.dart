import 'package:flutter/material.dart';
import 'package:testered/helpers/responsiveness.dart';
import 'package:testered/widgets/largeScreen.dart';
import 'package:testered/widgets/smallScreen.dart';
// import 'package:testered/widgets/mediumScreen.dart';

class SiteLayout extends StatelessWidget{
  const SiteLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ResponsiveWidget(largeScreen: LargeScreen(), smallScreen: SmallScreen()),
      // body: LargeScreen(),
    );
  }
}