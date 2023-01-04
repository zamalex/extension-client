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


class PackageDetails extends StatefulWidget {
  const PackageDetails({Key key,this.product,}) : super(key: key);
  final Product product;



  @override
  State<PackageDetails> createState() => _PackageDetailsState();
}

class _PackageDetailsState extends State<PackageDetails> {

  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:loading?Center(child: CircularProgressIndicator(),):ListView(children: [

          widget.product.thumbnailImage==null||widget.product.thumbnailImage=='null'||widget.product.thumbnailImage.isEmpty?Image.asset('assets/images/onboarding/welcome.jpg',height: 200,width: double.infinity,fit: BoxFit.cover):Image.network(widget.product.thumbnailImage,height: 200,width: double.infinity,fit: BoxFit.cover,),
          SizedBox(height: 15,),
          Text(widget.product.name),
          Padding(padding: EdgeInsets.symmetric(horizontal: 5),child: Text(!widget.product.has_discount?'':widget.product.base_discounted_price.toStringAsFixed(2)+' ${L10n.of(context).SAR}',style:TextStyle(decoration: TextDecoration.lineThrough,fontSize: 12,color: Colors.red),))
          ,Padding(padding: EdgeInsets.symmetric(horizontal: 5),child: Text('${widget.product.basePrice} ${L10n.of(context).SAR}',style:TextStyle(fontSize: 12,),))

          , SizedBox(height: 15,),
          Text('description'),
          SizedBox(height: 15,),

          InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return LocationScreen(tab: 0,locationId: LocationModel(false, widget.product.shop_id, '', 0, 0, '', '','','', '','', '','', [],GeoPoint(longitude: 0,latitude: 0),[], [], [], [], [], ''),);
                },));
              },
              child: Text(widget.product.shop_name,style: TextStyle(fontWeight: FontWeight.bold,decoration: TextDecoration.underline),)),

          SizedBox(height: 15,),


        ],),
      ),
    );
  }
}
