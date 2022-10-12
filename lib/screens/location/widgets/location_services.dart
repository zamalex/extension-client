import 'package:flutter/material.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/configs/routes.dart';
import 'package:salon/data/models/location_model.dart';
import 'package:salon/data/models/service_model.dart';
import 'package:salon/generated/l10n.dart';
import 'package:salon/model/share_data.dart';
import 'package:salon/widgets/link_text.dart';
import 'package:salon/widgets/list_item.dart';
import 'package:salon/widgets/strut_text.dart';
import 'package:salon/widgets/uppercase_title.dart';
import 'package:salon/utils/text_style.dart';
import 'package:sprintf/sprintf.dart';
import 'package:salon/utils/list.dart';

import '../../product_details_screen.dart';

class LocationServices extends StatelessWidget {
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
  Widget build(BuildContext context) {
    if (location == null || location.serviceGroups.isNullOrEmpty) {
      return Container();
    }
    location.name = name;
    location.address = address;
    List<ServiceModel> _services = location.serviceGroups.first.services;
    print(location.name);
    if (limit < _services.length) {
      _services = _services.sublist(0, limit);
    }

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
          if (limit < location.serviceGroups.first.services.length)
            Padding(
              padding: const EdgeInsets.only(top: kPaddingL),
              child: LinkText(
                text: L10n.of(context).locationLinkAllServices,
                onTap: () => Navigator.pushNamed(context, Routes.booking, arguments: <String, dynamic>{'locationId': location.id,'services':location.serviceGroups.first.services,'staff':location.staff,'location':location}),
              ),
            )
        ],
      ),
    );
  }
}
