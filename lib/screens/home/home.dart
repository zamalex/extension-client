import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salon/configs/app_globals.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/data/models/category_model.dart';
import 'package:salon/data/models/location_model.dart';
import 'package:salon/data/models/search_tab_model.dart';
import 'package:salon/data/repositories/location_repository.dart';
import 'package:salon/generated/l10n.dart';
import 'package:salon/main.dart';
import 'package:salon/model/banners_model.dart'as bann;
import 'package:salon/model/category.dart';
import 'package:salon/model/location_model.dart';
import 'package:salon/screens/home/widgets/category_list_item.dart';
import 'package:salon/screens/home/widgets/home_header.dart';
import 'package:salon/screens/search/search.dart';
import 'package:salon/screens/search/widgets/search_tabs.dart';
import 'package:salon/utils/bottom_bar_items.dart';
import 'package:salon/widgets/bold_title.dart';
import 'package:salon/widgets/locations_carousel.dart';
import 'package:salon/widgets/shimmer_box.dart';

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
  List<LocationModel> _topLocations;

  final LocationRepository locationRepository = const LocationRepository();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {

    bann.Banners().getBanners().then((value){setState(() {
      banners = value ?? [];
    });});

    CategoryData().getCategories().then((value){
      setState(() {
        categories=value.map((e){
          return CategoryModel(id: e.id,title: e.name,image: e.banner);
        }).toList();



      });
    });
    //_recentlyViewed = await locationRepository.getRecentlyViewed();
    SalonModel().getSalons().then((value){
      _recentlyViewed=value.map((e){
        return LocationModel(e.id, e.name, e.rating, 100, e.address, 'city', '545545545', 'email', 'website', 'description', 'assets/images/onboarding/welcome.png', 'genders', [], null, [], [], [], [], [], 'cancelationPolicy');
      }).toList();
      setState(() {

      });
    });
    if (mounted) {
      setState(() => _isDataLoaded = true);
    }
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
      title: 'Top rated salons',
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
                  _showRecentlyViewed(),
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
