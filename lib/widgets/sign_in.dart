import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:salon/blocs/auth/auth_bloc.dart';
import 'package:salon/configs/app_globals.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/configs/routes.dart';
import 'package:salon/generated/l10n.dart';
import 'package:salon/model/cart_provider.dart';
import 'package:salon/model/constants.dart';
import 'package:salon/model/loginmodel.dart';
import 'package:salon/utils/form_utils.dart';
import 'package:salon/utils/form_validator.dart';
import 'package:salon/utils/ui.dart';
import 'package:salon/widgets/strut_text.dart';
import 'package:salon/widgets/theme_button.dart';
import 'package:salon/widgets/theme_text_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'bottom_navigation.dart';

/// Signin widget to be used wherever we need user to log in before taking any
/// action.
class SignInWidget extends StatefulWidget {
  const SignInWidget({
    Key key,
    this.title,
  }) : super(key: key);

  /// Optional widget title.
  final String title;

  @override
  _SignInWidgetState createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> with SingleTickerProviderStateMixin {
  final TextEditingController _textEmailController = TextEditingController();
  final TextEditingController _textPassController = TextEditingController();
  final FocusNode _focusEmail = FocusNode();
  final FocusNode _focusPass = FocusNode();

  final GlobalKey<ThemeTextInputState> keyEmailInput = GlobalKey<ThemeTextInputState>();
  final GlobalKey<ThemeTextInputState> keyPasswordInput = GlobalKey<ThemeTextInputState>();

  AnimationController _controller;

  AuthBloc _loginBloc;
  bool _showPassword = false;
  bool _done = false;
  bool loading = false;


  String _title;
  final grey = Color.fromRGBO(118 ,123 ,128, 1);
  final greyLight = Color.fromRGBO(235, 235 ,235, 1);
  @override
  void initState() {
    _controller = AnimationController(vsync: this);

    _loginBloc = BlocProvider.of<AuthBloc>(context);
    _textEmailController.text = '';
    _textPassController.text = '';

    _title = widget.title ?? '';

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _loginBloc.close();
    super.dispose();
  }

  void _validateForm() async{
    FormUtils.hideKeyboard(context);

    if (keyPasswordInput.currentState.validate() && keyEmailInput.currentState.validate()) {
     /* SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('ctr', 1);
      _done = false;
      _loginBloc.state.done = false;
      _loginBloc.add(LoginRequestedAuthEvent(
        email: _textEmailController.text,
        password: _textPassController.text,
      ));*/
      SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        loading=true;
      });
      LoginModel().loginUser(_textEmailController.text, _textPassController.text).then((value) {
        setState(() {
          loading=false;
        });
        if(value==null){
          UI.showErrorDialog(
            context,
            message: 'server error',
          );
        }
          if(value.result)
            {
              print(value.user.phone);
              prefs.setBool("logged", true);
              getIt.get<AppGlobals>().isUser=true;
              Globals.TOKEN = value.accessToken;
              getIt.get<AppGlobals>().user.fullName = value.user.name;
              getIt.get<AppGlobals>().user.phone= value.user.phone;
              getIt.get<AppGlobals>().user.email= value.user.email;

              getIt.get<AppGlobals>().user.id = value.user.id;
              getIt.get<AppGlobals>().ID= value.user.id;
             // Provider.of<CartProvider>(context,listen: false).init();

            //  Phoenix.rebirth(context);
             /* Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => BottomNavigation(),
                ),
                    (route) => false,
              );*/
             // Navigator.of(context, rootNavigator: true).pop();

              (getIt.get<AppGlobals>().globalKeyBottomBar.currentWidget as BottomNavigationBar).onTap(0);
            }
          else
            UI.showErrorDialog(
              context,
              message: value.message,
            );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(kCardRadius),
              topRight: Radius.circular(kCardRadius),
            ),),

            padding: const EdgeInsets.symmetric(horizontal: kPaddingM),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (_title.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: kPaddingL, bottom: kPaddingM),
                      child: StrutText(
                        _title,
                        style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),
                      ),
                    )
                  else
                    Container(),
                  ThemeTextInput(
                    key: keyEmailInput,
                    controller: _textEmailController,
                    hintText: getIt.get<AppGlobals>().isRTL?'ادخل رقم الجوال':'enter phone number',
                    focusNode: _focusEmail,
                    keyboardType: TextInputType.phone,
                    icon: const Icon(Icons.clear,color: Colors.grey,),
                    textInputAction: TextInputAction.next,
                    onTapIcon: () async {
                      await Future<dynamic>.delayed(const Duration(milliseconds: 100));
                      _textEmailController.clear();
                    },
                    onSubmitted: (String text) => FormUtils.fieldFocusChange(context, _focusEmail, _focusPass),
                    validator: FormValidator.validators(<FormFieldValidator<String>>[
                      FormValidator.isRequired(L10n.of(context).formValidatorRequired),
                     // FormValidator.isEmail(L10n.of(context).formValidatorEmail),
                    ]),
                  ),
                  const Padding(padding: EdgeInsets.only(top: kPaddingM)),
                  ThemeTextInput(
                    key: keyPasswordInput,
                    hintText: L10n.of(context).signInHintPassword,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (String text) => _validateForm(),
                    onTapIcon: () => setState(() => _showPassword = !_showPassword),
                    obscureText: !_showPassword,
                    icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off,color: Colors.grey,),
                    controller: _textPassController,
                    focusNode: _focusPass,
                    validator: FormValidator.validators(<FormFieldValidator<String>>[
                      FormValidator.isRequired(L10n.of(context).formValidatorRequired),
                      FormValidator.isMinLength(
                        length: 6,
                        errorMessage: L10n.of(context).formValidatorMinLength(kMinimalPasswordLength),
                      ),
                    ]),
                  ),
                  const Padding(padding: EdgeInsets.only(top: kPaddingM)),
                 ThemeButton(
                          onPressed: _validateForm,
                          text: L10n.of(context).signInButtonLogin,
                          showLoading: loading,
                          disableTouchWhenLoading: true,
                        ),

                  const Padding(padding: EdgeInsets.only(top: kPaddingS)),
                  FlatButton(
                    onPressed: () => Navigator.pushNamed(context, Routes.forgotPassword),
                    child: Text(L10n.of(context).signInButtonForgot),
                  ),
                ],
              ),
            ),
          ),
        ),


           Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              StrutText(
                L10n.of(context).signInRegisterLabel,
                style:TextStyle(color: Colors.black,fontSize: 20),
              ),
             SizedBox(height: 5,),
             GestureDetector(
               onTap: () => Navigator.pushNamed(context, Routes.signUp),
               child:  StrutText(
                 L10n.of(context).signInButtonRegister,
                 style: TextStyle(color: grey,fontSize: 20),
               ),
             ),
              SizedBox(height: 20,),




            ],
          ),

      ],
    );
  }
}
