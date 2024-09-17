import 'package:flutter/cupertino.dart';

const int largeScreenSize = 1366;
const int smallScreenSize = 360;
const int mediumScreenSize = 768;
const int customScreenSize = 1100;

class ResponsiveWidget extends StatelessWidget{
  final Widget largeScreen; //no ? b/c its required by the constructor
  final Widget? mediumScreen; //? means it has a default value of null if nothing is provided to the constructor
  final Widget smallScreen; //no ? b/c its required by the constructor
  final Widget? customScreen;
  const ResponsiveWidget({
    required this.largeScreen,
    this.mediumScreen,
    required this.smallScreen,
    this.customScreen,
    super.key,});

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < mediumScreenSize;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= mediumScreenSize && MediaQuery.of(context).size.width < largeScreenSize;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > largeScreenSize;
  }

  static bool isCustomSize(BuildContext context) {
    return MediaQuery.of(context).size.width <= customScreenSize && MediaQuery.of(context).size.width >= mediumScreenSize;
  }

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