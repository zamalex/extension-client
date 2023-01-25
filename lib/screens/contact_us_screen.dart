import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:extension/blocs/auth/auth_bloc.dart';
import 'package:extension/configs/app_globals.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/configs/routes.dart';
import 'package:extension/generated/l10n.dart';
import 'package:extension/main.dart';
import 'package:extension/model/constants.dart';
import 'package:extension/model/loginmodel.dart';
import 'package:extension/model/profile_data.dart';
import 'package:extension/utils/form_utils.dart';
import 'package:extension/utils/form_validator.dart';
import 'package:extension/utils/ui.dart';
import 'package:extension/widgets/form_label.dart';
import 'package:extension/widgets/list_title.dart';
import 'package:extension/widgets/modal_bottom_sheet_item.dart';
import 'package:extension/widgets/theme_button.dart';
import 'package:extension/widgets/theme_text_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key key}) : super(key: key);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  bool isLoading =false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text(L10n.of(context).changeaddress),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(left: kPaddingM, right: kPaddingM, top: kPaddingM),
                children: <Widget>[
                  FormLabel(text: getIt.get<AppGlobals>().isRTL?'العنوان':'Title'),
                  ThemeTextInput(

                    validator: FormValidator.isRequired(L10n.of(context).formValidatorRequired),

                    controller: titleController,
                  ),

                  FormLabel(text: getIt.get<AppGlobals>().isRTL?'الرسالة':'Message'),
                  ThemeTextInput(
                    maxLines: 5,
                    controller: bodyController,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingM, vertical: kPaddingS),
              child: ThemeButton(
                showLoading: isLoading,
                onPressed: (){

                  setState(() {
                    isLoading=true;
                  });
                  LoginModel().contactUs(titleController.text, bodyController.text).then((value){

                    setState(() {
                      isLoading=false;
                    });
                  });
                },
                text: L10n.of(context).commonBtnApply,
                disableTouchWhenLoading: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
