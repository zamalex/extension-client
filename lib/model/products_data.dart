import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:extension/model/constants.dart';

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


  /// get salon products
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


  /// get related products
  Future<List<Product>> getRelatedProducts(int id) async {
    try {

      Map<String,String> header = {
        'Current-Locale':Intl.getCurrentLocale()
      };

      var response = await http.get(
        Uri.parse('${Globals.BASE}products/related/$id'),
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


  /// get salon services
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

  Future<List<Product>> getPackages() async {
    try {
      Map<String,String> header = {
        'Current-Locale':Intl.getCurrentLocale()
      };

      var response = await http.get(
        Uri.parse('${Globals.BASE}packages'),
        headers: header
      );
      print('request  is '+'${Globals.BASE}packages');

      print('package  is '+response.body);

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

  
  
  Future<List<Product>> getPackageDetails(int id) async {
    try {
      Map<String,String> header = {
        'Current-Locale':Intl.getCurrentLocale()
      };

      var response = await http.get(
        Uri.parse('${Globals.BASE}packages/details/$id'),
        headers: header
      );


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


  ///get top services
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


  /// get top products
  Future<List<Product>> getTopProducts() async {
    try {
      Map<String,String> header = {
        'Current-Locale':Intl.getCurrentLocale()
      };

      var response = await http.get(
        Uri.parse('${Globals.BASE}products?type=product&page=1'),
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
  String description;
  String thumbnailImage;
  String salonImage;
  String basePrice;
  String shop_name;
  String address;
  double base_discounted_price;
  bool has_discount;

  Product(
      {this.id,
        this.shop_id,
        this.shop_name,
        this.salon_id,
        this.seller_id,
        this.service_duration,
        this.name,
        this.address,
        this.description,
        this.thumbnailImage,
        this.basePrice,
        this.has_discount,
        this.salonImage,
        this.base_discounted_price
      });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id']as int;
    has_discount =json['has_discount']==null?false: json['has_discount']as bool;
    shop_id = json['shop_id']as int;
    seller_id = json['seller_id']as int;
    service_duration =json['service_duration']==null?0: json['service_duration']as int;
    description =json['description']==null?'': json['description']as String;
    name = json['name']as String;
    address = json['address']==null?'':json['address']as String;
    shop_name = json['shop_name']as String;
    thumbnailImage = ((json['thumbnail_image'] as  String)==null|| (json['thumbnail_image']as String).isEmpty)?'assets/images/onboarding/welcome.jpg':json['thumbnail_image']as String;
    salonImage = ((json['shop_logo'] as  String)==null|| (json['shop_logo']as String).isEmpty)?'assets/images/onboarding/welcome.jpg':json['shop_logo']as String;

   // thumbnailImage = json['thumbnail_image']as String;
    basePrice = json['base_price']==null?'0':(json['base_price']as String).replaceAll(',', '');
    base_discounted_price =json['base_discounted_price']==null?0: double.parse(json['base_discounted_price'].toString());

  }


}