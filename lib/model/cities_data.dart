import 'dart:io';

import 'package:intl/intl.dart';

import 'constants.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:salon/model/constants.dart';

class CitiesData {
  List<City> data;
  bool success;
  int status;

  CitiesData({this.data, this.success, this.status});

  CitiesData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data =[];
      json['data'].forEach((v) {
        data.add(City.fromJson(v as Map<String,dynamic>));
      });
    }
    success = json['success']as bool;
    status = json['status']as int;
  }

  Future<List<City>> getCategories() async {

    Map<String, String> headers = {
      'Authorization': 'Bearer ${Globals.TOKEN}',
      'Current-Locale':Intl.getCurrentLocale()
    };

    // print('${Globals.TOKEN}');


    try {
      var response = await http.get(
          Uri.parse('${Globals.BASE}cities'),
          headers: headers
      );
      print('request is ${Globals.BASE}cities');
      if(response.statusCode>=400){
        return [];
      }else{
        final responseJson = json.decode(response.body);
        print('respoonse is ${response.body}');

        if(responseJson['success'] as bool==false){
          return [];
        }else{
          return CitiesData.fromJson(responseJson as Map<String,dynamic>).data;
        }
      }

    } catch (error) {
      print(error);
      return [];
    }
  }
}

class City {
  int id;
  int countryId;
  String name;

  City({this.id, this.countryId, this.name});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    countryId = json['country_id']as int;
    name = json['name']as String;

  }


}