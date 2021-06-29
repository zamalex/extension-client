import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salon/screens/vendor/text_field.dart';
import 'package:salon/screens/vendor/theme_button.dart';


class VendorLogin extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/hair.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: SignInWidget(title: 'Welcome back'),
            )
          ],
        );

  }
}

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

  bool _showPassword = false;
  bool _done = false;


  String _title;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);

    _textEmailController.text = '';
    _textPassController.text = '';

    _title = widget.title ?? '';

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateForm() {
   // FormUtils.hideKeyboard(context);

    if (keyPasswordInput.currentState.validate() && keyEmailInput.currentState.validate()) {

      /* LoginModel().loginUser(_textEmailController.text, _textPassController.text).then((value) {
          if(value.user==null)
            print('no user found');
          else
            print('welcome ${value.user.name}');
      });*/
    }
  }


  @override
  Widget build(BuildContext context) {
    return Material(color: Colors.transparent,child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (_title.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 40, bottom: 20),
                      child: Text(
                        _title, style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),
                        //style: Theme.of(context).textTheme.headline5.bold,
                      ),
                    )
                  else
                    Container(),
                  ThemeTextInput(
                    onSubmitted: (c){FocusScope.of(context).requestFocus(_focusPass);},
                    key: keyEmailInput,
                    controller: _textEmailController,
                    hintText: 'phone',
                    focusNode: _focusEmail,
                    keyboardType: TextInputType.phone,
                    icon: const Icon(Icons.clear),
                    textInputAction: TextInputAction.next,
                    onTapIcon: () async {
                      await Future<dynamic>.delayed(const Duration(milliseconds: 100));
                      _textEmailController.clear();
                    },

                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  ThemeTextInput(
                    helpText: '',
                    key: keyPasswordInput,
                    hintText: 'password',
                    textInputAction: TextInputAction.done,
                    onSubmitted: (String text) => _validateForm(),
                    onTapIcon: () => setState(() => _showPassword = !_showPassword),
                    obscureText: !_showPassword,
                    icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                    controller: _textPassController,
                    focusNode: _focusPass,

                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  ThemeButton(
                    onPressed: _validateForm,
                    text: 'Login',
                    showLoading: false,
                    disableTouchWhenLoading: true,
                  ),

                ],
              ),
            ),
          ),
        ),

      ],
    ),);
  }


}

