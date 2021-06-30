import 'dart:async';

import 'package:flutter/material.dart';
import 'package:salon/configs/app_globals.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/configs/routes.dart';
import 'package:salon/data/models/location_model.dart';
import 'package:salon/data/repositories/location_repository.dart';
import 'package:salon/generated/l10n.dart';
import 'package:salon/main.dart';
import 'package:salon/screens/location/widgets/widgets.dart';
import 'package:salon/screens/products/products_list.dart';
import 'package:salon/widgets/app_button.dart';
import 'package:salon/widgets/sliver_app_title.dart';
import 'package:salon/utils/text_style.dart';
import 'package:salon/widgets/strut_text.dart';
import 'package:share/share.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({
    Key key,
    this.locationId = 0,
  }) : super(key: key);

  final int locationId;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final LocationRepository locationRepository = const LocationRepository();

  /// The GlobalKey needed to access Scaffold widget.
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final mGrey = const Color.fromRGBO(118 ,123 ,128, 1);

  LocationModel _location;

  bool _isFavorited = false;
  int selected = 0;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    /// Load location data.
    _location = await locationRepository.getLocation(id: widget.locationId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.locationId > 0) {
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
                    expandedHeight: 200.0,
                    pinned: true,
                    actions: _location != null
                        ? <Widget>[
                            IconButton(
                              icon: const Icon(Icons.share),
                              onPressed: () => Share.share(_location.website, subject: _location.name),
                            ),
                            IconButton(
                              icon: Icon(_isFavorited ? Icons.favorite : Icons.favorite_border),
                              onPressed: () {
                                setState(() => _isFavorited = !_isFavorited);
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(_isFavorited ? L10n.of(context).commonLocationFavorited : L10n.of(context).commonLocationUnfavorited),
                                  duration: const Duration(milliseconds: kSnackBarDurationShort),
                                ));
                              }, //_onLocation,
                            ),
                          ]
                        : null,
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
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: StrutText(
                              'The Barbery',
                              maxLines: 2,
                              style: Theme.of(context).textTheme.headline5.w800.black,
                              overflow: TextOverflow.ellipsis,
                            ),),
                            Padding(
                              padding: const EdgeInsets.only(left:10,right:10,top: kPaddingS),
                              child: StrutText(
                                'Askan Building 17, Al Olaya, Riyadh',
                                maxLines: 2,
                                style: Theme.of(context).textTheme.subtitle1.copyWith(color: kPrimaryColor),
                              ),
                            ),
                            SizedBox(height: 15,),
                            DefaultTabController(length: 2, child: TabBar(tabs: [

                              Container(child: Text('Details',style: TextStyle(color: selected==0?kWhite:kPrimaryColor),)
                                ,height: 40,alignment: Alignment.center,color: selected==1?kTransparent:mGrey),
                              Container(child: Text('Products',style: TextStyle(color: selected==0?kPrimaryColor:kWhite),)
                                ,height: 40,alignment: Alignment.center,color: selected==0?kTransparent:mGrey,),
                            ],
                              labelColor: kPrimaryColor,
                              indicatorColor: kTransparent,
                              onTap: (i){
                                setState(() {
                                  selected = i;
                                });
                              },
                            ),
                            ),

                            if(selected==1)
                             SingleChildScrollView(child:  ProductsList(),)
                            else
                              Column(children: [
                                LocationInfo(location: _location),

                                LocationMapPreview(coordinates: _location != null ? _location.coordinates : null),
                                // LocationDescription(description: _location != null ? _location.description : null),
                                LocationStaff(location: _location),
                                LocationServices(location: _location),
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
              text: L10n.of(context).locationBtnBook,
              onPressed: () => Navigator.pushNamed(context, Routes.booking, arguments: <String, dynamic>{'locationId': _location.id}),
            ),
          ],
        ),
      ),
    );
  }
}
