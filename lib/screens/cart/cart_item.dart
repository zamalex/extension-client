import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/model/cart_model.dart';
import 'package:salon/model/cart_provider.dart';

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
        cartProvider.addItem(widget.cartModel);
          } )],mainAxisSize: MainAxisSize.min,);
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(height:100,child: Card(color:Colors.white,child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
      Expanded(flex: 2,child: Image.asset('assets/images/data/categories/barber-shop.jpg',height: 100,fit: BoxFit.cover,)),
      SizedBox(width: 5,),
      Expanded(flex:2,child: Container(height: 100,child: Column(children: [
        Text('Salon name',style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
        Container(child: Text('Product name  ',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),),
        Text('\$20.00',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)

      ],crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceEvenly,),)),
      Expanded(flex:3,child: Column(children: [
        _quantityButtons(),
        Text('Total 40.00 SAR',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
      ],mainAxisAlignment: MainAxisAlignment.spaceEvenly,mainAxisSize: MainAxisSize.max,crossAxisAlignment: CrossAxisAlignment.end,),),
    SizedBox(width: 5,)],)

    ),);
  }
}
