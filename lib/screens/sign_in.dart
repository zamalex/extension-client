import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:extension/blocs/auth/auth_bloc.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/generated/l10n.dart';
import 'package:extension/widgets/sign_in.dart';

import '../blocs/application/application_bloc.dart';
import '../configs/app_globals.dart';
import '../configs/routes.dart';
import '../main.dart';
import '../widgets/picker.dart';

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
            ),
            Positioned(top:kToolbarHeight,right:10,child:InkWell(child:Icon(Icons.language,color: Colors.white,),onTap: (){
              _showLanguagePicker(context);
            },))
          ],
        );
      },
    );
  }


  Future<void> _showLanguagePicker(BuildContext context) async {
    final List<PickerItem<Locale>> _pickerItems = <PickerItem<Locale>>[];
    final List<PickerItem<Locale>> _selectedItems = <PickerItem<Locale>>[];

    for (final Locale _l in L10n.delegate.supportedLocales) {
      _pickerItems.add(PickerItem<Locale>(
        text: L10n.of(context).commonLocales(_l.toString()),
        value: _l,
      ));
    }

    _selectedItems.add(PickerItem<Locale>(
      text: L10n.of(context).commonLocales(getIt.get<AppGlobals>().selectedLocale.toString()),
      value: getIt.get<AppGlobals>().selectedLocale,
    ));

    final dynamic selectedLanguage = await Navigator.pushNamed(
      context,
      Routes.picker,
      arguments: <String, dynamic>{
        'title': L10n.of(context).pickerTitleLanguages,
        'items': _pickerItems,
        'itemsSelected': _selectedItems,
      },
    );

    if (selectedLanguage != null) {
      BlocProvider.of<ApplicationBloc>(context).add(ChangeRequestedLanguageApplicationEvent(selectedLanguage as Locale));
    }
  }
}
