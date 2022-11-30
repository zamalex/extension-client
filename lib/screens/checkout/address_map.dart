import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:extension/blocs/search/search_bloc.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/data/models/location_model.dart';
import 'package:extension/data/models/search_session_model.dart';
import 'package:extension/generated/l10n.dart';
import 'package:extension/utils/async.dart';
import 'package:extension/utils/geo.dart';
import 'package:extension/widgets/location_list_item.dart';

class AddressMapScreen extends StatefulWidget {
  const AddressMapScreen({Key key, this.params}) : super(key: key);

  final Map<String, dynamic> params;
  @override
  _AddressMapScreenState createState() {
    return _AddressMapScreenState();
  }
}

class _AddressMapScreenState extends State<AddressMapScreen> {
  SearchBloc _searchBloc;
  List<LocationModel> _locations;
  CameraPosition _initialCameraPosition;

  LatLngBounds _currentRegion;
  bool _isLoading = false;
  String address = '';

  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  final Location _locationService = Location();

  @override
  void initState() {
    super.initState();



    /// LocationAccuracy.powerSave may cause infinite loops on Android
    /// while calling getLocation()
    _locationService.changeSettings(accuracy: LocationAccuracy.low);


      _initialCameraPosition = const CameraPosition(
        target: LatLng(kDefaultLat, kDefaultLon),
        zoom: 13,
        bearing: 30,
      );

  }


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: Container(
          //padding: const EdgeInsets.only(top: kPaddingM),
          child: FloatingActionButton(
            tooltip: L10n.of(context).searchTooltipBack,
            elevation: 3,
            onPressed: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              color: kPrimaryColor,
            ),
            backgroundColor: kWhite,
            mini: true,
          ),
        ),
        body: SafeArea(
          child:  Stack(
              alignment: Alignment.center,
              children: <Widget>[
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _mapController.complete(controller);

                  },
                  onCameraIdle: () async {
                    final GoogleMapController controller = await _mapController.future;
                    _currentRegion = await controller.getVisibleRegion();
                    LatLngBounds visibleRegion = await controller.getVisibleRegion();
                    LatLng centerLatLng = LatLng(
                      (visibleRegion.northeast.latitude + visibleRegion.southwest.latitude) / 2,
                      (visibleRegion.northeast.longitude + visibleRegion.southwest.longitude) / 2,
                    );
                    print("Latitude: ${centerLatLng.latitude}; Longitude: ${centerLatLng.longitude}");
                    setState(() {
                      address="Latitude: ${centerLatLng.latitude}; Longitude: ${centerLatLng.longitude}";
                    });
                  },
                  onCameraMove: (CameraPosition position) {
                  //  print("Latitude: ${position.target.latitude}; Longitude: ${position.target.longitude}");
                  },
                  mapType: MapType.normal,
                  initialCameraPosition: _initialCameraPosition,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: true,
                ),
                
               Container(child: Image.asset('assets/images/pin.png',height: 50,),margin: EdgeInsets.only(bottom: 25),)
                ,Positioned(child: Container(width:MediaQuery.of(context).size.width-20,height: 100,child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: [
                      Expanded(child: Text(address),),
                      SizedBox(width: 10,),
                      CircleAvatar(child: Icon(Icons.arrow_forward))
                    ],),
                  ),
                )),bottom: 10,)
              ],
            )
          ,
        ),
      ),
    );
  }
}
