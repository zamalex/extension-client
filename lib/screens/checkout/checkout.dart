import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/configs/app_globals.dart';
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

import '../../main.dart';


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
      Provider.of<CartProvider>(context,listen: false).setPayWithBalance(false);

      if(Provider.of<CartProvider>(context,listen: false).allCarts.length>0)Provider.of<CartProvider>(context,listen: false).getOrdersummary();
      Provider.of<CartProvider>(context,listen: false).checkBalance();
    });


  }

  @override
  Widget build(BuildContext context) {
    final TextDirection currentDirection = Directionality.of(context);

    bool isRTL = currentDirection == TextDirection.rtl;


    return Scaffold(appBar: AppBar(title: Text(L10n.of(context).Checkoutt),centerTitle: true,),
        body: Column(children: [
          Expanded(child: SingleChildScrollView(child: Container(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
            ExpandProducts(),
            !Provider.of<CartProvider>(context).receivFromSalon?
            ExpandAddress(address,setAddress):AbsorbPointer(
              child: Opacity(
                  opacity: .5,
                  child: ExpandAddress(address,setAddress)),
            ),
            CheckboxListTile(value: Provider.of<CartProvider>(context).receivFromSalon, onChanged:(v){
              Provider.of<CartProvider>(context,listen: false).checkReceiveFromSalon(v);

            },title: Text('receive from salon'),),
            ExpandDate(setTime,selectedTime),
            ExpandCopon(coupon,addCopon),
            if( Provider.of<CartProvider>(context).balance>0)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    CupertinoSwitch(
                      value: Provider.of<CartProvider>(context).payWithBalance,
                      onChanged: (value) {
                        Provider.of<CartProvider>(context,listen: false).setPayWithBalance(value);
                      },
                    ),

                    Column(children: [
                      Text(getIt.get<AppGlobals>().isRTL?'الرصيد':'Balance'),
                      Text(Provider.of<CartProvider>(context).balance.toString())
                    ],)
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              )
            else
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: AbsorbPointer(
                  absorbing: true,
                  child: Row(
                    children: [
                      CupertinoSwitch(
                        value: Provider.of<CartProvider>(context).payWithBalance,
                        onChanged: (value) {
                          Provider.of<CartProvider>(context,listen: false).setPayWithBalance(value);
                        },
                      ),

                      Column(children: [
                        Text(getIt.get<AppGlobals>().isRTL?'الرصيد':'Balance'),
                        Text(Provider.of<CartProvider>(context).balance.toString())
                      ],)
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                ),
              ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10),

                child: ListTitle(title: L10n.of(context).bookingSubtitleCheckout)),

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

              if(Provider.of<CartProvider>(context).balance==-2) ListItem(
                title: isRTL?L10n.of(context).bookingPayWithCard+' لديك ${Provider.of<CartProvider>(context).balance} ريال ':L10n.of(context).bookingPayWithCard+' you have ${Provider.of<CartProvider>(context).balance} SAR',

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
                Text(L10n.of(context).ordersummary,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),)
                ,SizedBox(height: 15,),
                Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                  Text(L10n.of(context).totalammount,style: TextStyle(color: Colors.black),),
                  Text(provider.orderSummary.grandTotal,style: TextStyle(color: Colors.black),),

                ],),

                SizedBox(height: 15,),
                Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                  Text(L10n.of(context).coponcode,style: TextStyle(color: Colors.black),),
                  Text(provider.orderSummary.couponCode,style: TextStyle(color: Colors.black),),

                ],),


                SizedBox(height: 15,),
                Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                  Text(L10n.of(context).deliveryfees,style: TextStyle(color: Colors.black),),
                  Text(provider.orderSummary.shippingCost,style: TextStyle(color: Colors.black),),

                ],),

                SizedBox(height: 15,),
                Divider(color: Colors.grey,),
                SizedBox(height: 15,),
                Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                  Text(L10n.of(context).totaal,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),

                  if(Provider.of<CartProvider>(context,).payWithBalance)
                  Text(provider.balance>=double.parse(provider.orderSummary.grandTotal)?'0':(double.parse(provider.orderSummary.grandTotal)-provider.balance).toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)


              else
                    Text(provider.orderSummary.grandTotal,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),



                ],),
                SizedBox(height: 20,),


              ],),);
            },),

          ],),),))
          , Consumer<CartProvider>(builder: (c,p,ch){
            return p.loading?const CircularProgressIndicator():Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: SizedBox(height: 48,width: MediaQuery.of(context).size.width,child: ElevatedButton(child: Text(L10n.of(context).confirmorder,style: TextStyle(color: Colors.white),)
              ,style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kPrimaryColor)) ,onPressed: (){

               checkout(p);


              },),),);
          },),
          SizedBox(height: 10,),
        ],)
    );
  }

  void checkout(CartProvider p) {
    if(Provider.of<CartProvider>(context,listen: false).receivFromSalon){
      address='الاستلام من الصالون';
    }

    if(Provider.of<CartProvider>(context,listen: false).allCarts.isNotEmpty){
      if(address.isEmpty){
        UI.showErrorDialog(context, message: L10n.of(context).enteraddress);
        return;
      }
      if(selectedTime==null){
        UI.showErrorDialog(context, message: L10n.of(context).selectdeliverytime);
        return;
      }
      String payment = paymentMethod==0?'cash_on_delivery':'cash_on_delivery';
      bool points = Provider.of<CartProvider>(context,listen: false).payWithBalance;//paymentMethod==0?false:true;
      String date = '${selectedTime.year}-${selectedTime.month}-${selectedTime.day}';
      String time = '${selectedTime.hour}:${selectedTime.minute}:${selectedTime.second}';

      p.startLoading();

      if(Provider.of<CartProvider>(context,listen: false).appointments.isNotEmpty){
        MyCarts().createOrderWithAppointment(Provider.of<CartProvider>(context,listen: false).allCarts[0].ownerId, payment,date,time,address,points,coupon,Provider.of<CartProvider>(context,listen: false).appointments).then((value){
          p.done();
          UI.showMessage(context, message: 'order placed successfully',buttonText: 'ok',onPressed:(){
            Navigator.of(context).pop();
          });
          Provider.of<CartProvider>(context,listen: false).init();
          Provider.of<CartProvider>(context,listen: false).clearPrefs();
          Provider.of<CartProvider>(context,listen: false).setPayWithBalance(false);
        });
      }else{
        MyCarts().createOrder(Provider.of<CartProvider>(context,listen: false).allCarts[0].ownerId, payment,date,time,address,points,coupon).then((value){
          p.done();
          UI.showMessage(context, message: 'order placed successfully',buttonText: 'ok',onPressed:(){
            Navigator.of(context).pop();
          });
          Provider.of<CartProvider>(context,listen: false).init();
          Provider.of<CartProvider>(context,listen: false).clearPrefs();
          Provider.of<CartProvider>(context,listen: false).setPayWithBalance(false);
        });
      }

    }
  }
}

