import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:salon/model/constants.dart';

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

  Future<List<Data>> getHistory() async {




    try {
      var response = await http.get(
        Uri.parse('${Globals.BASE}purchase-history/8'),

      );
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


}

class Data {
  int id;
  String orderType;
  int bookingStaffId;
  String bookingStaffName;
  String bookingDateTime;
  String code;
  int userId;
  String paymentType;
  String paymentStatus;
  String paymentStatusString;
  String deliveryStatus;
  String deliveryStatusString;
  String grandTotal;
  String date;
  Links links;

  Data(
      {this.id,
        this.orderType,
        this.bookingStaffId,
        this.bookingStaffName,
        this.bookingDateTime,
        this.code,
        this.userId,
        this.paymentType,
        this.paymentStatus,
        this.paymentStatusString,
        this.deliveryStatus,
        this.deliveryStatusString,
        this.grandTotal,
        this.date,
        this.links});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id']as int;
    orderType = json['order_type']as String;
    bookingStaffId = json['booking_staff_id']as int;
    bookingStaffName = json['booking_staff_name']as String;
    bookingDateTime = json['booking_date_time']as String;
    code = json['code']as String;
    userId = json['user_id']as int;
    paymentType = json['payment_type']as String;
    paymentStatus = json['payment_status']as String;
    paymentStatusString = json['payment_status_string']as String;
    deliveryStatus = json['delivery_status']as String;
    deliveryStatusString = json['delivery_status_string']as String;
    grandTotal = json['grand_total']as String;
    date = json['date']as String;
    links = json['links'] != null ?  Links.fromJson(json['links']as Map<String,dynamic>) : null;
  }


}

class Links {
  String details;

  Links({this.details});

  Links.fromJson(Map<String, dynamic> json) {
    details = json['details'] as String;
  }


}