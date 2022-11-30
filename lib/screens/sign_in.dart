import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:extension/blocs/auth/auth_bloc.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/generated/l10n.dart';
import 'package:extension/widgets/sign_in.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key key}) : super(key: key);

  @override
  _SignInScreenState createState() {
    return _SignInScreenState();
  }
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (AuthState prevState, AuthState currentState) => currentState is! LoginSuccessAuthState,
      builder: (BuildContext context, AuthState state) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(

                image: DecorationImage(
                  image: AssetImage(AssetsImages.loginBackground),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(kCardRadius),
                  topRight: Radius.circular(kCardRadius),
                ),
              ),
              child: SignInWidget(title: L10n.of(context).signInFormTitle),
            )
          ],
        );
      },
    );
  }
}
