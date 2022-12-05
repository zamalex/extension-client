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


class ProductDetails extends StatefulWidget {
  const ProductDetails({Key key,this.cartModel,this.serviceModel,this.shareData}) : super(key: key);
 final Product cartModel;
 final ServiceModel serviceModel;
 final ShareData shareData;


  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

  List<Product> products=[];
  bool loading = false;
  ProductDetailsResponse productDetailsResponse;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loading= true;

    ProductDetailsResponse().getDetails(widget.shareData.product.toString()).then((value){
      productDetailsResponse = value;
      setState(() {
        loading = false;
      });
    });

    ProductModel().getRelatedProducts(widget.shareData.product).then((value){
      setState(() {
        value.forEach((element) {
          element.salon_id = widget.shareData.salon;
        });
        products=value??[];
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productDetailsResponse==null?'':productDetailsResponse.data.first.name),
        actions: [
        productDetailsResponse!=null? IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => Share.share('https://extensionclient.page.link/?link=https://extension.client.com?id%3D${productDetailsResponse.data.first.id}%26type%3D0%26salon%3D${productDetailsResponse.data.first.id}&apn=com.badee.extension_client&ibi=com.badee.extensionclient', subject: 'check this product from ${productDetailsResponse.data.first.shopName}'),
        ):Container()
      ],),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:loading?Center(child: CircularProgressIndicator(),): productDetailsResponse==null?Center(child: Text('no available data'),):ListView(children: [

          productDetailsResponse.data.first.thumbnailImage==null||productDetailsResponse.data.first.thumbnailImage=='null'||productDetailsResponse.data.first.thumbnailImage.isEmpty?Image.asset('assets/images/onboarding/welcome.jpg',height: 200,width: double.infinity,fit: BoxFit.cover):Image.network(productDetailsResponse.data.first.thumbnailImage,height: 200,width: double.infinity,fit: BoxFit.cover,),
          SizedBox(height: 15,),
          Text(productDetailsResponse==null?'':productDetailsResponse.data.first.name),
        Padding(padding: EdgeInsets.symmetric(horizontal: 5),child: Text(!productDetailsResponse.data.first.hasDiscount?'':productDetailsResponse.data.first.strokedPrice+' ${L10n.of(context).SAR}',style:TextStyle(decoration: TextDecoration.lineThrough,fontSize: 12,color: Colors.red),))
    ,Padding(padding: EdgeInsets.symmetric(horizontal: 5),child: Text('${productDetailsResponse.data.first.mainPrice} ${L10n.of(context).SAR}',style:TextStyle(fontSize: 12,),))

   , SizedBox(height: 15,),
            Text(productDetailsResponse==null?'':productDetailsResponse.data.first.description=='null'?'':productDetailsResponse.data.first.description),
          SizedBox(height: 15,),

          InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return LocationScreen(tab: shareData.type,locationId: LocationModel(false, productDetailsResponse.data.first.shopId, '', 0, 0, '', '','','', '','', '','', [],GeoPoint(longitude: 0,latitude: 0),[], [], [], [], [], ''),);
                },));
              },
              child: Text(productDetailsResponse==null?'':productDetailsResponse.data.first.shopName,style: TextStyle(fontWeight: FontWeight.bold,decoration: TextDecoration.underline),)),

          SizedBox(height: 15,),
          Container(
            width: double.infinity,
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Container(width:200,height: 200,child: ProdcutItem(products[index])),itemCount: products.length,),
          )

    ],),
      ),
    );
  }
}
