import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

class ProductDetailsResponse {
  List<Data> data;
  bool success;
  int status;

  ProductDetailsResponse({this.data, this.success, this.status});

  ProductDetailsResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v as Map<String,dynamic>));
      });
    }
    success = json['success'] as bool;
    status = json['status']as int;
  }

  Future<ProductDetailsResponse> getDetails(String id) async {

    Map<String, String> headers = {
      'Current-Locale':Intl.getCurrentLocale()
    };

    try {
      var response = await http.get(
          Uri.parse('${Globals.BASE}products/$id'),
          headers: headers
      );

      print('request  is '+'${Globals.BASE}}products/$id');
      print('response  is '+response.body);
      final responseJson = json.decode(response.body);


      if(response.statusCode>=400){
        return null;
      }
      if(responseJson['success']as bool){
        return ProductDetailsResponse.fromJson(responseJson as Map<String,dynamic>);
      }else{
        return null;

      }

    } catch (error) {
      print(error);
      return null;
    }
  }


}

class Data {
  int id;
  String name;
  int shopId;
  String shopName;
  String thumbnailImage;
  bool hasDiscount;
  String strokedPrice;
  String mainPrice;
  int serviceDuration;
  String description;

  Data(
      {this.id,
        this.name,
        this.shopId,
        this.shopName,
        this.thumbnailImage,
        this.hasDiscount,
        this.strokedPrice,
        this.mainPrice,
        this.serviceDuration,
        this.description});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id']as int;
    name = json['name'].toString();
    shopId = json['shop_id']as int;
    shopName = json['shop_name'].toString();
    thumbnailImage = json['thumbnail_image'].toString();
    hasDiscount = json['has_discount']as bool;
    strokedPrice = json['stroked_price'].toString();
    mainPrice = json['main_price']==null?'':json['main_price'].toString();
    serviceDuration = json['service_duration']as int;
    description = json['description'].toString();
  }


}