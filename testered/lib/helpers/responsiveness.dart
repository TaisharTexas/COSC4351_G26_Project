import 'package:flutter/cupertino.dart';

const int largeScreenSize = 1366;
const int smallScreenSize = 360;
const int mediumScreenSize = 768;
const int customScreenSize = 1100;

class ResponsiveWidget extends StatelessWidget{
  final Widget largeScreen; //no ? b/c its required by the constructor
  final Widget? mediumScreen; //? means it has a default value of null if nothing is provided to the constructor
  final Widget smallScreen; //no ? b/c its required by the constructor
  // final Widget customScreen;
  const ResponsiveWidget({
    required this.largeScreen,
    this.mediumScreen,
    required this.smallScreen,
    super.key,});

  static bool isSmallScreen(BuildContext context) =>
      MediaQuery.of(context).size.width < smallScreenSize;
  static bool isMediumScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= mediumScreenSize &&
      MediaQuery.of(context).size.width < largeScreenSize;
  static bool isLargeScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= largeScreenSize;
  static bool isCustomeScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= mediumScreenSize &&
      MediaQuery.of(context).size.width <= customScreenSize;


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints){
      double _width = constraints.maxWidth;
      if(_width >= largeScreenSize){ return largeScreen; }
      else if(_width < largeScreenSize && _width >= mediumScreenSize){ return mediumScreen ?? largeScreen; }
      else{ return smallScreen ?? largeScreen; }

    });
  }

}