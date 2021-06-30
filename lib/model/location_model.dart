import 'dart:convert';

import 'package:http/http.dart' as http;

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
        Uri.parse('http://salon.badee.com.sa/api/v2/shops'),

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


}

class Data {
  int id;
  String name;
  String logo;

  Data({this.id, this.name, this.logo});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    name = json['name'] as String;
    logo = json['logo'] as  String;
  }


}