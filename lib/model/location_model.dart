import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:extension/configs/app_globals.dart';
import 'package:extension/model/constants.dart';

import '../main.dart';

class SalonModel {
  List<Data> data;
  bool success;
  int status;

  SalonModel({this.data, this.success, this.status});

  SalonModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data =  <Data>[];
      json['data'].forEach((v) {
        data.add( Data.fromJson(v as Map<String,dynamic>));
      });
    }
    success = json['success'].toString()=='true';
    status = json['status']as int;
  }


  /// get home salons
  Future<List<Data>> getSalons() async {


    Map<String,String> header = {
      'Current-Locale':Intl.getCurrentLocale()
    };


    try {
      var response = await http.get(
        Uri.parse('${Globals.BASE}shops'),
        headers: header
      );

      if(response.statusCode>=400){

      }else{
        final responseJson = json.decode(response.body);
        if(responseJson['success'] as bool==false){
          return [];
        }else{
          return SalonModel.fromJson(responseJson as Map<String,dynamic>).data;
        }
      }

      print('response  is '+response.body);


      // print(responseJson);
      return [];
    } catch (error) {
      print(error);
      return [];
    }
  }


  /// get salon details
  Future<List<Data>> getSalonData(String id) async {
    Map<String,String> header = {
      'Authorization': 'Bearer ${Globals.TOKEN}',
      'Current-Locale':Intl.getCurrentLocale()
    };




    try {
      var response = await http.get(
        Uri.parse('${Globals.BASE}shops/details/$id'),
        headers: header
      );
      print(response.body);
      if(response.statusCode>=400){

      }else{
        final responseJson = json.decode(response.body);
        if(responseJson['success'] as bool==false){
          return [];
        }else{
          return SalonModel.fromJson(responseJson as Map<String,dynamic>).data;
        }
      }

      print('response  is '+response.body);


      // print(responseJson);
      return [];
    } catch (error) {
      print(error);
      return [];
    }
  }


  /// filter salons
  Future<List<Data>> filterSalons(String lat,String long,String cat,String city,String name,{int page=1}) async {

    Map<String,String> header = {
      'Current-Locale':Intl.getCurrentLocale()
    };

    if(getIt.get<AppGlobals>().currentPosition!=null){
      lat = getIt.get<AppGlobals>().currentPosition.latitude.toString();
      long = getIt.get<AppGlobals>().currentPosition.longitude.toString();
      header.putIfAbsent('latitude', () => lat);
      header.putIfAbsent('longitude', () => long);
    }



    try {
      var response = await http.get(
        Uri.parse('${Globals.BASE}shops?page=$page&latitude=$lat&longitude=$long&name=$name&category_id=$cat&city_id=$city'),
          headers: header
      );

      print(        '${Globals.BASE}shops?page=$page&latitude=$lat&longitude=$long&name=$name&category_id=$cat&city_id=$city');
      if(response.statusCode>=400){

      }else{
        final responseJson = json.decode(response.body);
        if(responseJson['success'] as bool==false){
          return [];
        }else{
          return SalonModel.fromJson(responseJson as Map<String,dynamic>).data;
        }
      }

      print('response  is '+response.body);


      // print(responseJson);
      return [];
    } catch (error) {
      print(error);
      return [];
    }
  }

  /// get my fav salons
  Future<List<Data>> getFavSalons() async {

    Map<String, String> headers = {
      'Authorization': 'Bearer ${Globals.TOKEN}',
      'Current-Locale':Intl.getCurrentLocale()
    };

    print('${Globals.TOKEN}');


    try {
      var response = await http.get(
        Uri.parse('${Globals.BASE}shops?myFavourite=true'),
          headers: headers
      );
      print('request is ${Globals.BASE}shops?myFavourite=true');
      if(response.statusCode>=400){

      }else{
        final responseJson = json.decode(response.body);
        print('respoonse is ${response.body}');

        if(responseJson['success'] as bool==false){
          return [];
        }else{
          return SalonModel.fromJson(responseJson as Map<String,dynamic>).data;
        }
      }

      print('response  is '+response.body);


      // print(responseJson);
      return [];
    } catch (error) {
      print(error);
      return [];
    }
  }


}

class Data {
  int id;
  int payment_status;
  String name;
  String logo;
  String latitude;
  String longitude;
  String address;
  String phone;
  double rating;
  bool offer;
  bool isFavourite;

  Data({this.id, this.name, this.logo,this.payment_status});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    payment_status = int.parse(json['payment_status'].toString()==''?'0':json['payment_status'].toString());
    name = getIt.get<AppGlobals>().isRTL&&json['name_ar']!=null?json['name_ar']as String:json['name']as String;
    latitude = (json['latitude'] as String).isEmpty?'0':(json['latitude'] as String);
    longitude = (json['longitude'] as String).isEmpty?'0':(json['longitude'] as String);
    logo = ((json['logo'] as  String)==null|| (json['logo']as String).isEmpty)?'assets/images/onboarding/welcome.jpg':json['logo']as String;
    address = json['address'] as  String??'';
    phone = json['phone'] as  String??'';
    rating = double.parse(json['rating'].toString())??0;
    offer = json['has_offer'] as bool??false;
    isFavourite = json['isFavourite'] as bool??false;
  }


}