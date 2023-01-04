import 'dart:io';

import 'package:extension/screens/home/widgets/package_list_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:extension/configs/app_globals.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/data/models/category_model.dart';
import 'package:extension/data/models/location_model.dart';
import 'package:extension/data/models/search_tab_model.dart';
import 'package:extension/generated/l10n.dart';
import 'package:extension/main.dart';
import 'package:extension/model/banners_model.dart'as bann;
import 'package:extension/model/category.dart';
import 'package:extension/model/location_model.dart';
import 'package:extension/model/products_data.dart';
import 'package:extension/screens/home/widgets/category_list_item.dart';
import 'package:extension/screens/home/widgets/home_header.dart';
import 'package:extension/screens/home/widgets/service_list_item.dart';
import 'package:extension/screens/location/location.dart';
import 'package:extension/screens/product_details_screen.dart';
import 'package:extension/screens/search/search.dart';
import 'package:extension/screens/search/widgets/search_tabs.dart';
import 'package:extension/utils/bottom_bar_items.dart';
import 'package:extension/utils/geo.dart';
import 'package:extension/utils/ui.dart';
import 'package:extension/widgets/bold_title.dart';
import 'package:extension/widgets/locations_carousel.dart';
import 'package:extension/widgets/shimmer_box.dart';
import 'package:url_launcher/url_launcher.dart';

import '../package_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool _isDataLoaded = false;

  List<LocationModel> _recentlyViewed;
  List<CategoryModel> categories=[];
  List<bann.Banner> banners=[];
  List<Product> services=[];
  List<Product> products=[];
  List<LocationModel> _topLocations;



  /// check if there is an update
  checkUpdate()async{

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    String ref = 'android';
    if(Platform.isAndroid)
      ref='android';
    else
      ref='ios';
    FirebaseDatabase.instance.reference().child(ref).once().then((value){
      print('newest is ${value.snapshot.value}');
      print('current is ${buildNumber}');
      if(value==null)
        return;
      int newest = int.parse(value.snapshot.value.toString());

      if(newest>int.parse(buildNumber)){
        UI.showCustomDialog(context,title: 'New version available',message: 'Please Update to the Latest Version', actions: [ElevatedButton(style:  ElevatedButton.styleFrom(
          primary: kPrimaryColor,
        ),onPressed:(){

          if (Platform.isAndroid) {
            launch("https://play.google.com/store/apps/details?id=$packageName");
          } else if (Platform.isIOS) {
            launch("market://details?id=$packageName");
          }
        }, child: Text('Update',style: TextStyle(color: Colors.white),))]);
      }

    });

  }
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    Future.delayed(Duration.zero).then((value){
      try{

        checkUpdate();
       // final newVersion = NewVersion(context: context);

       // newVersion.showAlertIfNecessary();

        //print(newVersion.iOSId??'');

      }catch(e){}
    });
    checkLink();

    _loadData();
  }


  /// open product details screen if opened from dynamic linkn
  checkLink()async{
    final PendingDynamicLinkData initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
    // FirebaseCrashlytics.instance.crash();

    if (initialLink != null) {
      final Uri deepLink = initialLink.link;
      // Example of using the dynamic link to push the user to a different screen
      print('dynamic link iss ${deepLink.toString()} and id is ${deepLink.queryParameters['salon']}');

      shareData.product=int.parse(deepLink.queryParameters['id']);
      shareData.type=int.parse(deepLink.queryParameters['type']);
      shareData.salon=int.parse(deepLink.queryParameters['salon']);
      goToSalon();
    }
    FirebaseDynamicLinks.instance.onLink.listen((dynamic)async{
      print('dynamic link is ${dynamic.link.toString()} and id is ${dynamic.link.queryParameters['salon']}');
      shareData.product=int.parse(dynamic.link.queryParameters['id']);
      shareData.type=int.parse(dynamic.link.queryParameters['type']);
      shareData.salon=int.parse(dynamic.link.queryParameters['salon']);

      goToSalon();
    },onError: (error)async{});


  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  /// load banner , salons, categories and products
  Future<void> _loadData() async {


    bann.Banners().getBanners().then((value){setState(() {
      banners = value ?? [];
    });});


    ProductModel().getTopServices(0).then((value){setState(() {
      services = value ?? [];
    });});

    ProductModel().getTopProducts().then((value){setState(() {
      products = value ?? [];
    });});

    CategoryData().getCategories().then((value){
      setState(() {
        categories=value.map((e){
          return CategoryModel(id: e.id,title: e.name,image: e.banner);
        }).toList();



      });
    });
    SalonModel().getSalons().then((value){
      _recentlyViewed=value.map((e){
        return LocationModel(e.offer,e.id, e.name, e.rating, 100, e.address, 'city', '545545545', 'email', 'website', 'description', e.logo, 'genders', [], null, [], [], [], [], [], 'cancelationPolicy');
      }).toList();
      setState(() {
print('salon ${shareData.salon}');

      });
    });
    if (mounted) {
      setState(() => _isDataLoaded = true);
    }

  }

  goToSalon(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return ProductDetails(shareData: shareData,);
    },));

    shareData.salon=0;
  }

  Widget _showCategories() {
    return Container(
      height: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          BoldTitle(title: L10n.of(context).homeTitlePopularCategories),
          Container(
            height: 130,
            child: _isDataLoaded
                ? ListView(
                    padding: const EdgeInsetsDirectional.only(start: kPaddingM),
                    scrollDirection: Axis.horizontal,
                    children: categories.map((CategoryModel category) {
                      return Container(
                        width: 160,
                        margin: const EdgeInsets.only(bottom: 1), // for card shadow
                        padding: const EdgeInsetsDirectional.only(end: kPaddingS),
                        child: CategoryListItem(
                          category: category,
                          onTap: (){

                            _scrollToTabItem(category);
                          },
                        ),
                      );
                    }).toList(),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsetsDirectional.only(start: kPaddingM),
                    itemBuilder: (BuildContext context, int index) => const ShimmerBox(width: 160, height: 130),
                    itemCount: List<int>.generate(3, (int index) => index).length,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _showPackages() {
    return Container(
      height: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          BoldTitle(title: L10n.of(context).homeTitlePopularCategories),
          Container(
            height: 130,
            child: _isDataLoaded
                ? ListView(
              padding: const EdgeInsetsDirectional.only(start: kPaddingM),
              scrollDirection: Axis.horizontal,
              children: services.map((Product category) {
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(bottom: 1), // for card shadow
                  padding: const EdgeInsetsDirectional.only(end: kPaddingS),
                  child: PackageListItem(
                    product: category,
                    onTap: (){

                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return PackageDetails(product: category);
                      },));
                    },
                  ),
                );
              }).toList(),
            )
                : ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsetsDirectional.only(start: kPaddingM),
              itemBuilder: (BuildContext context, int index) => const ShimmerBox(width: 160, height: 130),
              itemCount: List<int>.generate(3, (int index) => index).length,
            ),
          ),
        ],
      ),
    );
  }



  Future<void> _scrollToTabItem(CategoryModel category) async {
    // Tap on the explore icon in the bottom bar.
    (getIt.get<AppGlobals>().globalKeyBottomBar.currentWidget as BottomNavigationBar).onTap(getIt.get<BottomBarItems>().getBottomBarItem('explore'));

    final SearchScreenState searchScreenState = getIt.get<AppGlobals>().globalKeySearchScreen.currentState as SearchScreenState;

    final List<SearchTabModel> catTabs = searchScreenState.categoryTabs;
    final int index = catTabs.indexWhere((SearchTabModel tab) => tab.id == category.id);

    if (index != -1) {
      // Scroll to the element.
      (getIt.get<AppGlobals>().globalKeySearchTabs.currentState as SearchTabsState)
          .itemScrollController
          .scrollTo(index: index, duration: const Duration(milliseconds: 100));

      // Wait for the scroll to finish.
      await Future<int>.delayed(const Duration(milliseconds: 200));

      // Tap on tab item.
      (searchScreenState.categoryTabs[index].globalKey.currentWidget as InkWell).onTap();

      (getIt.get<AppGlobals>().globalKeyBottomBar.currentWidget as BottomNavigationBar)
          .onTap(1);
    }
  }

  Widget _showRecentlyViewed() {
    return LocationsCarousel(
      locations: _recentlyViewed,
      title: L10n.of(context).topRatedSalonz,
    );
  }

  Widget _showTopServices() {
    return Container(
      height: 270,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          BoldTitle(title: L10n.of(context).locationTitleTopServices),
          Container(
            height: 170,
            child: _isDataLoaded
                ? ListView(
              padding: const EdgeInsetsDirectional.only(start: kPaddingM),
              scrollDirection: Axis.horizontal,
              children: services.map((Product category) {
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(bottom: 1), // for card shadow
                  padding: const EdgeInsetsDirectional.only(end: kPaddingS),
                  child: ServiceListItem(
                    category: category,
                  ),
                );
              }).toList(),
            )
                : ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsetsDirectional.only(start: kPaddingM),
              itemBuilder: (BuildContext context, int index) => const ShimmerBox(width: 160, height: 130),
              itemCount: List<int>.generate(3, (int index) => index).length,
            ),
          ),
        ],
      ),
    );
  }



  Widget _showTopProducts() {
    return Container(
      height: 270,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          BoldTitle(title: L10n.of(context).locationTitleTopProducts),
          Container(
            height: 170,
            child: _isDataLoaded
                ? ListView(
              padding: const EdgeInsetsDirectional.only(start: kPaddingM),
              scrollDirection: Axis.horizontal,
              children: products.map((Product category) {
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(bottom: 1), // for card shadow
                  padding: const EdgeInsetsDirectional.only(end: kPaddingS),
                  child: ServiceListItem(
                    category: category,
                    tab: 1,
                  ),
                );
              }).toList(),
            )
                : ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsetsDirectional.only(start: kPaddingM),
              itemBuilder: (BuildContext context, int index) => const ShimmerBox(width: 160, height: 130),
              itemCount: List<int>.generate(3, (int index) => index).length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _showTopRatedSalons() {
    return LocationsCarousel(
      locations: _recentlyViewed,
      title: L10n.of(context).homeTitleTopRated,
      onNavigate: () {
        (getIt.get<AppGlobals>().globalKeyBottomBar.currentWidget as BottomNavigationBar).onTap(getIt.get<BottomBarItems>().getBottomBarItem('explore'));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('width is ${MediaQuery.of(context).size.width}');
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              delegate: HomeHeader(expandedHeight: 260,banners: banners),
              pinned: false,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  _showCategories(),
                  //_showPackages(),
                  _showRecentlyViewed(),
                 _showTopServices(),
                 _showTopProducts(),
                 // _showTopRatedSalons(),
                  const Padding(padding: EdgeInsets.only(bottom: kPaddingL)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
