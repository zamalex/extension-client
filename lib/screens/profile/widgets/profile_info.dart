import 'package:flutter/material.dart';
import 'package:salon/configs/app_globals.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/configs/routes.dart';
import 'package:salon/main.dart';
import 'package:salon/utils/text_style.dart';
import 'package:salon/widgets/strut_text.dart';

class ProfileInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, Routes.editProfile),
      child: Row(
        children: <Widget>[
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/onboarding/welcome.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  StrutText(
                    getIt.get<AppGlobals>().user.fullName,
                    maxLines: 1,
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 4)),
                  StrutText(
                    getIt.get<AppGlobals>().user.phone,
                    maxLines: 1,
                    style: TextStyle(color: kPrimaryColor,fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
