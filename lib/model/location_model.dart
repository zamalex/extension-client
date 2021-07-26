import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:salon/model/constants.dart';

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

  Future<List<Data>> getSalons() async {




    try {
      var response = await http.get(
        Uri.parse('${Globals.BASE}shops'),

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

  Future<List<Data>> getFavSalons() async {

    Map<String, String> headers = {
      'Authorization': 'Bearer ${Globals.TOKEN}'
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
  String name;
  String logo;
  String address;
  double rating;

  Data({this.id, this.name, this.logo});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    name = json['name'] as String;
    logo = ((json['logo'] as  String)==null|| (json['logo']as String).isEmpty)?'assets/images/onboarding/welcome.png':json['logo']as String;
    address = json['address'] as  String;
    rating = double.parse(json['rating'].toString());
  }


}