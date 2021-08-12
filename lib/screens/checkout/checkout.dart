import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/model/cart_provider.dart';
import 'package:salon/model/mycarts.dart';
import 'package:salon/screens/checkout/expand_address.dart';
import 'package:salon/screens/checkout/expand_copon.dart';
import 'package:salon/screens/checkout/expand_date.dart';
import 'package:salon/screens/checkout/expand_products.dart';
import 'package:salon/utils/ui.dart';
import 'package:salon/widgets/list_item.dart';
import 'package:salon/generated/l10n.dart';
import 'package:salon/widgets/list_title.dart';


class Checkout extends StatefulWidget {

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  String address = '';
  String coupon = '';
  DateTime selectedTime;

  void setTime(DateTime date){
    setState(() {
      selectedTime = date;
    });
  }

  void setAddress(String add){
      setState(() {
        address=add;
      });
  }

  void addCopon(String add){
    setState(() {
      coupon=add;
    });
    Provider.of<CartProvider>(context,listen: false).checkCopon(add,context);
  }

  int paymentMethod = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((value){
      if(Provider.of<CartProvider>(context,listen: false).allCarts.length>0)Provider.of<CartProvider>(context,listen: false).getOrdersummary();
      Provider.of<CartProvider>(context,listen: false).checkBalance();
    });


  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(appBar: AppBar(title: Text('Checkout'),centerTitle: true,),
        body: Column(children: [
          Expanded(child: SingleChildScrollView(child: Container(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
            ExpandProducts(),
            ExpandAddress(address,setAddress),
            ExpandDate(setTime,selectedTime),
            ExpandCopon(coupon,addCopon),

            ListTitle(title: L10n.of(context).bookingSubtitleCheckout),

            ListItem(
              title: L10n.of(context).bookingPayInStore,
              showBorder: false,
              leading: Radio<int>(
                value: 0,
                groupValue: paymentMethod,
                onChanged: (int selected){
                  setState(() {
                    paymentMethod = 0;
                    print('payment method ${paymentMethod}');
                  });
                },
              ),
              onPressed: (){
                setState(() {
                  paymentMethod = 0;
                });
              },
            ),

              if(Provider.of<CartProvider>(context).balance>0) ListItem(
                title: L10n.of(context).bookingPayWithCard,
                showBorder: false,
                leading: Radio<int>(
                  value: 1,
                  groupValue: paymentMethod,
                  onChanged: (int selected) {
                    setState(() {
                      paymentMethod = 1;
                      print('payment method ${paymentMethod}');

                    });
                  },
                ),
                onPressed: (){
                  setState(() {
                    paymentMethod = 1;
                  });
                },
              ),

            Consumer<CartProvider>(builder: (c,provider,child){
              return provider.orderSummary==null?Container(): Padding(padding: EdgeInsets.symmetric(horizontal: 10,),child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                SizedBox(height: 10,),
                Text('Order summary',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),)
                ,SizedBox(height: 15,),
                Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                  Text('Total amount',style: TextStyle(color: Colors.black),),
                  Text(provider.orderSummary.grandTotal,style: TextStyle(color: Colors.black),),

                ],),

                SizedBox(height: 15,),
                Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                  Text('Coupon Code',style: TextStyle(color: Colors.black),),
                  Text(provider.orderSummary.couponCode,style: TextStyle(color: Colors.black),),

                ],),


                SizedBox(height: 15,),
                Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                  Text('Delivery fees',style: TextStyle(color: Colors.black),),
                  Text(provider.orderSummary.shippingCost,style: TextStyle(color: Colors.black),),

                ],),

                SizedBox(height: 15,),
                Divider(color: Colors.grey,),
                SizedBox(height: 15,),
                Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                  Text('Total',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                  Text(provider.orderSummary.grandTotal,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),


                ],),
                SizedBox(height: 20,),


              ],),);
            },),

          ],),),))
          , Consumer<CartProvider>(builder: (c,p,ch){
            return p.loading?const CircularProgressIndicator():Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: SizedBox(height: 48,width: MediaQuery.of(context).size.width,child: ElevatedButton(child: Text('Confirm Order',style: TextStyle(color: Colors.white),)
              ,style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryColor)) ,onPressed: (){

               checkout(p);


              },),),);
          },),
          SizedBox(height: 10,),
        ],)
    );
  }

  void checkout(CartProvider p) {
    if(Provider.of<CartProvider>(context,listen: false).allCarts.isNotEmpty){
      if(address.isEmpty){
        UI.showErrorDialog(context, message: 'enter your address');
        return;
      }
      if(selectedTime==null){
        UI.showErrorDialog(context, message: 'select delivery time');
        return;
      }
      String payment = paymentMethod==0?'cash_on_delivery':'cash_on_delivery';
      bool points = paymentMethod==0?false:true;
      String date = '${selectedTime.year}-${selectedTime.month}-${selectedTime.day}';
      String time = '${selectedTime.hour}:${selectedTime.minute}:${selectedTime.second}';

      p.startLoading();
      MyCarts().createOrder(Provider.of<CartProvider>(context,listen: false).allCarts[0].ownerId, payment,date,time,address,points,coupon).then((value){
        p.done();
        UI.showMessage(context, message: 'order placed successfully',buttonText: 'ok',onPressed:(){
          Navigator.of(context).pop();
        });
        Provider.of<CartProvider>(context,listen: false).init();
      });
    }
  }
}

