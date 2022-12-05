import 'package:flutter/material.dart';
import 'package:extension/configs/app_globals.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/configs/routes.dart';
import 'package:extension/main.dart';
import 'package:extension/utils/text_style.dart';
import 'package:extension/widgets/strut_text.dart';

class ProfileInfo extends StatelessWidget {
  String img;
  ProfileInfo(this.img);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){}/*Navigator.pushNamed(context, Routes.editProfile).then((value){})*/,
      child: Row(
        children: <Widget>[
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image:img.isNotEmpty?NetworkImage(img): AssetImage('assets/images/onboarding/welcome.jpg')as ImageProvider,
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
                    style: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold,fontSize: 20),
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
