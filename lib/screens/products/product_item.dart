import 'package:flutter/material.dart';
import 'package:salon/blocs/theme/theme_bloc.dart';
import 'package:salon/configs/constants.dart';

class ProdcutItem extends StatefulWidget {

  @override
  _ProdcutItemState createState() => _ProdcutItemState();
}


class _ProdcutItemState extends State<ProdcutItem> {
  int count = 0;

  Widget _quantityButtons(){
    return  Row(children: [GestureDetector(child: CircleAvatar(child: Text('-',style: TextStyle(color: Colors.white),),radius: 15,backgroundColor: Theme.of(context).accentColor,)
      ,onTap:(){setState(() {
        count--;
      });} ,),Container(child: Text(count.toString(),style: TextStyle(color: Theme.of(context).accentColor),),margin: EdgeInsets.symmetric(horizontal: 5),)
      ,GestureDetector(child: CircleAvatar(child: Text('+',style: TextStyle(color: Colors.white),),radius: 15,backgroundColor: Theme.of(context).accentColor,)
          ,onTap:(){setState(() {
            count+=1;
          });} )],mainAxisSize: MainAxisSize.min,);
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
          count==0?GestureDetector(child: CircleAvatar(radius: 15,backgroundColor: Theme.of(context).accentColor,child: Icon(Icons.shopping_cart,color: Colors.white,size: 15,),)
            ,onTap:(){setState(() {
              count=1;
            });} ,):FittedBox(child: _quantityButtons(),),
        ],
      ))
    ],crossAxisAlignment: CrossAxisAlignment.start,),);
  }


}
