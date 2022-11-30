import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:extension/blocs/auth/auth_bloc.dart';
import 'package:extension/configs/app_globals.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/configs/routes.dart';
import 'package:extension/generated/l10n.dart';
import 'package:extension/main.dart';
import 'package:extension/model/cart_provider.dart';
import 'package:extension/model/loginmodel.dart';
import 'package:extension/screens/appointments/appointments.dart';
import 'package:extension/screens/profile/widgets/profile_info.dart';
import 'package:extension/utils/bottom_bar_items.dart';
import 'package:extension/utils/ui.dart';
import 'package:extension/widgets/arrow_right_icon.dart';
import 'package:extension/widgets/badge.dart';
import 'package:extension/widgets/list_item.dart';
import 'package:extension/utils/text_style.dart';
import 'package:extension/widgets/list_title.dart';
import 'package:extension/widgets/strut_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthBloc block;
  String img = '';

  bool show = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    block = BlocProvider.of<AuthBloc>(context);

    LoginModel().getProfileImage().then((value){
      setState(() {
        img=value;
      });

      LoginModel().getShow().then((bool value){
        setState(() {
          show=value;
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (AuthState previousState, AuthState currentState) => currentState is PreferenceSaveSuccessAuthState,
      builder: (BuildContext context, AuthState state) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: Theme.of(context).brightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
          child: Scaffold(
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(kPaddingM),
                    child: Column(
                      children: <Widget>[ProfileInfo(img)],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: kPaddingM),
                      child: ListView(
                        children: <Widget>[
                          ListItem(
                            titleTextStyle: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold),
                            title: L10n.of(context).profileListAppointments,
                            leading: const Icon(Icons.calendar_today,color: kPrimaryColor),
                            trailing: Row(
                              children: <Widget>[
                               /* if (getIt.get<AppGlobals>().user.upcomingAppointments > 0)
                                  Badge(
                                    text: getIt.get<AppGlobals>().user.upcomingAppointments.toString(),
                                    color: kWhite,
                                    backgroundColor: kPrimaryColor,
                                  )
                                else*/
                                  Container(),
                                const ArrowRightIcon(),
                              ],
                            ),
                            onPressed: () {
                              // tap on BottomNavigationBar button
                              Navigator.of(context).push(MaterialPageRoute(builder: (c)=>AppointmentsScreen()));
                            },
                          ),

                          ListItem(
                            titleTextStyle: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold),
                            title: L10n.of(context).myOrders,//L10n.of(context).profileListVouchers,
                            leading: const Icon(Icons.shopping_cart_outlined,color: kPrimaryColor),
                            trailing: Row(
                              children: <Widget>[
                                if (getIt.get<AppGlobals>().user.activeVouchers > 0)
                                  Badge(
                                    text: getIt.get<AppGlobals>().user.activeVouchers.toString(),
                                    color: kWhite,
                                    backgroundColor: kPrimaryColor,
                                  )
                                else
                                  Container(),
                                const ArrowRightIcon(),
                              ],
                            ),
                            onPressed: () => Navigator.pushNamed(context, Routes.vouchers),
                          ),
                          ListItem(
                                                        titleTextStyle: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold),

                            title: L10n.of(context).profileListFavorites,
                            leading: const Icon(Icons.favorite_border,color: kPrimaryColor),
                            trailing: const ArrowRightIcon(),
                            onPressed: () => Navigator.pushNamed(context, Routes.favorites),
                          ),
                          ListItem(
                                                        titleTextStyle: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold),


                            title: L10n.of(context).profileListReviews,
                            leading: const Icon(Icons.star_border,color: kPrimaryColor),
                            trailing: const ArrowRightIcon(),
                            onPressed: () => Navigator.pushNamed(context, Routes.ratings),
                          ),

                          ListItem(
                                                        titleTextStyle: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold),


                            title: L10n.of(context).profileListEdit,
                            leading: const Icon(Icons.person_outline,color: kPrimaryColor),
                            trailing: const ArrowRightIcon(),
                            onPressed: () => Navigator.pushNamed(context, Routes.editProfile).then((value){
                              setState(() {

                              });
                            }),
                          ),

                          ListItem(
                                                        titleTextStyle: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold),


                            title: L10n.of(context).profileListSettings,
                            leading: const Icon(Icons.settings,color: kPrimaryColor),
                            trailing: const ArrowRightIcon(),
                            onPressed: () => Navigator.pushNamed(context, Routes.settings),
                          ),

                          if(show)

                            ListItem(
                              titleTextStyle: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold),


                              title:'Delete Account',
                              leading: const Icon(Icons.delete_forever,color: kPrimaryColor),
                              trailing: const ArrowRightIcon(),
                              onPressed: () async{
                                LoginModel().deleteAccount();
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setBool("logged", false);
                                getIt.get<AppGlobals>().isUser=false;
                                Provider.of<CartProvider>(context,listen: false).clear();
                                Phoenix.rebirth(context);

                              },
                            ),
                          ListItem(
                            titleTextStyle: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold),


                            title: L10n.of(context).profileListLogout,
                            leading: const Icon(Icons.logout,color: kPrimaryColor),
                            trailing: const ArrowRightIcon(),
                            onPressed: ()async{
                              //LoginModel().deleteAccount();
                             SharedPreferences prefs = await SharedPreferences.getInstance();
                             prefs.setBool("logged", false);
                              getIt.get<AppGlobals>().isUser=false;
                             Provider.of<CartProvider>(context,listen: false).clear();
                              Phoenix.rebirth(context);

                            // block.add(UserLoggedOutAuthEvent());

                            //  BlocProvider.of<AuthBloc>(context).close();

                            //  state.done=false;


                            },
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
