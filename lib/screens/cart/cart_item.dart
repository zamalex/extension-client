import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartItem extends StatefulWidget {

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {

  int count = 1;

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
/*
* Card(child: ListTile(leading: Container(color: Colors.red,height: 500,width:100),
      title: Text('The Barbery'),
      minVerticalPadding: 20,
      horizontalTitleGap: 10,
      subtitle: Column(children: [

        Text('Product name'),
        Text('\$20.00')

      ],crossAxisAlignment: CrossAxisAlignment.start,),
      isThreeLine: true,
      trailing: Column(children: [
        _quantityButtons(),
        Text('Total 40.00 SAR')
      ],mainAxisAlignment: MainAxisAlignment.spaceAround,mainAxisSize: MainAxisSize.max,),
      dense: true,
      contentPadding: EdgeInsets.zero,
    ),

        );
* */