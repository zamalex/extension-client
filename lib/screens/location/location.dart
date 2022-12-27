import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:extension/blocs/application/application_bloc.dart';
import 'package:extension/configs/app_globals.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/configs/routes.dart';
import 'package:extension/data/models/business_hours_model.dart';
import 'package:extension/data/models/location_model.dart';
import 'package:extension/data/models/review_model.dart';
import 'package:extension/data/models/service_group_model.dart';
import 'package:extension/data/models/service_model.dart';
import 'package:extension/data/models/staff_model.dart';
import 'package:extension/generated/l10n.dart';
import 'package:extension/main.dart';
import 'package:extension/model/booking_week.dart';
import 'package:extension/model/cart_provider.dart';
import 'package:extension/model/fav_model.dart';
import 'package:extension/model/location_model.dart';
import 'package:extension/model/my_reviews.dart';
import 'package:extension/model/products_data.dart';
import 'package:extension/model/staff_data.dart';
import 'package:extension/screens/location/widgets/widgets.dart';
import 'package:extension/screens/product_details_screen.dart';
import 'package:extension/screens/products/products_list.dart';
import 'package:extension/utils/geo.dart';
import 'package:extension/widgets/app_button.dart';
import 'package:extension/widgets/bottom_navigation.dart';
import 'package:extension/widgets/sliver_app_title.dart';
import 'package:extension/utils/text_style.dart';
import 'package:extension/widgets/strut_text.dart';
import 'package:share/share.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({
    Key key,
    this.namedLocation,
    this.locationId ,
    this.tab=0
  }) : super(key: key);
  final namedLocation;
  final LocationModel locationId;
  final int tab;
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  /// The GlobalKey needed to access Scaffold widget.
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final mGrey = kPrimaryColor;
  var locationBlock;

  LocationModel _location;
  List<ServiceModel> services = [];
  List<ReviewModel> reviews = [];
  List<SingleStaff> staff = [];
  List<StaffModel> staffModel = [];
  bool _isFavorited = false;
  int selected = 0;
  @override
  void initState() {
    super.initState();

    _loadData();

    if(widget.tab!=0)
      selected=widget.tab;
    getIt.get<AppGlobals>().serviceIndex=selected;

  }

  Future<void> _loadData() async {
    /// Load location data.
    await  SalonModel().getSalonData(widget.locationId.id.toString()).then((value){
      if(value.isNotEmpty){
        _location=  LocationModel(value[0].offer,value[0].id, value[0].name, value[0].rating, 100, value[0].address, '', value[0].phone.toString(), 'email', 'website', 'description', value[0].logo, 'genders', [], GeoPoint(latitude: double.parse(value[0].latitude),longitude: double.parse(value[0].longitude)), [], [], [], [], [], 'cancelationPolicy')..setPaymentStatus(value[0].payment_status);
        widget.locationId.mainPhoto = _location.mainPhoto;
        widget.locationId.name = _location.name;
        widget.locationId.address = _location.address;
        widget.locationId.payment_status = _location.payment_status;
        _isFavorited = value[0].isFavourite;
        setState(() {

        });
      }
    });
    // _location = await locationRepository.getLocation(id: widget.locationId.id);

    _location.reviews = [];
    _location.businessHours = [];
    _location.staff = [];


    setState(() {});

    BookingWeekTimes().getWeekTimes(widget.locationId.id.toString()).then((value){
      _location.businessHours = value.map((e) => BusinessHoursModel(e.day, e.startTime, e.endTime)).toList();
    });

    ProductModel().getServices(widget.locationId.id).then((value){
      setState(() {
        services = value.map((e){
          return ServiceModel.all(e.id,e.seller_id,e.shop_id,double.parse(e.base_discounted_price.toString().replaceAll(RegExp(','), '')),e.service_duration,e.name,'',base_price: double.parse(e.basePrice),has_discount: e.has_discount);
        }).toList();


        _location.serviceGroups=[];
        _location.serviceGroups.add(ServiceGroupModel(getIt.get<AppGlobals>().isRTL?'الخدمات':'Top services', '', services));


      });
    });

    MyReviews().getSalonReviews(widget.locationId.id.toString()).then((value) {

      setState(() {
        reviews = value;

        // _location.reviews=[];
        _location.reviews = value;


      });


    });

    SalonStaff().getSalonStaff(widget.locationId.id.toString()).then((value) {

      setState(() {
        staff = value;

        // _location.reviews=[];
        _location.staff = value.map((e) {
          return StaffModel(e.id, e.name, e.jobTitle, e.avatarOriginal, e.rating, true);

        }).toList();
        staffModel=_location.staff;
      });


    });
  }


  @override
  Widget build(BuildContext context) {
    /* if(Provider.of<CartProvider>(context).error.isNotEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Provider.of<CartProvider>(context).error)));
    }*/
    if (widget.locationId.id > 0) {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: kScaffold,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: CustomScrollView(
                scrollDirection: Axis.vertical,
                slivers: <Widget>[
                  SliverAppBar(

                    leading:  Container(
                      margin: const EdgeInsetsDirectional.only(end: 10,start: 10, bottom: kPaddingS),
                      decoration: ShapeDecoration(
                        color: Theme.of(context).accentColor,
                        shape: const CircleBorder(),

                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_outlined),
                        color: kWhite,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    expandedHeight: 200.0,
                    pinned: true,
                    /*actions: _location != null
                        ? <Widget>[
                      /*IconButton(
                              icon: const Icon(Icons.share),
                              onPressed: () => Share.share(_location.website, subject: _location.name),
                            ),*/
                       IconButton(
                              icon: Icon(_isFavorited ? Icons.favorite : Icons.favorite_border),
                              onPressed: () {
                                FavModel().addRemoveFav(widget.locationId.id.toString());
                                setState(() => _isFavorited = !_isFavorited);
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(_isFavorited ? L10n.of(context).commonLocationFavorited : L10n.of(context).commonLocationUnfavorited),
                                  duration: const Duration(milliseconds: kSnackBarDurationShort),
                                ));
                              }, //_onLocation,
                            ),
                    ]
                        : null,*/
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: LocationHeader(location: _location),
                    ),
                    title: _location != null ? SliverAppTitle(child: Text(_location.name)) : Container(),
                  ),
                  SliverToBoxAdapter(
                    child: SafeArea(
                      top: false,
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.only(top: kPaddingM),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: StrutText(
                                    _location==null?'':_location.name??'',
                                    maxLines: 2,
                                    style: Theme.of(context).textTheme.headline5.w800.black,
                                    overflow: TextOverflow.ellipsis,
                                  ),),
                                ),

                               IconButton(
                                  color: kPrimaryColor,
                                  icon: Icon(_isFavorited ? Icons.favorite : Icons.favorite_border),
                                  onPressed: () {
                                    FavModel().addRemoveFav(widget.locationId.id.toString());
                                    setState(() => _isFavorited = !_isFavorited);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text(_isFavorited ? L10n.of(context).commonLocationFavorited : L10n.of(context).commonLocationUnfavorited),
                                      duration: const Duration(milliseconds: kSnackBarDurationShort),
                                    ));
                                  }, //_onLocation,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:10,right:10,top: kPaddingS),
                              child: StrutText(
                                _location==null?'':_location.address??'',
                                maxLines: 2,
                                style: Theme.of(context).textTheme.subtitle1.copyWith(color: kPrimaryColor),
                              ),
                            ),
                            SizedBox(height: 15,),
                            DefaultTabController(length: 2,child: TabBar(tabs: [

                              Container(child: Text(getIt.get<AppGlobals>().isRTL?'الخدمات':'Services',style: TextStyle(color: selected==0?kWhite:kPrimaryColor),)
                                  ,height: 40,alignment: Alignment.center,color: selected==1?mGrey.withOpacity(.3):mGrey),
                              Container(child: Text(getIt.get<AppGlobals>().isRTL?'المنتجات':'Products',style: TextStyle(color: selected==0?kPrimaryColor:kWhite),)
                                ,height: 40,alignment: Alignment.center,color: selected==0?mGrey.withOpacity(.3):mGrey,),
                            ],

                              labelColor: kPrimaryColor,
                              indicatorColor: kTransparent,
                              onTap: (i){
                                setState(() {
                                  selected = i;

                                  selected==1?getIt.get<AppGlobals>().serviceIndex=1:getIt.get<AppGlobals>().serviceIndex=0;
                                });
                              },
                            ),
                            ),

                            if(selected==1)
                              SingleChildScrollView(child:  ProductsList(widget.locationId.id),)
                            else
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LocationServices(location: _location,address: widget.locationId.address,name: widget.locationId.name,),

                                  LocationInfo(location: _location),

                                  LocationMapPreview(coordinates: _location != null ? _location.coordinates : null),
                                  LocationStaff(location: _location),
                                  LocationReviews(location: _location),
                                ],)

                            //   LocationsNearby(nearbyLocations: _location != null ? _location.nearbyLocations : null)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _bottomBar(),
          ],
        ),
      );
    } else
      return Container();
  }

  Widget _bottomBar() {
    if (_location == null) {
      return Container();
    }

    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(235 ,235 ,235, 1),
        border: Border(
          top: BorderSide(
            width: 2,
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      padding: const EdgeInsets.all(kPaddingM),
      child: SafeArea(
        top: false,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  StrutText(
                    L10n.of(context).locationAvailableServies(_location.getServiceCount),
                    style: Theme.of(context).textTheme.subtitle1.primaryColor,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 4)),
                  StrutText(
                    L10n.of(context).locationInstantConfirmation,
                    style: Theme.of(context).textTheme.subtitle1.bold.black,
                  ),
                ],
              ),
            ),

            AppButton(
                text: getIt.get<AppGlobals>().serviceIndex==1?(getIt.get<AppGlobals>().isRTL?'السلة':'cart'):L10n.of(context).locationBtnBook,
                onPressed: () {
                  if (!getIt.get<AppGlobals>().isUser){


                    (getIt.get<AppGlobals>().globalKeyBottomBar.currentWidget as BottomNavigationBar)
                        .onTap(3);
                    Navigator.of(context, rootNavigator: true).pop();

                    // (getIt.get<AppGlobals>().globalKeyBottomBar.currentWidget as BottomNavigationBar).onTap(2);

                    return;}

                  if(getIt.get<AppGlobals>().serviceIndex==1){
                    (getIt.get<AppGlobals>().globalKeyBottomBar.currentWidget as BottomNavigationBar)
                        .onTap(2);
                    Navigator.of(context, rootNavigator: true).pop();
                  }else{
                    Navigator.pushNamed(context, Routes.booking, arguments: <String, dynamic>{'locationId': _location.id,'staff': staffModel,'location':widget.locationId,'services':services});}

                }
            ),
          ],
        ),
      ),
    );
  }
}
