import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:salon/model/constants.dart';

class PolicyModel {
  List<Data> data;
  bool success;
  int status;

  PolicyModel({this.data, this.success, this.status});

  PolicyModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v as Map<String,dynamic>));
      });
    }
    success = json['success']as bool;
    status = json['status']as int;
  }

  Future<String> getPolicy(String type) async {
    try {

      Map<String,String> header = {
        'Current-Locale':Intl.getCurrentLocale()
      };

      var response = await http.get(
        Uri.parse('${Globals.BASE}policies/$type'),
        headers: header
      );
      print('response  is '+response.body);

      if(response.statusCode>=400){
        return '';

      }else{
        final responseJson = json.decode(response.body);
        if(responseJson['success'] as bool==false){
          return '';
        }else{

          return PolicyModel.fromJson(responseJson as Map<String,dynamic>).data[0].content??'';
        }
      }



    } catch (error) {
      print(error);
      return '';
    }
  }

}

class Data {
  String content;

  Data({this.content});

  Data.fromJson(Map<String, dynamic> json) {
    content = json['content']as String??'';
  }


}