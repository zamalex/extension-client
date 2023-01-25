import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:extension/configs/app_globals.dart';
import 'package:extension/model/constants.dart';

import '../main.dart';

/// appointments model
class ApointmentsData {
  List<Data> data;
  bool success;
  int status;

  ApointmentsData({this.data, this.success, this.status});

  ApointmentsData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v as Map<String,dynamic>));
      });
    }
    success = json['success'] as bool;
    status = json['status'] as int;
  }


  /// get my appointments and orders
  Future<List<Data>> getHistory({int page=1,@required String type}) async {

    Map<String,String> header = {
      'Current-Locale':Intl.getCurrentLocale()
    };


    try {
      var response = await http.get(
        Uri.parse('${Globals.BASE}purchase-history/${getIt.get<AppGlobals>().ID}?page=$page&order_type=$type'),
        headers: header
      );
      print('${Globals.BASE}purchase-history/${getIt.get<AppGlobals>().ID}?page=$page&order_type=$type');
      print('response  is '+response.body);

      if(response.statusCode>=400){
        return [];

      }else{
        final responseJson = json.decode(response.body);
        if(responseJson['success'] as bool==false){
          return [];
        }else{
          return ApointmentsData.fromJson(responseJson as Map<String,dynamic>).data;
        }
      }



    } catch (error) {
      print(error);
      return [];
    }
  }



  ///cancel my order
  Future<bool> cancelOrder(int id) async {

    Map<String, String> headers = {
      'Authorization': 'Bearer ${Globals.TOKEN}',
      'Content-Type': 'application/json',
      'Current-Locale':Intl.getCurrentLocale()
    };


    try {
      var response = await http.post(
        Uri.parse('${Globals.BASE}order/$id/cancel'),
        headers: headers
      );
      print('response  is '+response.body);

      if(response.statusCode>=400){
        return false;

      }else{
        final responseJson = json.decode(response.body);
        if(responseJson['result'] as bool==false){
          return false;
        }else{
          return true;
        }
      }



    } catch (error) {
      print(error);
      return false;
    }
  }


///send notes
  Future<bool> sendNotes(int id,String note) async {

    Map<String, String> headers = {
      'Authorization': 'Bearer ${Globals.TOKEN}',
      'Content-Type': 'application/json',
      'Current-Locale':Intl.getCurrentLocale()
    };

    Map body = {
      'order_id':id,
      'notes':note,
    };

    try {
      var response = await http.post(
        Uri.parse('${Globals.BASE}updateorder'),
        headers: headers,
        body: jsonEncode(body)
      );
      print('response  is '+response.body);

      if(response.statusCode>=400){
        return false;

      }else{
        final responseJson = json.decode(response.body);
        if(responseJson['result'] as bool==false){
          return false;
        }else{
          return true;
        }
      }



    } catch (error) {
      print(error);
      return false;
    }
  }


}

class Data {
  int id;
  String orderType;
  String bookingDateTime;
  String notes;
  String booking_staff_name;
  int booking_staff_id;
  String code;
  int userId;
  String paymentType;
  String shippingTypeString;
  String paymentStatus;
  String paymentStatusString;
  String deliveryStatus;
  String deliveryStatusString;
  String grandTotal;
  String coupon_discount;
  String balance;
  String date;
  bool cancelRequest;
  bool canCancel;
  Shop shop;
  Order items;

  Data(
      {this.id,
        this.orderType,
        this.bookingDateTime,
        this.code,
        this.notes,
        this.userId,
        this.paymentType,
        this.booking_staff_name,
        this.booking_staff_id,
        this.shippingTypeString,
        this.paymentStatus,
        this.paymentStatusString,
        this.deliveryStatus,
        this.deliveryStatusString,
        this.grandTotal,
        this.balance,
        this.coupon_discount,
        this.date,
        this.cancelRequest,
        this.canCancel,
        this.shop,
        this.items});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    orderType = json['order_type']as String;
    bookingDateTime = json['delivery_date_time']as String;
    notes = json['notes']as String;
    code = json['code']as String;
    userId = json['user_id']as int;
    booking_staff_id = json['booking_staff_id']as int??0;
    booking_staff_name = json['booking_staff_name']as String??'';
    paymentStatus = json['payment_status']as String;
    paymentStatusString = json['payment_status_string']as String;
    deliveryStatus = json['delivery_status']as String;
    deliveryStatusString = json['delivery_status_string']as String;
    grandTotal = json['grand_total']as String;
    coupon_discount = json['coupon_discount']as String;
    balance = json['balance_discount']==null?"0.00":json['balance_discount'] as String;

    date = json['date']as String;
    cancelRequest = json['cancel_request']as bool;
    canCancel = json['can_cancel']as bool;
    shop = json['shop'] != null ?  Shop.fromJson(json['shop'] as Map<String,dynamic>) : null;
    items = json['items'] != null ?  Order.fromJson(json['items']as Map<String,dynamic>) : null;
  }

}



class Shop {
  List<SalonData> data;

  Shop({this.data});

  Shop.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add( SalonData.fromJson(v as Map<String,dynamic>));
      });
    }
  }


}

class SalonData {
  int id;
  String name;
  String address;
  String phone;
  String longitude;
  String latitude;

  SalonData(
      {this.id,
        this.name,
        this.address,
        this.phone,
        this.longitude,
        this.latitude});

  SalonData.fromJson(Map<String, dynamic> json) {
    id = json['id']as  int;
    name = getIt.get<AppGlobals>().isRTL&&json['name_ar']!=null?json['name_ar']as String:json['name']as String;
    address = json['address']as String;
    phone = json['phone']as String;
    longitude = json['longitude']as String;
    latitude = json['latitude']as String;
  }

}


class Order {
  List<OrderData> data;

  Order({this.data});

  Order.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add( OrderData.fromJson(v as Map<String,dynamic>));
      });
    }
  }


}
class OrderData {
  String orderType;
  int productId;
  String productName;
  String price;
  int quantity;

  OrderData(
      {this.orderType,
        this.productId,
        this.productName,
        this.price,
        this.quantity});

  OrderData.fromJson(Map<String, dynamic> json) {
    orderType = json['order_type']as String;
    productId = json['product_id'].toString()==''?0:json['product_id'] as int;
    productName = getIt.get<AppGlobals>().isRTL&&json['product_name_ar']!=null?json['product_name_ar']as String:json['product_name']as String;
    price = json['price']as String;
    quantity = json['quantity']as int;
  }


}