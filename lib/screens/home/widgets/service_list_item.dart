import 'package:flutter/material.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/configs/routes.dart';
import 'package:salon/data/models/category_model.dart';
import 'package:salon/data/models/location_model.dart';
import 'package:salon/model/products_data.dart';
import 'package:salon/screens/location/location.dart';
import 'package:salon/utils/geo.dart';
import 'package:salon/utils/text_style.dart';
import 'package:salon/widgets/strut_text.dart';

class ServiceListItem extends StatelessWidget {
  const ServiceListItem({
    Key key,
    this.category,
    this.tab=0
  }) : super(key: key);

  final Product category;
  final int tab;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        //Navigator.pushNamed(context, Routes.location, arguments: LocationModel(false, category.shop_id, 'unnamed', 0, 0, 'undefined', '','','', '','', '','', [],GeoPoint(longitude: 0,latitude: 0),[], [], [], [], [], ''));

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return LocationScreen(tab: tab,locationId: LocationModel(false, category.shop_id, 'unnamed', 0, 0, 'undefined', '','','', '','', '','', [],GeoPoint(longitude: 0,latitude: 0),[], [], [], [], [], ''),);
        },));

      },
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBoxDecorationRadius),
        ),
        margin: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(kBoxDecorationRadius)),
          ),
            child: Column(
              children: <Widget>[
                Container(
                  height: 90.0,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(kBoxDecorationRadius),
                      topRight: Radius.circular(kBoxDecorationRadius),
                    ),
                    image: DecorationImage(
                      image: category.thumbnailImage!='assets/images/onboarding/welcome.png'?NetworkImage(category.thumbnailImage,):category.salonImage!='assets/images/onboarding/welcome.png'?NetworkImage(category.salonImage,):AssetImage('assets/images/onboarding/welcome.png')as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: kPaddingS, left: kPaddingS, right: kPaddingS),
                  child: StrutText(
                    category.name,
                    maxLines: 1,
                    style: TextStyle(color: Colors.black,fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: kPaddingS, left: kPaddingS, right: kPaddingS),
                  child: StrutText(

                    category.shop_name??'',
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    style: TextStyle(color: Colors.black,fontSize: 14),
                  ),
                ),
              ],
            ),

        ),
      ),
    );
  }
}
