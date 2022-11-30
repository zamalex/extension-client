import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:extension/blocs/auth/auth_bloc.dart';
import 'package:extension/configs/app_globals.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/generated/l10n.dart';
import 'package:extension/model/loginmodel.dart';
import 'package:extension/screens/verify.dart';
import 'package:extension/utils/form_validator.dart';
import 'package:extension/utils/ui.dart';
import 'package:extension/widgets/bold_title.dart';
import 'package:extension/widgets/strut_text.dart';
import 'package:extension/widgets/theme_button.dart';
import 'package:extension/widgets/theme_text_input.dart';

import '../main.dart';

class ChangePasswordScreen extends StatefulWidget {
  String code;
  ChangePasswordScreen(this.code);

  @override
  _ChangePasswordScreenState createState() {
    return _ChangePasswordScreenState();
  }
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _textEmailController = TextEditingController();
  final GlobalKey<ThemeTextInputState> keyEmailInput = GlobalKey<ThemeTextInputState>();
  bool isLoading = false;
  Future<void> _resetPassword() async {
    if (keyEmailInput.currentState.validate()) {
      //BlocProvider.of<AuthBloc>(context).add(NewPasswordRequestedAuthEvent(_textEmailController.text));
      setState(() {
        isLoading = true;
      });
      LoginModel().changePass(widget.code,_textEmailController.text).then((value){
        setState(() {
          isLoading = false;
        });
        if(value as bool){
          (getIt.get<AppGlobals>().globalKeyBottomBar.currentWidget as BottomNavigationBar)
              .onTap(3);
          Navigator.of(context).popUntil((route) => route.isFirst);
        }else{
          UI.showErrorDialog(
            context,
            title: L10n.of(context).forgotPasswordDialogTitle,
            message: 'error ... please try again',
            onPressed: () => Navigator.pop(context),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(L10n.of(context).forgotPasswordTitle),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: kPaddingM),
          //alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20,),
                BoldTitle(
                  title: L10n.of(context).forgotPasswordTitle,
                  padding: const EdgeInsets.only(bottom: kPaddingM),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: kPaddingS),
                  child: StrutText(
                    '',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.black),
                  ),
                ),
                ThemeTextInput(
                  key: keyEmailInput,
                  controller: _textEmailController,
                  hintText: 'new password',
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  icon: const Icon(Icons.clear,color: kPrimaryColor,),
                  textInputAction: TextInputAction.next,
                  onTapIcon: () async {
                    await Future<dynamic>.delayed(const Duration(milliseconds: 100));
                    _textEmailController.clear();
                  },
                  validator: FormValidator.validators(<FormFieldValidator<String>>[
                    FormValidator.isRequired(L10n.of(context).formValidatorRequired),
                    // FormValidator.isEmail(L10n.of(context).formValidatorEmail),
                  ]),
                ),
                const Padding(padding: EdgeInsets.only(top: kPaddingM)),
                ThemeButton(
                  onPressed: _resetPassword,
                  text: L10n.of(context).forgotPasswordBtn,
                  showLoading: isLoading,
                  disableTouchWhenLoading: true,
                ),
                const Padding(padding: EdgeInsets.only(top: kPaddingS)),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
