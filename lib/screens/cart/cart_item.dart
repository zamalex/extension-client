import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/configs/app_globals.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/model/cart_model.dart';
import 'package:salon/model/cart_provider.dart';

import '../../main.dart';

class CartItem extends StatefulWidget {

  CartModel cartModel;
  CartItem(this.cartModel);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {

  CartProvider cartProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  //int count = 1;

  Widget _quantityButtons(){
    cartProvider = Provider.of<CartProvider>(context);
    return  Row(children: [GestureDetector(child: CircleAvatar(child: Text('-',style: TextStyle(color: Colors.white),),radius: 15,backgroundColor: Theme.of(context).accentColor,)
      ,onTap:(){
      cartProvider.removeItem(widget.cartModel);
      } ,),Container(child: Text(widget.cartModel.quantity.toString(),style: TextStyle(color: Theme.of(context).accentColor),),margin: EdgeInsets.symmetric(horizontal: 5),)
      ,GestureDetector(child: CircleAvatar(child: Text('+',style: TextStyle(color: Colors.white),),radius: 15,backgroundColor: Theme.of(context).accentColor,)
          ,onTap:(){
        cartProvider.addItem(widget.cartModel,context);
          } )],mainAxisSize: MainAxisSize.min,);
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(height:100,child: Card(color:Colors.white,child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
      Expanded(flex: 2,child: widget.cartModel.logo!=null&&widget.cartModel.logo.isNotEmpty?Image.network(widget.cartModel.logo,height: 100,fit: BoxFit.cover,):Image.asset('assets/images/onboarding/welcome.png',height: 100,fit: BoxFit.cover,)),
      SizedBox(width: 5,),
      Expanded(flex:2,child: Container(height: 100,child: Column(children: [
        Text(widget.cartModel.salon??'',overflow: TextOverflow.ellipsis,style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
        Container(child: Text(widget.cartModel.name,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),),
        Text('${widget.cartModel.price } ${kCurrency}',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)

      ],crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceEvenly,),)),
      Expanded(flex:3,child: Column(children: [
        _quantityButtons(),
        Text(getIt.get<AppGlobals>().isRTL?'الاجمالي ${widget.cartModel.quantity*widget.cartModel.price} ${kCurrency}':'Total ${(widget.cartModel.quantity*widget.cartModel.price).toStringAsFixed(2)} ${kCurrency}',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
      ],mainAxisAlignment: MainAxisAlignment.spaceEvenly,mainAxisSize: MainAxisSize.max,crossAxisAlignment: CrossAxisAlignment.end,),),
    SizedBox(width: 5,)],)

    ),);
  }
}
