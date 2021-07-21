import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:salon/model/constants.dart';

class Banners {
  List<Banner> data;
  bool success;
  int status;

  Banners({this.data, this.success, this.status});

  Banners.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add( Banner.fromJson(v as Map<String,dynamic>));
      });
    }
    success = json['success']as bool;
    status = json['status']as int;
  }

  Future<List<Banner>> getBanners() async {
    try {
      var response = await http.get(
        Uri.parse('${Globals.BASE}sliders'),

      );
      print('response  is '+response.body);

      if(response.statusCode>=400){
        return [];

      }else{
        final responseJson = json.decode(response.body);
        if(responseJson['success'] as bool==false){
          return [];
        }else{

          return Banners.fromJson(responseJson as Map<String,dynamic>).data;
        }
      }



    } catch (error) {
      print(error);
      return [];
    }
  }

}

class Banner {
  String photo;

  Banner({this.photo});

  Banner.fromJson(Map<String, dynamic> json) {
    photo = json['photo'].toString();
  }

}