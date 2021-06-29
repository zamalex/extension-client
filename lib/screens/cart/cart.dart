import 'package:flutter/material.dart';
import 'package:salon/screens/cart/cart_item.dart';
class CartList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart'),centerTitle: true,),
      body: Container(padding: EdgeInsets.all(10),color: Colors.grey.shade200,height: MediaQuery.of(context).size.height,
        child: ListView.builder(itemBuilder: (c,i){
          return CartItem();
        },itemCount: 3,),
      ),
    );
  }
}
