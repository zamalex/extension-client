import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/blocs/theme/theme_bloc.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/model/cart_model.dart';
import 'package:salon/model/cart_provider.dart';
import 'package:salon/screens/cart/cart_item.dart';

class ProdcutItem extends StatefulWidget {
  CartModel cartModel;
  ProdcutItem(this.cartModel);

  @override
  _ProdcutItemState createState() => _ProdcutItemState();
}


class _ProdcutItemState extends State<ProdcutItem> {
  int count = 0;
 // CartProvider cartProvider;



  Widget _quantityButtons(){
    return  Row(children: [GestureDetector(child: CircleAvatar(child: Text('-',style: TextStyle(color: Colors.white),),radius: 15,backgroundColor: Theme.of(context).accentColor,)
      ,onTap:(){
      Provider.of<CartProvider>(context,listen: false).removeItem(widget.cartModel);
      } ,),Container(child: Text(widget.cartModel.quantity.toString(),style: TextStyle(color: Theme.of(context).accentColor),),margin: EdgeInsets.symmetric(horizontal: 5),)
      ,GestureDetector(child: CircleAvatar(child: Text('+',style: TextStyle(color: Colors.white),),radius: 15,backgroundColor: Theme.of(context).accentColor,)
          ,onTap:(){Provider.of<CartProvider>(context,listen: false).addItem(widget.cartModel);} )],mainAxisSize: MainAxisSize.min,);
  }

  @override
  Widget build(BuildContext context) {
    return Card(color: Colors.white,child: Column(children: [
      Image.asset('assets/images/data/categories/barber-shop.jpg',height: 120,),
      Padding(padding: EdgeInsets.symmetric(horizontal: 5),child: SingleChildScrollView(scrollDirection: Axis.horizontal,child: Text('product name',maxLines: 1,style: TextStyle(color: Colors.grey)),),)
      ,Expanded(child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,

        children: [
          Expanded(child: Padding(padding: EdgeInsets.all(5),child: FittedBox(fit: BoxFit.scaleDown,alignment: Alignment.centerLeft,child: Text('15.00\$',style: TextStyle(color: Colors.black,),),),)),
          widget.cartModel.quantity==0?GestureDetector(child: CircleAvatar(radius: 15,backgroundColor: Theme.of(context).accentColor,child: Icon(Icons.shopping_cart,color: Colors.white,size: 15,),)
            ,onTap:(){Provider.of<CartProvider>(context,listen: false).addItem(widget.cartModel);} ,):FittedBox(child: _quantityButtons(),),
        ],
      ))
    ],crossAxisAlignment: CrossAxisAlignment.start,),);
  }


}
