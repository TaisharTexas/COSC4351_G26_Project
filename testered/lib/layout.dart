import 'package:flutter/material.dart';
import 'package:testered/helpers/responsiveness.dart';
import 'package:testered/widgets/largeScreen.dart';
import 'package:testered/widgets/smallScreen.dart';
import 'package:testered/widgets/topNav.dart';
// import 'package:testered/widgets/mediumScreen.dart';

class SiteLayout extends StatelessWidget{
  // const SiteLayout({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topNavigationBar(context, scaffoldKey),
      drawer: Drawer(),
      body: ResponsiveWidget(largeScreen: LargeScreen(), smallScreen: SmallScreen()),
      // body: LargeScreen(),
    );
  }
}