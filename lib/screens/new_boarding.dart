import 'package:flutter/material.dart';
import 'package:flutter_overboard/flutter_overboard.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/generated/l10n.dart';

class NewBoarding extends StatefulWidget {
  NewBoarding({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NewBoardingState createState() => _NewBoardingState();
}

class _NewBoardingState extends State<NewBoarding> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    pages = [
      PageModel(
          color: kPrimaryColor,
          imageAssetPath: 'assets/images/vicon.png',
          title: L10n.of(context).onboardingPage1Title,
          body: L10n.of(context).onboardingPage1Body,
          doAnimateImage: true),
      PageModel(
          color:Colors.white,
          imageAssetPath: 'assets/images/cicon.png',
          title: L10n.of(context).onboardingPage2Title,
          body: L10n.of(context).onboardingPage2Body,
          doAnimateImage: true),
      PageModel(
          color: kPrimaryColor,
          imageAssetPath: 'assets/images/vicon.png',
          title: L10n.of(context).onboardingPage3Title,
          body: L10n.of(context).onboardingPage3Body,
          doAnimateImage: true),

    ];
    return Scaffold(
      key: _globalKey,
      body: OverBoard(
        center: Offset(200,200),
        nextText: 'next',
        pages: pages,
        showBullets: true,
        skipCallback: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Skip clicked"),
          ));
        },
        finishCallback: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Finish clicked"),
          ));
        },
      ),
    );
  }

  List<PageModel> pages=[];
}