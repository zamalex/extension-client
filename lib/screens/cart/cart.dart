
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/model/cart_provider.dart';
import 'package:salon/screens/cart/cart_item.dart';
import 'package:salon/screens/checkout/checkout.dart';
import 'package:salon/widgets/app_button.dart';
import 'package:salon/widgets/list_item.dart';
import 'package:salon/widgets/list_title.dart';
import 'package:salon/widgets/strut_text.dart';
import 'package:salon/generated/l10n.dart';
import 'package:sprintf/sprintf.dart';


class CartList extends StatefulWidget {

  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  CartProvider cartProvider;



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
                    L10n.of(context).totaal,
                    style: TextStyle(color: kPrimaryColor),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 4)),
                  Consumer<CartProvider>(builder: (c,cart,child){
                    return StrutText(
                      '${cart.getPrice.toStringAsFixed(2)} ${L10n.of(context).SAR}',
                      style: TextStyle(color: Colors.black),

                    );
                  },),
                ],
              ),
            ),
            AppButton(
              text: L10n.of(context).Checkoutt,
              onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (v)=>Checkout())),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((value){
      Provider.of<CartProvider>(context,listen: false).clear();
      Provider.of<CartProvider>(context,listen: false).init();

    } );
    //cartProvider = Provider.of<CartProvider>(context,listen: false);
  }

  @override
  Widget build(BuildContext context) {

    //Provider.of<CartProvider>(context,listen: false).init();
    return Scaffold(
      backgroundColor:Colors.grey.shade200 ,
        appBar: AppBar(title: Text(L10n.of(context).Cartt),centerTitle: true,),

        body: Column(children: [
          Expanded(child: Container(padding: EdgeInsets.all(10),color: Colors.grey.shade200,height: MediaQuery.of(context).size.height,
            child: ListView.builder(itemBuilder: (c,i){
              return CartItem(Provider.of<CartProvider>(context).items[i]);
            },itemCount: Provider.of<CartProvider>(context).items.length,),
          ),),
          if(Provider.of<CartProvider>(context).hasAppointments())
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTitle(
                title: L10n.of(context).bookingSubtitleAppointment
            ),
          ),
          Divider(),
          Consumer<CartProvider>(
           builder: (context, value, child) {
             return  !value.hasAppointments()?Container():Padding(
               padding: const EdgeInsets.all(10.0),
               child: ListItem(
                 title: value.appointments['services'].toString()??'',
                 subtitle: '',
                 trailing: Column(
                   crossAxisAlignment: CrossAxisAlignment.end,
                   children: <Widget>[
                     InkWell(
                         child: Icon(Icons.delete),
                     onTap: (){
                       Provider.of<CartProvider>(context,listen: false).clearPrefs();
                     },
                     ),
                     Text(
                       L10n.of(context).commonCurrencyFormat(sprintf('%.2f', <double>[double.parse(value.appointments['total'].toString())])),
                     ),
                     Text(
                       L10n.of(context).commonDurationFormat(value.appointments['duration']??0),
                     ),
                   ],
                 ),
                 showBorder: false,
               ),
             );
           },
          ),
          Provider.of<CartProvider>(context,listen: true).items.isNotEmpty?_bottomBar(context):Container()
        ],)
    );
  }
}

