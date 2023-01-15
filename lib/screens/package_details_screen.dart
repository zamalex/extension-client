import 'package:flutter/material.dart';
import 'package:extension/data/models/location_model.dart';
import 'package:extension/data/models/service_model.dart';
import 'package:extension/main.dart';
import 'package:extension/model/product_details_response.dart';
import 'package:extension/model/products_data.dart';
import 'package:extension/model/share_data.dart';
import 'package:extension/screens/location/location.dart';
import 'package:extension/screens/products/product_item.dart';
import 'package:extension/utils/geo.dart';
import 'package:share/share.dart';
import 'package:extension/generated/l10n.dart';
import 'package:extension/widgets/app_button.dart';
import 'package:extension/utils/text_style.dart';
import 'package:extension/widgets/strut_text.dart';
import 'package:extension/configs/app_globals.dart';

import '../configs/constants.dart';


class PackageDetails extends StatefulWidget {
  const PackageDetails({Key key,this.product,}) : super(key: key);
  final Product product;



  @override
  State<PackageDetails> createState() => _PackageDetailsState();
}

class _PackageDetailsState extends State<PackageDetails> {

  bool loading = false;

  List<Product> services=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ProductModel().getPackageDetails(widget.product.id).then((value){
      int duration=0;
      setState(() {
        services = value;
        services.forEach((element) {
          duration+=element.service_duration;
        });
        widget.product.service_duration=duration;
      });
    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:loading?Center(child: CircularProgressIndicator(),):Column(children:[
          Expanded(child: ListView(children: [

            widget.product.thumbnailImage==null||widget.product.thumbnailImage=='null'||widget.product.thumbnailImage.isEmpty?Image.asset('assets/images/onboarding/welcome.jpg',height: 200,width: double.infinity,fit: BoxFit.cover):Image.network(widget.product.thumbnailImage,height: 200,width: double.infinity,fit: BoxFit.cover,),
            SizedBox(height: 15,),
            Text(widget.product.name),
            Padding(padding: EdgeInsets.symmetric(horizontal: 5),child: Text(!widget.product.has_discount?'':widget.product.base_discounted_price.toStringAsFixed(2)+' ${L10n.of(context).SAR}',style:TextStyle(decoration: TextDecoration.lineThrough,fontSize: 12,color: Colors.red),))
            ,Padding(padding: EdgeInsets.symmetric(horizontal: 5),child: Text('${widget.product.basePrice} ${L10n.of(context).SAR}',style:TextStyle(fontSize: 12,),))

            , SizedBox(height: 15,),
            Text(widget.product.description),
            SizedBox(height: 15,),

            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return LocationScreen(tab: 0,locationId: LocationModel(false, widget.product.shop_id, '', 0, 0, '', '','','', '','', '','', [],GeoPoint(longitude: 0,latitude: 0),[], [], [], [], [], ''),);
                  },));
                },
                child: Text(widget.product.shop_name,style: TextStyle(fontWeight: FontWeight.bold,decoration: TextDecoration.underline),)),

            SizedBox(height: 15,),
            Column(
              children: services.map((e){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.name, style: TextStyle(color:Colors.black,fontSize: 18),),

                    Text(L10n.of(context).commonDurationFormat(e.service_duration.toString()), style: TextStyle(color:kPrimaryColor,fontSize: 12),)

                  ],
                );
              }).toList()
            )

          ],)),
          _bottomBar()
        ]),
      ),
    );
  }

  Widget _bottomBar() {

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
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        top: false,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  StrutText(
                    widget.product.basePrice,
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
                onPressed: () {

                  if (!getIt.get<AppGlobals>().isUser){
                    (getIt.get<AppGlobals>().globalKeyBottomBar.currentWidget as BottomNavigationBar)
                        .onTap(3);
                    Navigator.of(context).pop();
                    return;

                  }

                  Product e = widget.product;
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return LocationScreen(selectedPackage: ServiceModel.all(e.id,e.seller_id,e.shop_id,double.parse(e.basePrice.toString().replaceAll(RegExp(','), '')),e.service_duration,e.name,'',base_price: double.parse(e.basePrice),has_discount: e.has_discount),tab: 0,locationId: LocationModel(false, e.shop_id, '', 0, 0, '', '','','', '','', '','', [],GeoPoint(longitude: 0,latitude: 0),[], [], [], [], [], ''),);
                  },));

                }
            ),
          ],
        ),
      ),
    );
  }

}
