import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/blocs/theme/theme_bloc.dart';
import 'package:salon/configs/app_globals.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/main.dart';
import 'package:salon/model/cart_model.dart';
import 'package:salon/model/cart_provider.dart';
import 'package:salon/model/products_data.dart';
import 'package:salon/screens/cart/cart_item.dart';
import 'package:salon/screens/profile/profile.dart';
import 'package:salon/screens/sign_in.dart';
import 'package:salon/widgets/bottom_navigation.dart';

class ProdcutItem extends StatefulWidget {
  Product cartModel;
  ProdcutItem(this.cartModel);

  @override
  _ProdcutItemState createState() => _ProdcutItemState();
}


class _ProdcutItemState extends State<ProdcutItem> {
  int count = 0;
 // CartProvider cartProvider;



  Widget _quantityButtons(){
    return  Consumer<CartProvider>(
      builder: (c,b,a){
       return b.isLoading? Text('loading'):  Row(children: [GestureDetector(child: CircleAvatar(child: Text('-',style: TextStyle(color: Colors.white),),radius: 15,backgroundColor: Theme.of(context).accentColor,)
          ,onTap:(){
            Provider.of<CartProvider>(context,listen: false).removeItem(CartModel(logo: widget.cartModel.thumbnailImage,
                id:widget.cartModel.id,name: widget.cartModel.name,salon: 'Barber',quantity: 1,price:200
            ));
          } ,),Container(child: Text(Provider.of<CartProvider>(context).itemCount(widget.cartModel.id).toString(),style: TextStyle(color: Theme.of(context).accentColor),),margin: EdgeInsets.symmetric(horizontal: 5),)
          ,GestureDetector(child: CircleAvatar(child: Text('+',style: TextStyle(color: Colors.white),),radius: 15,backgroundColor: Theme.of(context).accentColor,)
              ,onTap:(){Provider.of<CartProvider>(context,listen: false).addItem(CartModel(logo: widget.cartModel.thumbnailImage
                  ,id:widget.cartModel.id,name: widget.cartModel.name,salon: 'Barber',quantity: 1,price:200
              ),context);} )],mainAxisSize: MainAxisSize.min,);
      },

    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(color: Colors.white,child: Column(children: [
      widget.cartModel.thumbnailImage=='assets/images/onboarding/welcome.png'?Image.asset(widget.cartModel.thumbnailImage,height: 120,fit: BoxFit.cover,width: MediaQuery.of(context).size.width,):Image.network(widget.cartModel.thumbnailImage,height: 120,fit: BoxFit.cover,width: MediaQuery.of(context).size.width,)
      ,Padding(padding: EdgeInsets.symmetric(horizontal: 5),child: SingleChildScrollView(scrollDirection: Axis.horizontal,child: Text(widget.cartModel.name,maxLines: 1,style: TextStyle(color: Colors.grey)),),)
      ,Expanded(child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,

        children: [
          Expanded(child: Padding(padding: EdgeInsets.all(5),child: FittedBox(fit: BoxFit.scaleDown,alignment: Alignment.centerLeft,child: Text('${widget.cartModel.basePrice}',style: TextStyle(color: Colors.black,),),),)),
          Provider.of<CartProvider>(context).itemCount(widget.cartModel.id)==0?GestureDetector(child: CircleAvatar(radius: 15,backgroundColor: Theme.of(context).accentColor,child: Icon(Icons.shopping_cart,color: Colors.white,size: 15,),)
            ,onTap:(){
            if (!getIt.get<AppGlobals>().isUser){

                   (getIt.get<AppGlobals>().globalKeyBottomBar.currentWidget as BottomNavigationBar).onTap(3);
                   Navigator.of(context, rootNavigator: true).pop();

            return;}
            Provider.of<CartProvider>(context,listen: false).addItem(CartModel(
              logo: widget.cartModel.thumbnailImage,
                id:widget.cartModel.id,name: widget.cartModel.name,salon: 'Barber',quantity: 1,price:200
                 ),context);} ,):FittedBox(child: _quantityButtons(),),
        ],
      ))
    ],crossAxisAlignment: CrossAxisAlignment.start,),);
  }


}
