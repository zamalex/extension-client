
import 'package:flutter/material.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/screens/cart/cart_item.dart';
import 'package:salon/screens/checkout/checkout.dart';
import 'package:salon/widgets/app_button.dart';
import 'package:salon/widgets/strut_text.dart';
class CartList extends StatelessWidget {

  Widget _bottomBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(235 ,235 ,235, 1),
      ),
      padding: const EdgeInsets.all(kPaddingM),
      child: SafeArea(
        top: false,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  StrutText(
                    'Total',
                    style: TextStyle(color: kPrimaryColor),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 4)),
                  StrutText(
                    '20 SAR',
                    style: TextStyle(color: Colors.black),

                  ),
                ],
              ),
            ),
            AppButton(
              text: 'Checkout',
              onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (v)=>Checkout())),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart'),centerTitle: true,),

      body: Column(children: [
        Expanded(child: Container(padding: EdgeInsets.all(10),color: Colors.grey.shade200,height: MediaQuery.of(context).size.height,
          child: ListView.builder(itemBuilder: (c,i){
            return CartItem();
          },itemCount: 3,),
        ),),
        _bottomBar(context)
      ],)
    );
  }


}

