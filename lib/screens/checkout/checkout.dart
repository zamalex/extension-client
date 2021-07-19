import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/model/cart_provider.dart';
import 'package:salon/model/mycarts.dart';
import 'package:salon/screens/checkout/expand_address.dart';
import 'package:salon/screens/checkout/expand_copon.dart';
import 'package:salon/screens/checkout/expand_date.dart';
import 'package:salon/screens/checkout/expand_products.dart';

class Checkout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    if(Provider.of<CartProvider>(context,listen: false).allCarts.length>0)OrderSummary().getOrderSummary(Provider.of<CartProvider>(context).allCarts[0].ownerId).then((value){});


    return Scaffold(appBar: AppBar(title: Text('Checkout'),centerTitle: true,),
    body: Column(children: [
      Expanded(child: SingleChildScrollView(child: Container(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
        ExpandProducts(),
        ExpandAddress(),
        ExpandDate(),
        ExpandCopon(),

        Padding(padding: EdgeInsets.symmetric(horizontal: 10,),child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
          SizedBox(height: 10,),
          Text('Order summary',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),)
          ,SizedBox(height: 15,),
          Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
            Text('Total amount',style: TextStyle(color: Colors.black),),
            Text('15.00 SAR',style: TextStyle(color: Colors.black),),

          ],),

          SizedBox(height: 15,),
          Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
            Text('Coupon Code',style: TextStyle(color: Colors.black),),
            Text('15.00 SAR',style: TextStyle(color: Colors.black),),

          ],),

          SizedBox(height: 15,),
          Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
            Text('Delivery fees',style: TextStyle(color: Colors.black),),
            Text('15.00 SAR',style: TextStyle(color: Colors.black),),

          ],),

          SizedBox(height: 15,),
          Divider(color: Colors.grey,),
          SizedBox(height: 15,),
          Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
            Text('Total',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
            Text('15.00 SAR',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),


          ],),
          SizedBox(height: 20,),


        ],),),

      ],),),))
      , Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: SizedBox(height: 48,width: MediaQuery.of(context).size.width,child: ElevatedButton(child: Text('Confirm Order',style: TextStyle(color: Colors.white),)
        ,style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryColor)) ,),),),
      SizedBox(height: 10,),
    ],)
    );
  }
}
