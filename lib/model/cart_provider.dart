import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:extension/model/cart_model.dart';
import 'package:extension/model/mycarts.dart';
import 'package:extension/screens/cart/cart_item.dart';
import 'package:extension/utils/ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  List<CartModel> items = [];
  List<MyCarts> allCarts = [];

  OrderSummary orderSummary;
  bool loading = false;
  bool isLoading = false;
  bool receivFromSalon = false;
  SharedPreferences prefs;
  Map appointments = {};

  double balance=0;
  bool payWithBalance = false;



  ///select receive from salon option
  checkReceiveFromSalon(bool v){
    receivFromSalon=v;
    notifyListeners();
  }


  /// check if there is products from another salon
  bool canAdd(int salon){
    if(appointments.isNotEmpty){
      print('appointment id from cart is ${appointments['shop_id']}');
      return int.parse(appointments['shop_id'].toString())==salon;

    }
    if(items.isNotEmpty) {
      print('product id from cart is ${items.first.salon_id} and salon is ${salon}');
      return items.first.salon_id == salon;
    }
    return true;
  }
  bool hasAppointments(){
    return items.isNotEmpty&&appointments.isNotEmpty;
  }


  ///check pay with balance
  setPayWithBalance(bool p){
    payWithBalance = p;
    notifyListeners();
  }



  clear(){
    // items = [];
     //allCarts = [];
     items.clear();
     allCarts.clear();
    notifyListeners();
  }


  void done(){
    loading = false;
    notifyListeners();
  }

  void startLoading(){
    loading = true;
    notifyListeners();
  }

  clearPrefs()async{
    prefs ??= await SharedPreferences.getInstance();
    prefs.remove('previous');
    appointments.clear();
    notifyListeners();

  }



  void addAppointments(Map map)async{
    prefs ??= await SharedPreferences.getInstance();
    prefs.setString("previous", jsonEncode(map));

    appointments=map;

    notifyListeners();
  }
///init cart screen
  void init()async{
    receivFromSalon = false;
    items = [];
    appointments={};
    prefs ??= await SharedPreferences.getInstance();
    String previous = prefs.getString('previous');
    if(previous!=null){
      appointments=jsonDecode(prefs.getString('previous'))as Map;
    }

    clear();
    await MyCarts().getCartList().then((value){
      print('size is ${value.length}');
      allCarts = value;
      value.forEach((element) {
        element.cartItems.forEach((inner) {
            items.add(CartModel(logo:inner.productThumbnailImage,salon_id: element.salonId,id: inner.productId,name: inner.productName,quantity: inner.quantity,salon: element.name,price: inner.price+0.0));
        });
      });

    });
    print('initiated');

    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setString('cart', CartModel.encode(fake));

    //String json = await prefs.getString('cart')??null;
   // if(json!=null)
   // items = CartModel.decode(json);
    notifyListeners();

  }

  double price = 0;

  double get  getPrice{
    double total =0;
    items.forEach((element) {
      total+=(element.price*element.quantity);
    });
    if(appointments.isNotEmpty){
      total+=double.parse(appointments['total'].toString());
    }


    return total;
  }


  ///check coupon
  checkCopon(String code,BuildContext context){
    if(code.isNotEmpty)
    MyCarts().checkCopon(allCarts[0].ownerId, code).then((value){
      if(value['result']as bool==false){
        UI.showErrorDialog(context,message: value['message'].toString());

      }
      getOrdersummary();
    });
  }

///get user balance
  checkBalance() async {
   balance = 0;
   notifyListeners();
    await MyCarts().checkBalance().then((double value){
        balance = value;
    });

    notifyListeners();
  }


  /// add item to cart
  void addItem(CartModel item,BuildContext context) async{
     isLoading = true;
    notifyListeners();

    await MyCarts().addTocart(item,context).then((value){
      print('size is ${value.length}');
      if(value.length>0)
        items= [];

      allCarts = value;

      value.forEach((element) {
        element.cartItems.forEach((inner) {
          items.add(CartModel(logo: inner.productThumbnailImage,salon_id:item.salon_id,id: inner.productId,name: inner.productName,quantity: inner.quantity,salon: element.name,price: inner.price+0.0));
        });
      });

    });

     isLoading = false;

    notifyListeners();

  }


  ///get item count
  int itemCount(int id){

    CartModel existing=null;
    if(items.isNotEmpty)
     existing = items.firstWhere((element) => element.id==id,orElse: ()=>null);

    if(existing!=null)
      return existing.quantity;
    else{
      return 0;

    }
    notifyListeners();


  }


  ///remove item from cart
  void removeItem(CartModel item) async{
    isLoading = true;
    notifyListeners();

    await MyCarts().removeFromCart(item).then((value){
      print('size is ${value.length}');
     // if(value.length>0)
        items= [];

      allCarts = value;

      value.forEach((element) {
        element.cartItems.forEach((inner) {

          items.add(CartModel(salon_id: item.salon_id,logo: inner.productThumbnailImage,id: inner.productId,name: inner.productName,quantity: inner.quantity,salon: element.name,price: inner.price+0.0));
        });
      });

    });
    isLoading = false;
    notifyListeners();
  }


  ///delete cart
  Future deleteCart()async{
    isLoading = true;
    notifyListeners();
    await MyCarts().deleteCart(allCarts[0].ownerId).then((value){
      if(value){
        items.clear();
        appointments.clear();
        clearPrefs();
      }
    });

    isLoading = false;
notifyListeners();
    return true;
  }

/// get order summary
  getOrdersummary(){
    OrderSummary().getOrderSummary(allCarts[0].ownerId,appointments).then((value){
      /*if(appointments.isNotEmpty){
        value.grandTotal=(double.parse(value.grandTotal)+double.parse(appointments['total'].toString())).toString();
      }*/
      orderSummary = value;
          notifyListeners();
    });
  }

  Future futureOrdersummary(){
    return OrderSummary().getOrderSummary(allCarts[0].ownerId,appointments);
  }



}