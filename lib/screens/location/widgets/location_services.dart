import 'package:flutter/material.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/configs/routes.dart';
import 'package:extension/data/models/location_model.dart';
import 'package:extension/data/models/service_model.dart';
import 'package:extension/generated/l10n.dart';
import 'package:extension/model/share_data.dart';
import 'package:extension/widgets/link_text.dart';
import 'package:extension/widgets/list_item.dart';
import 'package:extension/widgets/strut_text.dart';
import 'package:extension/widgets/uppercase_title.dart';
import 'package:extension/utils/text_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprintf/sprintf.dart';
import 'package:extension/utils/list.dart';

import '../../../blocs/booking/booking_bloc.dart';
import '../../../data/models/booking_session_model.dart';
import '../../product_details_screen.dart';

class LocationServices extends StatefulWidget {
  const LocationServices({
    Key key,
    this.location,
    this.limit = 3,
    this.name,
    this.address
  }) : super(key: key);

  final LocationModel location;
  final int limit;
  final String name;
  final String address;

  @override
  State<LocationServices> createState() => _LocationServicesState();
}

class _LocationServicesState extends State<LocationServices> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    if (widget.location == null || widget.location.serviceGroups.isNullOrEmpty) {
      return Container();
    }
    widget.location.name = widget.name;
    widget.location.address = widget.address;
    List<ServiceModel> _services = widget.location.serviceGroups.first.services;
    print(widget.location.name);
    if (widget.limit < _services.length) {
      _services = _services.sublist(0, widget.limit);
    }


    return BlocBuilder<BookingBloc, BookingState>(
      builder: (BuildContext context, BookingState state) {
        final BookingSessionModel session = (state as SessionRefreshSuccessBookingState).session;

        return Container(
          padding: const EdgeInsets.only(left: kPaddingM, right: kPaddingM, bottom: kPaddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UppercaseTitle(title: L10n.of(context).locationTitleTopServices),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: kPaddingS),
                children: _services.map((ServiceModel service) {
                  return ListItem(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return ProductDetails(shareData: ShareData(salon: service.shop_id,product: service.id,type: 0));
                      },));
                    },
                    leading: Checkbox(
                      value: session.selectedServiceIds.contains(service.id),
                      onChanged: (bool isChecked) {
                        setState(() {
                          if (isChecked) {
                            context.read<BookingBloc>().add(ServiceSelectedBookingEvent(service: service));
                          } else {
                            context.read<BookingBloc>().add(ServiceUnselectedBookingEvent(service: service));
                          }
                        });
                      },
                    ),
                    title: service.name,
                    titleTextStyle: Theme.of(context).textTheme.subtitle1.fs18.w500.black,
                    subtitle: service.description,
                    subtitleTextStyle: Theme.of(context).textTheme.bodyText1.w300.copyWith(color: kPrimaryColor),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        StrutText(
                          L10n.of(context).commonCurrencyFormat(sprintf('%.2f', <double>[service.price])),
                          style: Theme.of(context).textTheme.subtitle1.fs18.w500.black,
                        ),
                        Text(!service.has_discount?'':service.base_price.toStringAsFixed(2),style:TextStyle(decoration: TextDecoration.lineThrough,fontSize: 12,color: Colors.red),),
                        StrutText(
                          L10n.of(context).commonDurationFormat(service.duration.toString()),
                          style: Theme.of(context).textTheme.bodyText1.w300.copyWith(color: kPrimaryColor),
                        ),
                      ],
                    ),
                    //  onPressed: () =>
                    //  Navigator.pushNamed(context, Routes.booking, arguments: <String, dynamic>{'locationId': location.id, 'preselectedService': service,'services':_services,'staff':location.staff,'location':location}),
                  );
                }).toList(),
              ),
              if (widget.limit < widget.location.serviceGroups.first.services.length)
                Padding(
                  padding: const EdgeInsets.only(top: kPaddingL),
                  child: LinkText(
                    text: L10n.of(context).locationLinkAllServices,
                    onTap: () => Navigator.pushNamed(context, Routes.booking, arguments: <String, dynamic>{'locationId': widget.location.id,'services':widget.location.serviceGroups.first.services,'staff':widget.location.staff,'location':widget.location}),
                  ),
                )
            ],
          ),
        );
      },
    );


  }
}
