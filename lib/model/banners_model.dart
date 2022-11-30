import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:extension/model/constants.dart';


///bsanners model
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



  ///get home banners
  Future<List<Banner>> getBanners() async {
    try {

      Map<String,String> header = {
        'Current-Locale':Intl.getCurrentLocale()
      };

      print(header.toString());
      var response = await http.get(
        Uri.parse('${Globals.BASE}sliders'),
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