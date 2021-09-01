import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:salon/model/constants.dart';

class ProductModel {
  List<Product> products;
  bool success;
  int status;

  ProductModel({this.products, this.success, this.status});

  ProductModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      products = [];
      json['data'].forEach((v) {
        products.add(Product.fromJson(v as Map<String,dynamic>));
      });
    }
    success = json['success']as  bool;
    status = json['status']as int;
  }

  Future<List<Product>> getProducts(int id) async {
    try {

      Map<String,String> header = {
        'Current-Locale':Intl.getCurrentLocale()
      };

      var response = await http.get(
        Uri.parse('${Globals.BASE}products/seller/$id?type=product'),
        headers: header
      );
      print('response  is '+response.body);

      if(response.statusCode>=400){
        return [];

      }else{
        final responseJson = json.decode(response.body);
        if(responseJson['success'] as bool==false){
          return [];
        }else{

          return ProductModel.fromJson(responseJson as Map<String,dynamic>).products;
        }
      }



    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<List<Product>> getServices(int id) async {
    try {
      Map<String,String> header = {
        'Current-Locale':Intl.getCurrentLocale()
      };

      var response = await http.get(
        Uri.parse('${Globals.BASE}products/seller/$id?type=service'),
        headers: header
      );
      print('response  is '+response.body);

      if(response.statusCode>=400){
        return [];

      }else{
        final responseJson = json.decode(response.body);
        if(responseJson['success'] as bool==false){
          return [];
        }else{

          return ProductModel.fromJson(responseJson as Map<String,dynamic>).products;
        }
      }



    } catch (error) {
      print(error);
      return [];
    }
  }


  Future<List<Product>> getTopServices(int id) async {
    try {
      Map<String,String> header = {
        'Current-Locale':Intl.getCurrentLocale()
      };

      var response = await http.get(
        Uri.parse('${Globals.BASE}products?type=service&page=1'),
        headers: header
      );
      print('response  is '+response.body);

      if(response.statusCode>=400){
        return [];

      }else{
        final responseJson = json.decode(response.body);
        if(responseJson['success'] as bool==false){
          return [];
        }else{

          return ProductModel.fromJson(responseJson as Map<String,dynamic>).products;
        }
      }



    } catch (error) {
      print(error);
      return [];
    }
  }





}

class Product {
  int salon_id;
  int shop_id;
  int seller_id;
  int id;
  int service_duration;
  String name;
  String thumbnailImage;
  String basePrice;
  double base_discounted_price;


  Product(
      {this.id,
        this.shop_id,
        this.salon_id,
        this.seller_id,
        this.service_duration,
        this.name,
        this.thumbnailImage,
        this.basePrice,
        this.base_discounted_price
      });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id']as int;
    shop_id = json['shop_id']as int;
    seller_id = json['seller_id']as int;
    service_duration = json['service_duration']as int;
    name = json['name']as String;
    thumbnailImage = ((json['thumbnail_image'] as  String)==null|| (json['thumbnail_image']as String).isEmpty)?'assets/images/onboarding/welcome.png':json['thumbnail_image']as String;

   // thumbnailImage = json['thumbnail_image']as String;
    basePrice = json['base_price']as String;
    base_discounted_price = double.parse(json['base_discounted_price'].toString());

  }


}