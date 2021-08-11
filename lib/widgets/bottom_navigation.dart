import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salon/blocs/auth/auth_bloc.dart';
import 'package:salon/configs/app_globals.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/data/models/bottom_bar_item_model.dart';
import 'package:salon/main.dart';
import 'package:salon/generated/l10n.dart';
import 'package:salon/screens/appointments/appointments.dart';
import 'package:salon/screens/appointments/appointments_welcome.dart';
import 'package:salon/screens/cart/cart.dart';
import 'package:salon/screens/home/home.dart';
import 'package:salon/screens/inbox/inbox.dart';
import 'package:salon/screens/profile/profile.dart';
import 'package:salon/screens/search/search.dart';
import 'package:salon/screens/sign_in.dart';
import 'package:salon/utils/bottom_bar_items.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  /// Creates the bottom bar items.
  List<BottomNavigationBarItem> _bottomBarItems(BuildContext context) {
    getIt.get<BottomBarItems>().clear();

    getIt.get<BottomBarItems>().add(const BottomBarItemModel(id: 'home', icon: Icons.explore));
    getIt.get<BottomBarItems>().add(const BottomBarItemModel(id: 'explore', icon: Icons.search));
    //getIt.get<BottomBarItems>().add(const BottomBarItemModel(id: 'appointments', icon: Icons.date_range));
    getIt.get<BottomBarItems>().add(const BottomBarItemModel(id: 'inbox', icon: Icons.message));
    getIt.get<BottomBarItems>().add(const BottomBarItemModel(id: 'profile', icon: Icons.person));

    final List<BottomNavigationBarItem> bottomBarItems = <BottomNavigationBarItem>[];

    for (final BottomBarItemModel item in getIt.get<BottomBarItems>().getItems()) {
      bottomBarItems.add(BottomNavigationBarItem(
        icon: Row(children: [Icon(item.icon),Text(item.id)],),
        label: ''
      ));
    }

    return bottomBarItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, AuthState state) {
          return IndexedStack(

            index: _selectedIndex,
            children: <Widget>[
              HomeScreen(key: getIt.get<AppGlobals>().globalKeyHomeScreen),
              SearchScreen(key: getIt.get<AppGlobals>().globalKeySearchScreen),
          //    if (getIt.get<AppGlobals>().user != null) const AppointmentsScreen() else const AppointmentsWelcomeScreen(),
              if (getIt.get<AppGlobals>().isUser)  CartList() else const SignInScreen(),
              if (getIt.get<AppGlobals>().isUser ) const ProfileScreen() else const SignInScreen(),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        key: getIt.get<AppGlobals>().globalKeyBottomBar,
        items: [
          BottomNavigationBarItem(

              icon: Container(
                height: kBottomBarIconSize,
                margin: EdgeInsets.symmetric(horizontal: 5),
                 // padding: EdgeInsets.all(8),
                  decoration:  BoxDecoration(
                    color: _selectedIndex==0?kPrimaryColor:Colors.transparent,
                    borderRadius:  BorderRadius.circular(20),
                  ),
                  child: _selectedIndex==0?Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [Icon(Icons.explore,color: _selectedIndex==0?Colors.white:kPrimaryColor,),Text(L10n.of(context).bhome,style: TextStyle(color: kWhite),)],):Icon(Icons.explore,color:kPrimaryColor )
              ),
              label: ''
          ),
          BottomNavigationBarItem(

              icon: Container(
                  height: kBottomBarIconSize,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  // padding: EdgeInsets.all(8),
                  decoration:  BoxDecoration(
                    color: _selectedIndex==1?kPrimaryColor:Colors.transparent,
                    borderRadius:  BorderRadius.circular(20),
                  ),
                  child: _selectedIndex==1?Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [Icon(Icons.search,color: _selectedIndex==1?Colors.white:kPrimaryColor,),Text(L10n.of(context).bsearch,style:TextStyle(color: kWhite),)],):Icon(Icons.search,color:kPrimaryColor )
              ),
              label: ''
          ),
          BottomNavigationBarItem(

              icon: Container(
                  height: kBottomBarIconSize,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  // padding: EdgeInsets.all(8),
                  decoration:  BoxDecoration(
                    color: _selectedIndex==2?kPrimaryColor:Colors.transparent,
                    borderRadius:  BorderRadius.circular(20),
                  ),
                  child: _selectedIndex==2?Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [Icon(Icons.shopping_cart_outlined,color: _selectedIndex==2?Colors.white:kPrimaryColor,),Text(L10n.of(context).bcart,style:TextStyle(color: kWhite),)],):Icon(Icons.shopping_cart_outlined,color:kPrimaryColor )
              ),
              label: ''
          ),
          BottomNavigationBarItem(

              icon: Container(
                  height: kBottomBarIconSize,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  // padding: EdgeInsets.all(8),
                  decoration:  BoxDecoration(
                    color: _selectedIndex==3?kPrimaryColor:Colors.transparent,
                    borderRadius:  BorderRadius.circular(20),
                  ),
                  child: _selectedIndex==3?Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [Icon(Icons.person,color: _selectedIndex==3?Colors.white:kPrimaryColor,),Text(L10n.of(context).bprofile,style:TextStyle(color: kWhite),)],):Icon(Icons.person,color:kPrimaryColor )
              ),
              label: ''
          ),

        ],
        currentIndex: _selectedIndex,
        backgroundColor: Color.fromRGBO(235,235,235, 1),

        type: BottomNavigationBarType.fixed,
        //unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        //selectedItemColor: Theme.of(context).primaryColor,

        onTap: _onItemTapped,
      ),
    );
  }
}
