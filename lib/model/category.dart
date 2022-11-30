import 'dart:io';

import 'package:intl/intl.dart';

import 'constants.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:extension/model/constants.dart';

class CategoryData {
  List<SingleCategory> data;
  bool success;
  int status;

  CategoryData({this.data, this.success, this.status});

  CategoryData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(SingleCategory.fromJson(v as Map<String,dynamic>));
      });
    }
    success = json['success'] as bool;
    status = json['status'] as int;
  }

  ///get all categories

  Future<List<SingleCategory>> getCategories() async {

    Map<String, String> headers = {
      'Authorization': 'Bearer ${Globals.TOKEN}',
      'Current-Locale':Intl.getCurrentLocale()
    };

    // print('${Globals.TOKEN}');


    try {
      var response = await http.get(
          Uri.parse('${Globals.BASE}categories'),
          headers: headers
      );
      print('request is ${Globals.BASE}categories');
      if(response.statusCode>=400){
          return [];
      }else{
        final responseJson = json.decode(response.body);
        print('respoonse is ${response.body}');

        if(responseJson['result'] as bool==false){
          return [];
        }else{
          return CategoryData.fromJson(responseJson as Map<String,dynamic>).data;
        }
      }

    } catch (error) {
      print(error);
      return [];
    }
  }


}

class SingleCategory {
  int id;
  String name;
  String banner;
  String icon;

  SingleCategory({this.id, this.name, this.banner, this.icon});

  SingleCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    name = json['name']as String;
   // banner = json['banner']as String;
    banner = ((json['banner'] as  String)==null|| (json['banner']as String).isEmpty)?'':json['banner']as String;

    icon = json['icon']as String;
  }


}