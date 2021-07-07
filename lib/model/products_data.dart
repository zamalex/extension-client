import 'dart:convert';
import 'package:http/http.dart' as http;

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

  Future<List<Product>> getProducts() async {
    try {
      var response = await http.get(
        Uri.parse('http://salon.badee.com.sa/api/v2/products?type=product'),

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
  int id;
  String name;
  String thumbnailImage;
  String basePrice;


  Product(
      {this.id,
        this.name,
        this.thumbnailImage,
        this.basePrice,

      });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id']as int;
    name = json['name']as String;
    thumbnailImage = json['thumbnail_image']as String;
    basePrice = json['base_price']as String;

  }


}