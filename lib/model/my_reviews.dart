import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:salon/configs/app_globals.dart';
import 'package:salon/data/models/review_model.dart';
import 'package:salon/model/constants.dart';

import '../main.dart';

class MyReviews {
  List<SingleReview> data;
  bool success;
  int status;

  MyReviews({this.data, this.success, this.status});

  MyReviews.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add( SingleReview.fromJson(v as Map<String,dynamic>));
      });
    }
    success = json['success']as bool;
    status = json['status']as int;
  }


  Future<List<ReviewModel>> getSalonReviews(String id) async {

    Map<String, String> headers = {
      'Authorization': 'Bearer ${Globals.TOKEN}',
      'Current-Locale':Intl.getCurrentLocale()
    };

    try {
      var response = await http.get(
        Uri.parse('${Globals.BASE}reviews/shop/$id'),
         headers: headers
      );

      print('request  is '+'${Globals.BASE}reviews/shop/$id');
      print('response  is '+response.body);
      final responseJson = json.decode(response.body);


      if(response.statusCode>=400){
        return [];
      }
      if(responseJson['success']as bool){
        return MyReviews.fromJson(responseJson as Map<String,dynamic>).data.map((e) {
          return ReviewModel(photo: 'assets/images/data/categories/barber-shop.jpg',salonAddress: 'Utah park',salonName: 'The Barber',rate: e.rating,dateString:
          e.time,comment: e.comment,userName: e.userName,userPhoto: e.avatar??'');
        }).toList();
      }else{
        return [];

      }

    } catch (error) {
      print(error);
      return [];
    }
  }


  Future submitReview(String id,String comment,double rating) async {

    Map<String, String> headers = {
      'Authorization': 'Bearer ${Globals.TOKEN}',
      'Current-Locale':Intl.getCurrentLocale()
    };

    Map<String,dynamic> body = {
      'user_id':'${getIt.get<AppGlobals>().ID}',
      'shop_id':id,
      'rating':rating,
      'comment':comment,

    };


    try {
      var response = await http.post(
        Uri.parse('${Globals.BASE}reviews/shop/submit'),
         headers: headers,
        body:jsonEncode(body)
      );

      print('request  is '+'${Globals.BASE}reviews/shop/submit');
      print('response  is '+response.body);
      print('body  is '+body.toString());
      final responseJson = json.decode(response.body);


    return true;

    } catch (error) {
      print(error);
      return false;
    }
  }


  Future<List<SingleReview>> getMyReviews(String id) async {

    Map<String, String> headers = {
    'Authorization': 'Bearer ${Globals.TOKEN}'
      ,'Current-Locale':Intl.getCurrentLocale()
    };

    try {
      var response = await http.get(
          Uri.parse('${Globals.BASE}reviews/myReviews?user_id=$id'),
          headers: headers
      );

      print('request  is '+'${Globals.BASE}/reviews/myReviews?user_id=$id');
      print('response  is '+response.body);
      final responseJson = json.decode(response.body);


      if(response.statusCode>=400){
        return [];
      }
      if(responseJson['success']as bool){
        return MyReviews.fromJson(responseJson as Map<String,dynamic>).data;
      }else{
        return [];

      }

    } catch (error) {
      print(error);
      return [];
    }
  }

}

class SingleReview {
  int userId;
  String moduleName;
  int moduleId;
  String userName;
  String avatar;
  double rating;
  String comment;
  String time;

  SingleReview(
      {this.userId,
        this.moduleName,
        this.moduleId,
        this.userName,
        this.avatar,
        this.rating,
        this.comment,
        this.time});

  SingleReview.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'] as int;
    moduleName = json['module_name'].toString();
    moduleId = json['module_id']as int;
    userName = json['user_name'].toString();
    avatar = json['avatar'].toString();
    rating = double.parse(json['rating'].toString());
    comment = json['comment'].toString();
    time = json['time'].toString();
  }


}