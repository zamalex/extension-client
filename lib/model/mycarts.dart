import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:salon/configs/app_globals.dart';
import 'package:salon/model/cart_model.dart';
import 'package:salon/model/constants.dart';

import '../main.dart';

class MyCarts {
  String name;
  int ownerId;
  List<CartItems> cartItems;

  MyCarts({this.name, this.ownerId, this.cartItems});

  MyCarts.fromJson(Map<String, dynamic> json) {
    name = json['name']as String;
    ownerId = json['owner_id']as int;
    if (json['cart_items'] != null) {
      cartItems = [];
      json['cart_items'].forEach((v) {
        cartItems.add(new CartItems.fromJson(v as Map<String,dynamic>));
      });
    }
  }

  Future<List<MyCarts>> getCartList() async {
    List<MyCarts> list = [];
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer ${Globals.TOKEN}'
      };
      print('${Globals.TOKEN}');

      var response = await http.post(
          Uri.parse('${Globals.BASE}carts/${getIt.get<AppGlobals>().user.id}'),
          headers: headers
      );
      print('${Globals.BASE}carts/${getIt.get<AppGlobals>().user.id}');
      print('response  is '+response.body);

      list=(json.decode(response.body) as List).map((i) =>
          MyCarts.fromJson(i as Map<String,dynamic>)).toList();



          return list;





    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<List<MyCarts>> addTocart(CartModel cartModel) async {
    List<MyCarts> list = [];
    Map<String,dynamic> body ={
      'id':cartModel.id,
      //'variant':'',
      'user_id':getIt.get<AppGlobals>().user.id,
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

      list=(json.decode(response.body) as List).map((i) =>
          MyCarts.fromJson(i as Map<String,dynamic>)).toList();



      return list;





    } catch (error) {
      print(error);
      return [];
    }
  }

  Future checkCopon(int owner,String coupon_code) async {
    Map<String,dynamic> body ={
      'owner_id':owner,
      //'variant':'',
      'user_id':getIt.get<AppGlobals>().user.id,
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
      return true;

      return false;
    } catch (error) {
      print(error);
      return null;
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
  int price;
  int tax;
  int shippingCost;
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
    productName = json['product_name']as String;
    productThumbnailImage = json['product_thumbnail_image']as String;
    price = json['price']as int;
    tax = json['tax']as int;
    shippingCost = json['shipping_cost']as int;
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
    grandTotal: json['grand_total']as String,
    grandTotalValue: double.parse(json['grand_total_value'].toString()),
    couponCode: json['coupon_code']as String,
    couponApplied: json['coupon_applied']as bool,
  );


  Future<OrderSummary> getOrderSummary(int owner) async {

    Map<String, String> headers = {
      'Authorization': 'Bearer ${Globals.TOKEN}'
    };

    try {
      var response = await http.get(
        Uri.parse('${Globals.BASE}cart-summary/${getIt.get<AppGlobals>().user.id}/$owner'),
         headers: headers
      );

      print('request  is '+'${Globals.BASE}cart-summary/${getIt.get<AppGlobals>().user.id}/$owner');
      print('response  is '+response.body);
      final responseJson = json.decode(response.body);

      return OrderSummary.fromJson(responseJson as Map<String,dynamic>);

    } catch (error) {
      print(error);
      return null;
    }
  }
}