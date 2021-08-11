import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:salon/model/cart_model.dart';
import 'package:salon/model/mycarts.dart';
import 'package:salon/screens/cart/cart_item.dart';
import 'package:salon/utils/ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  List<CartModel> items = [];
  List<MyCarts> allCarts = [];
  OrderSummary orderSummary;
  bool loading = false;
  bool isLoading = false;

  void done(){
    loading = false;
    notifyListeners();
  }

  void startLoading(){
    loading = true;
    notifyListeners();
  }

  void init()async{
    items = [];
    await MyCarts().getCartList().then((value){
      print('size is ${value.length}');
      allCarts = value;
      value.forEach((element) {
        element.cartItems.forEach((inner) {
            items.add(CartModel(id: inner.productId,name: inner.productName,quantity: inner.quantity,salon: element.name,price: inner.price+0.0));
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
    return total;
  }

  checkCopon(String code,BuildContext context){
    if(code.isNotEmpty)
    MyCarts().checkCopon(allCarts[0].ownerId, code).then((value){
      UI.showErrorDialog(context,message: value.toString());
      getOrdersummary();
    });
  }

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
          items.add(CartModel(id: inner.productId,name: inner.productName,quantity: inner.quantity,salon: element.name,price: inner.price+0.0));
        });
      });

    });

     isLoading = false;

    notifyListeners();
   /* if(items==null)
      items=[];
    var existing=null;
    if(items.isNotEmpty)
     existing = items.firstWhere((element) => element.id==item.id,orElse: ()=>null);

    if(existing==null)
      items.add(item);
    else{
      items[items.indexWhere((element) => element.id==item.id)].quantity++;

    }
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cart', CartModel.encode(items));*/
    
    
  }

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

  void removeItem(CartModel item) async{
    isLoading = true;
    notifyListeners();

    await MyCarts().removeFromCart(item).then((value){
      print('size is ${value.length}');
      if(value.length>0)
        items= [];

      allCarts = value;

      value.forEach((element) {
        element.cartItems.forEach((inner) {
          items.add(CartModel(id: inner.productId,name: inner.productName,quantity: inner.quantity,salon: element.name,price: inner.price+0.0));
        });
      });

    });
    isLoading = false;
    notifyListeners();
  }


  getOrdersummary(){
    OrderSummary().getOrderSummary(allCarts[0].ownerId).then((value){
          orderSummary = value;
          notifyListeners();
    });
  }



}