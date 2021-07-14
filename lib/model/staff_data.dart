import 'constants.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:salon/model/constants.dart';

class SalonStaff {
  List<SingleStaff> data;
  bool success;
  int status;

  SalonStaff({this.data, this.success, this.status});

  SalonStaff.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(SingleStaff.fromJson(v as Map<String,dynamic>));
      });
    }
    success = json['success']as bool;
    status = json['status']as int;
  }

  Future<List<SingleStaff>> getSalonStaff(String id) async {

    Map<String, String> headers = {
      'Authorization': 'Bearer ${Globals.TOKEN}'
    };

   // print('${Globals.TOKEN}');


    try {
      var response = await http.get(
          Uri.parse('${Globals.BASE}shops/staffs/$id'),
          headers: headers
      );
      print('request is ${Globals.BASE}shops/staffs/$id');
      if(response.statusCode>=400){

      }else{
        final responseJson = json.decode(response.body);
        print('respoonse is ${response.body}');

        if(responseJson['success'] as bool==false){
          return [];
        }else{
          return SalonStaff.fromJson(responseJson as Map<String,dynamic>).data;
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

class SingleStaff {
  int id;
  String name;
  String jobTitle;
  String email;
  String avatar;
  String avatarOriginal;
  String phone;
  double rating;

  SingleStaff(
      {this.id,
        this.name,
        this.jobTitle,
        this.email,
        this.avatar,
        this.avatarOriginal,
        this.phone});

  SingleStaff.fromJson(Map<String, dynamic> json) {
    id = json['id']as int;
    name = json['name'].toString()??'';
    jobTitle = json['job_title'].toString()??'';
    email = json['email'].toString()??'';
    avatar = json['avatar'].toString()??'';
    avatarOriginal = json['avatar_original'].toString()??'';
    phone = json['phone'].toString()??'';
    rating = double.parse(json['rating'].toString()??'0');
  }


}