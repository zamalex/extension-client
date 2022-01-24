import 'dart:math';

import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/generated/l10n.dart';

class WithPages extends StatefulWidget {
  static final style = TextStyle(
    fontSize: 30,
    color: kWhite,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
  );
  static final style2 = TextStyle(
    fontSize: 20,
    color: kWhite,
    fontFamily: 'Poppins',

    fontWeight: FontWeight.w400,
  );

  @override
  _WithPages createState() => _WithPages();
}

class _WithPages extends State<WithPages> {
  int page = 0;
  LiquidController liquidController;
  UpdateType updateType;

  @override
  void initState() {
    liquidController = LiquidController();
    super.initState();
  }

  List<Widget> pages = [

  ];

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((page ?? 0) - index).abs(),
      ),
    );
    double zoom = 1.0 + (2.0 - 1.0) * selectedness;
    return new Container(
      width: 25.0,
      child: new Center(
        child: new Material(
          color: Colors.white,
          type: MaterialType.circle,
          child: new Container(
            width: 8.0 * zoom,
            height: 8.0 * zoom,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(pages.isEmpty)
      pages = [
        Container(

          width: double.infinity,
          color: kPrimaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(height: kToolbarHeight,),

              Image.asset(
                'assets/images/vicon.png',
                width: 300,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      L10n.of(context).onboardingPage1Title,
                      style: WithPages.style,
                    ),
                    SizedBox(height: 10,),
                    Text(
                      L10n.of(context).onboardingPage1Body,
                      style: WithPages.style2,
                        textAlign: TextAlign.center

                    ),
                    Text(
                      "",
                      style: WithPages.style,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,

          color: kWhite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(height: kToolbarHeight,),

              Image.asset(
                'assets/images/cicon.png',
                width: 300,

                fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      L10n.of(context).onboardingPage2Title,
                      style: WithPages.style.copyWith(color: kPrimaryColor),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      L10n.of(context).onboardingPage2Body,
                      style: WithPages.style2.copyWith(color: kPrimaryColor),
                        textAlign: TextAlign.center

                    ),
                    Text(
                      "",
                      style: WithPages.style,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,

          color: kPrimaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(height: kToolbarHeight,),
              Image.asset(
                'assets/images/vicon.png',
                width: 300,

                fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
              ),
              Expanded(child: Column(
                children: <Widget>[
                  Text(
                    L10n.of(context).onboardingPage3Title,
                    style: WithPages.style,
                  ),
                  SizedBox(height: 10,),
                  Text(
                      L10n.of(context).onboardingPage3Body,
                      style: WithPages.style2,
                      textAlign: TextAlign.center

                  ),
                  Text(
                    "",
                    style: WithPages.style,
                  ),
                ],
              )),
            ],
          ),
        ),

      ];
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            LiquidSwipe(
              pages: pages,
              slideIconWidget: Icon(Icons.arrow_back_ios),
              onPageChangeCallback: pageChangeCallback,
              waveType: WaveType.liquidReveal,
              enableLoop: false,
              fullTransitionValue: 800,
              liquidController: liquidController,
              ignoreUserGestureWhileAnimating: true,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Expanded(child: SizedBox()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(pages.length, _buildDot),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: FlatButton(
                  onPressed: () {
                    liquidController.animateToPage(
                        page: pages.length - 1, duration: 700);
                  },
                  child: Text("Skip to End"),
                  color: Colors.white.withOpacity(0.01),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: FlatButton(
                  onPressed: () {
                    liquidController.jumpToPage(
                        page:
                        liquidController.currentPage + 1 > pages.length - 1
                            ? 0
                            : liquidController.currentPage + 1);
                  },
                  child: Text("Next"),
                  color: Colors.white.withOpacity(0.01),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  pageChangeCallback(int lpage) {
    setState(() {
      page = lpage;
    });
  }
}