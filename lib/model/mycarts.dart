import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:extension/configs/app_globals.dart';
import 'package:extension/model/cart_model.dart';
import 'package:extension/model/constants.dart';
import 'package:extension/utils/ui.dart';

import '../main.dart';

class MyCarts {
  String name;
  int ownerId;
  int payment_status;
  int salonId;
  List<CartItems> cartItems;

  MyCarts({this.name,this.payment_status, this.ownerId, this.cartItems,this.salonId});

  MyCarts.fromJson(Map<String, dynamic> json) {
    name = json['name']as String;
    ownerId = json['owner_id']as int;
    salonId = json['id']as int;
    payment_status = int.parse(json['payment_status'].toString()==''?'0':json['payment_status'].toString());
    if (json['cart_items'] != null) {
      cartItems = [];
      json['cart_items'].forEach((v) {
        cartItems.add(new CartItems.fromJson(v as Map<String,dynamic>));
      });
    }
  }

  /// get user cart
  Future<List<MyCarts>> getCartList() async {
    List<MyCarts> list = [];
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer ${Globals.TOKEN}'
      };
      print('${Globals.TOKEN}');

      var response = await http.post(
          Uri.parse('${Globals.BASE}carts/${getIt.get<AppGlobals>().ID}'),
          headers: headers
      );
      print('${Globals.BASE}carts/${getIt.get<AppGlobals>().ID}');
      print('response  is '+response.body);

      list=(json.decode(response.body) as List).map((i) =>
          MyCarts.fromJson(i as Map<String,dynamic>)).toList();



          return list;





    } catch (error) {
      print(error);
      return [];
    }
  }


  /// send transaction id of online payment
  Future<bool> sendTransactionId(int order,String transaction) async {

    Map<String, String> headers = {
      'Authorization': 'Bearer ${Globals.TOKEN}'
      ,'Content-Type':'application/json'
    };

    Map<String,dynamic> body ={
      'order_id':order,
      'transaction_id':transaction

    } ;

    try {

      print('request  is '+'${Globals.BASE}updatepayment');
      print('body  is '+'${body.toString()}');

      var response = await http.post(
          Uri.parse('${Globals.BASE}updatepayment'),
          headers: headers,
          body: jsonEncode(body)
      );
      print('response  is '+response.body);

      final responseJson = json.decode(response.body);

      return responseJson['result']as bool??false;

    } catch (error) {
      print(error);
      return false;
    }
  }


  /// add item to cart
  Future<List<MyCarts>> addTocart(CartModel cartModel,BuildContext context) async {
    List<MyCarts> list = [];
    String resul;
    Map<String,dynamic> body ={
      'id':cartModel.id,
      //'variant':'',
      'user_id':getIt.get<AppGlobals>().ID,
      'quantity':1,

    } ;
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer ${Globals.TOKEN}',
        'Content-Type':'application/json'
      };
      print('${Globals.TOKEN}');
      print('body ${body.toString()}');

      var response = await http.post(
          Uri.parse('${Globals.BASE}carts/add'),
          headers: headers,
        body: jsonEncode(body)
      );
      print('${Globals.BASE}carts/add');
      print('response  is '+response.body);

      resul = response.body;

      if(json.decode(response.body) is Map){
        if(json.decode(response.body)['result']==false){
          UI.showErrorDialog(context,message:json.decode(response.body)['message'].toString());
        return [];
        }
      }

      list=(json.decode(response.body) as List).map((i) =>
          MyCarts.fromJson(i as Map<String,dynamic>)).toList();



      return list;





    } catch (error) {
      print(error);
     /* Map<String,dynamic> res = json.decode(resul)as Map<String,dynamic>;

      if(res['result']as bool??true == false){
        UI.showErrorDialog(context,message: res['message'].toString()??'server error');
        print(res['message'].toString());
      }*/
      return [];
    }
  }



  ///remove item from cart
  Future<List<MyCarts>> removeFromCart(CartModel cartModel) async {
    List<MyCarts> list = [];
    Map<String,dynamic> body ={
      'id':cartModel.id,
      //'variant':'',
      'user_id':getIt.get<AppGlobals>().ID,
      'quantity':-1,

    } ;
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer ${Globals.TOKEN}',
        'Content-Type':'application/json'
      };
      print('${Globals.TOKEN}');
      print('body ${body.toString()}');

      var response = await http.post(
          Uri.parse('${Globals.BASE}carts/change-quantity'),
          headers: headers,
          body: jsonEncode(body)
      );
      print('${Globals.BASE}carts/change-quantity');
      print('response  is '+response.body);

      list=(json.decode(response.body) as List).map((i) =>
          MyCarts.fromJson(i as Map<String,dynamic>)).toList();



      return list;

    } catch (error) {
      print(error);
      return [];
    }
  }


  ///delete cart
  Future<bool> deleteCart(int owner) async {

    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer ${Globals.TOKEN}',
        'Content-Type':'application/json'
      };


      Map<String,dynamic> body ={
        'owner_id':owner,
        'user_id':getIt.get<AppGlobals>().ID,

      } ;

      print('${Globals.TOKEN}');

      var response = await http.post(
          Uri.parse('${Globals.BASE}removefromcart'),
          headers: headers,
        body: jsonEncode(body)
      );
      //print('${Globals.BASE}carts/${getIt.get<AppGlobals>().ID}');
      print('response  is '+response.body);



      return true;

    } catch (error) {
      print(error);
      return false;
    }
  }


  ///check coupon
  Future<Map> checkCopon(int owner,String coupon_code) async {
    Map<String,dynamic> body ={
      'owner_id':owner,
      //'variant':'',
      'user_id':getIt.get<AppGlobals>().ID,
      'coupon_code':coupon_code,

    } ;
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer ${Globals.TOKEN}',
        'Content-Type':'application/json'
      };
      print('${Globals.TOKEN}');
      print('body ${body.toString()}');

      var response = await http.post(
          Uri.parse('${Globals.BASE}coupon-apply'),
          headers: headers,
          body: jsonEncode(body)
      );
      print('${Globals.BASE}coupon-apply');
      print('response  is '+response.body);
      final responseJson = json.decode(response.body);

      if(responseJson['result']as bool)
      return {'result':true,'message':responseJson['message']};

      return {'result':false,'message':responseJson['message']};
    } catch (error) {
      print(error);
      return {'result':false,'message':'server error'};
    }
  }

///check user balance
  Future<double> checkBalance() async {

    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer ${Globals.TOKEN}',
        'Content-Type':'application/json',
        'Current-Locale':Intl.getCurrentLocale()
      };

      var response = await http.get(
          Uri.parse('${Globals.BASE}wallet/balance/${getIt.get<AppGlobals>().ID}'),
          headers: headers,
      );

      print('${Globals.BASE}wallet/balance/${getIt.get<AppGlobals>().ID}');

      final responseJson = json.decode(response.body);

      print(responseJson);
      //if(responseJson['result']as bool)
      return double.parse(responseJson['balance'].toString()??'0');


    } catch (error) {
      print(error);
      return 0;
    }
  }



  ///create order
  Future<Map> createOrder(int owner,String payment,String date,String time,String address,bool points,String copon) async {
    Map<String,dynamic> body ={
      'owner_id':owner,
      //'variant':'',
      'user_id':getIt.get<AppGlobals>().ID,
      'payment_type':payment,
      'date':date,
      'time':time,
      'address_text':address,
      'pay_with_points':points,
      'coupon_text':copon,

    } ;
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer ${Globals.TOKEN}',
        'Content-Type':'application/json',
        'Current-Locale':Intl.getCurrentLocale()
      };
      print('${Globals.TOKEN}');
      print('body ${body.toString()}');

      var response = await http.post(
          Uri.parse('${Globals.BASE}order/store'),
          headers: headers,
          body: jsonEncode(body)
      );
      print('${Globals.BASE}order/store');
      print('response  is '+response.body);
      final responseJson = json.decode(response.body);

      if(responseJson['result']as bool)
         return {'result':true,'order_id':responseJson['order_id']};

      return  {'result':false};
    } catch (error) {
      print(error);
      return  {'result':false};
    }
  }


  /// create order and appointment
  Future<Map> createOrderWithAppointment(int owner,String payment,String date,String time,String address,bool points,String copon,Map appointment) async {
    Map<String,dynamic> body ={
      'owner_id':owner,
      //'variant':'',
      'user_id':getIt.get<AppGlobals>().ID,
      'payment_type':payment,
      'date':date,
      'time':time,
      'services_ids':appointment['services_ids'],
      'staff_id':appointment['staff_id']??0,
      'address_text':address,
      'pay_with_points':points,
      'coupon_text':copon,

    } ;
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer ${Globals.TOKEN}',
        'Content-Type':'application/json',
        'Current-Locale':Intl.getCurrentLocale()
      };
      print('${Globals.TOKEN}');
      print('body ${body.toString()}');

      var response = await http.post(
          Uri.parse('${Globals.BASE}orderprocess/store'),
          headers: headers,
          body: jsonEncode(body)
      );
      print('${Globals.BASE}orderprocess/store');
      print('response  is '+response.body);
      final responseJson = json.decode(response.body);

      if(responseJson['result']as bool)
        return {'result':true,'order_id':responseJson['order_id']};

      return {'result':false};
    } catch (error) {
      print(error);
      return {'result':false};
    }
  }




}

class CartItems {
  int id;
  int ownerId;
  int userId;
  int productId;
  String productName;
  String productThumbnailImage;
  double price;
  double tax;
  double shippingCost;
  int quantity;

  CartItems(
      {this.id,
        this.ownerId,
        this.userId,
        this.productId,
        this.productName,
        this.productThumbnailImage,
        this.price,
        this.tax,
        this.shippingCost,
        this.quantity});

  CartItems.fromJson(Map<String, dynamic> json) {
    id = json['id']as int;
    ownerId = json['owner_id']as int;
    userId = json['user_id']as int;
    productId = json['product_id']as int;
    productName = /*json['product_name']as String;*/getIt.get<AppGlobals>().isRTL&&json['product_name_ar']!=null?json['product_name_ar']as String:json['product_name']as String;
    productThumbnailImage = json['product_thumbnail_image']as String;
    price = double.parse(json['price'].toString()??'0');
    tax = double.parse(json['tax'].toString()??'0');
    shippingCost = double.parse(json['shipping_cost'].toString()??'0');
    quantity = json['quantity']as int;
  }


}

// To parse this JSON data, do
//
//     final orderSummary = orderSummaryFromJson(jsonString);


class OrderSummary {
  OrderSummary({
    this.subTotal,
    this.tax,
    this.shippingCost,
    this.discount,
    this.grandTotal,
    this.grandTotalValue,
    this.couponCode,
    this.couponApplied,
  });

  String subTotal;
  String tax;
  String shippingCost;
  String discount;
  String grandTotal;
  double grandTotalValue;
  String couponCode;
  bool couponApplied;

  factory OrderSummary.fromRawJson(String str) => OrderSummary.fromJson(json.decode(str)as Map<String,dynamic>);

  factory OrderSummary.fromJson(Map<String, dynamic> json) => OrderSummary(
    subTotal: json['sub_total']as String,
    tax: json['tax']as String,
    shippingCost: json['shipping_cost']as String,
    discount: json['discount']as String,
    grandTotal: (json['grand_total']as String).replaceAll(',', ''),
    grandTotalValue: double.parse(json['grand_total_value'].toString()),
    couponCode: json['coupon_code']as String,
    couponApplied: json['coupon_applied']as bool,
  );


  Future<OrderSummary> getOrderSummary(int owner,Map appointment) async {

    Map<String, String> headers = {
      'Authorization': 'Bearer ${Globals.TOKEN}'
      ,'Content-Type':'application/json'
    };

    Map<String,dynamic> body ={
      'services_ids':appointment['services_ids']??[],

    } ;

    try {

      print('request  is '+'${Globals.BASE}cart-summary/${getIt.get<AppGlobals>().user.id}/$owner');
      print('body  is '+'${body.toString()}');

      var response = await http.post(
        Uri.parse('${Globals.BASE}cart-summary/${getIt.get<AppGlobals>().ID}/$owner'),
         headers: headers,
        body: jsonEncode(body)
      );
      print('response  is '+response.body);

      final responseJson = json.decode(response.body);

      return OrderSummary.fromJson(responseJson as Map<String,dynamic>);

    } catch (error) {
      print(error);
      return null;
    }
  }

}
