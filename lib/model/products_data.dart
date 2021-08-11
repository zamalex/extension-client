import 'dart:convert';
import 'package:http/http.dart' as http;
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
      var response = await http.get(
        Uri.parse('${Globals.BASE}products/seller/$id?type=product'),

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
      var response = await http.get(
        Uri.parse('${Globals.BASE}products/seller/$id?type=service'),

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
  int id;
  int service_duration;
  String name;
  String thumbnailImage;
  String basePrice;


  Product(
      {this.id,
        this.salon_id,
        this.service_duration,
        this.name,
        this.thumbnailImage,
        this.basePrice,

      });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id']as int;
    service_duration = json['service_duration']as int;
    name = json['name']as String;
    thumbnailImage = ((json['thumbnailImage'] as  String)==null|| (json['thumbnailImage']as String).isEmpty)?'assets/images/onboarding/welcome.png':json['thumbnailImage']as String;

   // thumbnailImage = json['thumbnail_image']as String;
    basePrice = json['base_price']as String;

  }


}