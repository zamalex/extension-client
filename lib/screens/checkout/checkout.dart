import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_sell_sdk_flutter/go_sell_sdk_flutter.dart';
import 'package:go_sell_sdk_flutter/model/models.dart';
import 'package:provider/provider.dart';
import 'package:salon/configs/app_globals.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/model/cart_provider.dart';
import 'package:salon/model/loginmodel.dart';
import 'package:salon/model/mycarts.dart';
import 'package:salon/screens/checkout/expand_address.dart';
import 'package:salon/screens/checkout/expand_copon.dart';
import 'package:salon/screens/checkout/expand_date.dart';
import 'package:salon/screens/checkout/expand_products.dart';
import 'package:salon/utils/ui.dart';
import 'package:salon/widgets/list_item.dart';
import 'package:salon/generated/l10n.dart';
import 'package:salon/widgets/list_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';


class Checkout extends StatefulWidget {

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  String address = '';
  String coupon = '';
  DateTime selectedTime;
  int order_id=0;
  Map<dynamic, dynamic> tapSDKResult;
  String responseID = "";
  String sdkStatus = "";
  String sdkErrorCode;
  String sdkErrorMessage;
  String sdkErrorDescription;

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

  getUser()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final json = jsonDecode(prefs.getString('me')??null);
    if(json!=null){
      LoginModel loginModel = LoginModel.fromJson(json as Map<String,dynamic>);

      if(loginModel!=null){

        getIt.get<AppGlobals>().user.address= loginModel.user.address??'';
        setAddress(getIt.get<AppGlobals>().user.address);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    order_id=0;
    getUser();
    Future.delayed(Duration.zero).then((value){
      Provider.of<CartProvider>(context,listen: false).setPayWithBalance(false);

      if(Provider.of<CartProvider>(context,listen: false).allCarts.length>0)Provider.of<CartProvider>(context,listen: false).getOrdersummary();
      Provider.of<CartProvider>(context,listen: false).checkBalance();
    });


  }


  Future<void> configureSDK(double amount) async {
    // configure app
    configureApp();
    // sdk session configurations
    setupSDKSession(amount);
  }

  // configure app key and bundle-id (You must get those keys from tap)
  Future<void> configureApp() async {
    /* GoSellSdkFlutter.configureApp(
        bundleId: Platform.isAndroid ? "com.badee.salon" : "com.creativitySol.salon",
        productionSecreteKey: Platform.isAndroid ? "pk_test_s9uF4wrkjvf82gJ1ipHnTVEL" : "pk_test_s9uF4wrkjvf82gJ1ipHnTVEL",
        sandBoxsecretKey: Platform.isAndroid ? "sk_test_u2EgVnvBw78NZSUCFHQIyX5z" : "sk_test_6HqM9b2hSKJRjsAlT7CEOgyr",
        lang: "ar");*/
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> setupSDKSession(double amount) async {
    try {
      await GoSellSdkFlutter.terminateSession();
      GoSellSdkFlutter.sessionConfigurations(
          trxMode: TransactionMode.PURCHASE,
          transactionCurrency: "sar",
          amount: amount.toString(),
          customer: Customer(
              customerId: "", // customer id is important to retrieve cards saved for this customer
              email: "",
              isdNumber: getIt.get<AppGlobals>().user.phone,
              number: getIt.get<AppGlobals>().user.phone,
              firstName: "test",
              middleName: "test",
              lastName: "test",
              metaData: null),
          /*paymentItems: <PaymentItem>[
            PaymentItem(
                name: "item1",
                amountPerUnit: 1,
                quantity: Quantity(value: 1),
                discount: {"type": "F", "value": 10, "maximum_fee": 10, "minimum_fee": 1},
                description: "Item 1 Apple",
                taxes: [Tax(amount: Amount(type: "F", value: 10, minimumFee: 1, maximumFee: 10), name: "tax1", description: "tax describtion")],
                totalAmount: 100),
          ],
          // List of taxes
          taxes: [
            Tax(amount: Amount(type: "F", value: 10, minimumFee: 1, maximumFee: 10), name: "tax1", description: "tax describtion"),
            Tax(amount: Amount(type: "F", value: 10, minimumFee: 1, maximumFee: 10), name: "tax1", description: "tax describtion")
          ],
          // List of shippnig
          shippings: [
            Shipping(name: "shipping 1", amount: 100, description: "shiping description 1"),
            Shipping(name: "shipping 2", amount: 150, description: "shiping description 2")
          ],*/
          // Post URL
          postURL: "https://tap.company",
          // Payment description
          paymentDescription: "paymentDescription",
          // Payment Metadata
          paymentMetaData: {
            "a": "a meta",
            "b": "b meta",
          },
          // Payment Reference
          paymentReference: Reference(
              acquirer: "acquirer", gateway: "gateway", payment: "payment", track: "track", transaction: "trans_910101", order: "order_262625"),
          // payment Descriptor
          paymentStatementDescriptor: "paymentStatementDescriptor",
          // Save Card Switch
          isUserAllowedToSaveCard: false,
          // Enable/Disable 3DSecure
          isRequires3DSecure: true,
          // Receipt SMS/Email
          receipt: Receipt(true, false),
          // Authorize Action [Capture - Void]
          authorizeAction: AuthorizeAction(type: AuthorizeActionType.CAPTURE, timeInHours: 10),
          // Destinations
          destinations: null,
          // merchant id
          merchantID: "",
          // Allowed cards
          allowedCadTypes: CardType.ALL,
          applePayMerchantID: "",
          allowsToSaveSameCardMoreThanOnce: false,
          // pass the card holder name to the SDK
          cardHolderName: "",
          // disable changing the card holder name by the user
          allowsToEditCardHolderName: true,
          // select payments you need to show [Default is all, and you can choose between WEB-CARD-APPLEPAY ]
          paymentType: PaymentType.CARD,
          // Transaction mode
          sdkMode: SDKMode.Production);
    } on PlatformException {
      // platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      tapSDKResult = {};
    });
  }

  Future<void> startSDK(double amount) async {

    await configureSDK(amount);

    tapSDKResult = await GoSellSdkFlutter.startPaymentSDK as Map;

    print('>>>> ${tapSDKResult['sdk_result']}');
    Provider.of<CartProvider>(context,listen: false).done();
    switch (tapSDKResult['sdk_result'].toString()) {
      case "CANCELLED":
        Provider.of<CartProvider>(context,listen: false).deleteCart();
        UI.showErrorDialog(context,message: 'Payment failed please try again later',onPressed: (){
          (getIt.get<AppGlobals>().globalKeyBottomBar.currentWidget as BottomNavigationBar)
              .onTap(0);
          Navigator.of(context).popUntil((route) => route.isFirst);
        });
        break;
      case "SUCCESS":
        sdkStatus = "SUCCESS";

        bool result = await MyCarts().sendTransactionId(order_id, tapSDKResult['charge_id'].toString());
        handleSDKResult();
        if(result){
          UI.showMessage(context, message: 'order placed successfully',buttonText: 'ok',onPressed:(){
            Navigator.of(context).pop();
          });
          Provider.of<CartProvider>(context,listen: false).init();
          Provider.of<CartProvider>(context,listen: false).clearPrefs();
          Provider.of<CartProvider>(context,listen: false).setPayWithBalance(false);

        }else{
          UI.showErrorDialog(context, message: 'payment failed please try again later');

        }


        break;
      case "FAILED":
        sdkStatus = "FAILED";
        handleSDKResult();
        sdkNotComplete();
        break;
      case "SDK_ERROR":
        print('sdk error............');
        print(tapSDKResult['sdk_error_code']);
        print(tapSDKResult['sdk_error_message']);
        print(tapSDKResult['sdk_error_description']);
        print('sdk error............');
        sdkErrorCode = tapSDKResult['sdk_error_code'].toString();
        sdkErrorMessage = tapSDKResult['sdk_error_message'].toString();
        sdkErrorDescription = tapSDKResult['sdk_error_description'].toString();
        sdkNotComplete();
        break;

      case "NOT_IMPLEMENTED":
        sdkStatus = "NOT_IMPLEMENTED";
        sdkNotComplete();
        break;
    }

  }

  sdkNotComplete(){
    Provider.of<CartProvider>(context,listen: false).deleteCart();
    UI.showErrorDialog(context,message: 'Payment failed please try again later',onPressed: (){
      (getIt.get<AppGlobals>().globalKeyBottomBar.currentWidget as BottomNavigationBar)
          .onTap(0);
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }
  void handleSDKResult() {
    switch (tapSDKResult['trx_mode'].toString()) {
      case "CHARGE":
        printSDKResult('Charge');
        break;

      case "AUTHORIZE":
        printSDKResult('Authorize');
        break;

      case "SAVE_CARD":
        printSDKResult('Save Card');
        break;

      case "TOKENIZE":
        print('TOKENIZE token : ${tapSDKResult['token']}');
        print('TOKENIZE token_currency  : ${tapSDKResult['token_currency']}');
        print('TOKENIZE card_first_six : ${tapSDKResult['card_first_six']}');
        print('TOKENIZE card_last_four : ${tapSDKResult['card_last_four']}');
        print('TOKENIZE card_object  : ${tapSDKResult['card_object']}');
        print('TOKENIZE card_exp_month : ${tapSDKResult['card_exp_month']}');
        print('TOKENIZE card_exp_year    : ${tapSDKResult['card_exp_year']}');

        responseID = tapSDKResult['token'].toString();
        break;
    }
  }

  void printSDKResult(String trx_mode) {
    print('$trx_mode status                : ${tapSDKResult['status']}');
    print('$trx_mode id               : ${tapSDKResult['charge_id']}');
    print('$trx_mode  description        : ${tapSDKResult['description']}');
    print('$trx_mode  message           : ${tapSDKResult['message']}');
    print('$trx_mode  card_first_six : ${tapSDKResult['card_first_six']}');
    print('$trx_mode  card_last_four   : ${tapSDKResult['card_last_four']}');
    print('$trx_mode  card_object         : ${tapSDKResult['card_object']}');
    print('$trx_mode  card_brand          : ${tapSDKResult['card_brand']}');
    print('$trx_mode  card_exp_month  : ${tapSDKResult['card_exp_month']}');
    print('$trx_mode  card_exp_year: ${tapSDKResult['card_exp_year']}');
    print('$trx_mode  acquirer_id  : ${tapSDKResult['acquirer_id']}');
    print('$trx_mode  acquirer_response_code : ${tapSDKResult['acquirer_response_code']}');
    print('$trx_mode  acquirer_response_message: ${tapSDKResult['acquirer_response_message']}');
    print('$trx_mode  source_id: ${tapSDKResult['source_id']}');
    print('$trx_mode  source_channel     : ${tapSDKResult['source_channel']}');
    print('$trx_mode  source_object      : ${tapSDKResult['source_object']}');
    print('$trx_mode source_payment_type : ${tapSDKResult['source_payment_type']}');
    responseID = tapSDKResult['charge_id'].toString();
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
              if(!v){
                setAddress(getIt.get<AppGlobals>().user.address);
              }

            },title: Text(getIt.get<AppGlobals>().isRTL?'الاستلام من الصالون':'receive from salon'),),
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

              if(Provider.of<CartProvider>(context).allCarts.first.payment_status==1)
                ListItem(
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
                Text(L10n.of(context).ordersummary,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),)
                ,SizedBox(height: 15,),
                Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                  Text(L10n.of(context).totalammount,style: TextStyle(color: Colors.black),),
                  Text((provider.orderSummary.grandTotalValue+double.parse(provider.orderSummary.discount)).toString(),style: TextStyle(color: Colors.black),),

                ],),

                SizedBox(height: 15,),
                Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                  Text(L10n.of(context).coponcode,style: TextStyle(color: Colors.black),),
                  Text(provider.orderSummary.couponCode,style: TextStyle(color: Colors.black),),

                ],),

                SizedBox(height: 15,),
                Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                  Text(getIt.get<AppGlobals>().isRTL?'الخصم':'Discount',style: TextStyle(color: Colors.black),),
                  Text(provider.orderSummary.discount,style: TextStyle(color: Colors.black),),

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
      String payment = paymentMethod==0?'cash_on_delivery':'online';
      bool points = Provider.of<CartProvider>(context,listen: false).payWithBalance;//paymentMethod==0?false:true;
      String date = '${selectedTime.year}-${selectedTime.month}-${selectedTime.day}';
      String time = '${selectedTime.hour}:${selectedTime.minute}:${selectedTime.second}';

      if(paymentMethod==1){
        p.startLoading();
        Provider.of<CartProvider>(context,listen: false).futureOrdersummary().then((summary){
          if(summary!=null){
            if(Provider.of<CartProvider>(context,listen: false).appointments.isNotEmpty){
              MyCarts().createOrderWithAppointment(Provider.of<CartProvider>(context,listen: false).allCarts[0].ownerId, payment,date,time,address,points,coupon,Provider.of<CartProvider>(context,listen: false).appointments).then((value){
                if(value['result']as bool){
                  order_id = value['order_id']as int;
                  startSDK((summary as OrderSummary).grandTotalValue);
                }

              });
            }else{
              MyCarts().createOrder(Provider.of<CartProvider>(context,listen: false).allCarts[0].ownerId, payment,date,time,address,points,coupon).then((value){
                if(value['result']as bool){
                  order_id = value['order_id']as int;
                  startSDK((summary as OrderSummary).grandTotalValue);
                }

              });
            }


          }
        });

        return;
      }

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

