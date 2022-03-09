import 'dart:convert';
import 'dart:io';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class LoginModel {
  LoginModel({
    this.accessToken,
    this.user,
    this.result,
    this.message
  });

  String accessToken;
  String message;
  User user;
  bool result;


  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    accessToken: json['access_token'].toString(),
    result: json['result'].toString()=='true',
    user: User.fromJson(json['user']as Map<String,dynamic>),
    message: json['message'].toString()??''
  );


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    data['access_token'] = this.accessToken;

    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }

  Future<LoginModel> loginUser(String email, String password) async {
    var param = {
      'phone': email,
      'email': email,
      'password': password,
    };

    Map<String,String> header = {
      'Current-Locale':Intl.getCurrentLocale()
    };


    try {
      var response = await http.post(
        Uri.parse('${Globals.BASE}auth/login'),
        body: param,
        headers: header
      );

      final responseJson = json.decode(response.body);
      if(responseJson['result'] as bool==false){
        return LoginModel(result: false,message:responseJson['message'].toString() );
      }
      print('response  is '+response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('me', response.body);

      // print(responseJson);
      return LoginModel.fromJson(responseJson as Map<String,dynamic>);
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<Map<String,dynamic>> registerUser(String name,String email, String password) async {
    var param = {
      'name':name,
      'email_or_phone': email,
      'password': password,
      'passowrd_confirmation': password,
      'register_by': 'phone',
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Requested-With':'XMLHttpRequest',
      'Current-Locale':Intl.getCurrentLocale()
    };

    try {
      var response = await http.post(
        Uri.parse('${Globals.BASE}auth/signup'),
        body: jsonEncode(param),
        headers: headers
      );

      print(param.toString());
      print('response  is '+response.body);
      final responseJson = json.decode(response.body);


      if(response.statusCode>=400){
        return {'status':false,'message':responseJson['message']};
      }
    if(responseJson['result']as bool){
      return {'status':true,'message':responseJson['message'],'user_id':responseJson['user_id']};

    }else
       return {'status':false,'message':responseJson['message'],'user_id':responseJson['user_id']};
    } catch (error) {
      print(error);
      return {'status':false,'message':'error occured'};
    }
  }

  Future<Map<String,dynamic>> verifyRegister(String id,String code) async {
    var param = {
      'user_id':id,
      'verification_code': code,

    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Requested-With':'XMLHttpRequest',
    'Current-Locale':Intl.getCurrentLocale()
    };

    try {
      var response = await http.post(
          Uri.parse('${Globals.BASE}auth/confirm_code'),
          body: jsonEncode(param),
          headers: headers
      );

      print(param.toString());
      print('response  is '+response.body);
      final responseJson = json.decode(response.body);


      if(response.statusCode>=400){
        return {'status':false,'message':responseJson['message']};
      }
      if(responseJson['result']as bool){
        return {'status':true,'message':responseJson['message']};
      }else{
        return {'status':false,'message':responseJson['message']};

      }

    } catch (error) {
      print(error);
      return {'status':false,'message':'error occured'};
    }
  }

  Future<Map<String,dynamic>> verifyPassword(String phone,String code) async {
    var param = {
      'email_or_code':phone,
      'verify_by': code,

    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Requested-With':'XMLHttpRequest',
    'Current-Locale':Intl.getCurrentLocale()
    };

    try {
      var response = await http.post(
          Uri.parse('${Globals.BASE}auth/password/forget_request'),
          body: jsonEncode(param),
          headers: headers
      );

      print(param.toString());
      print('response  is '+response.body);
      final responseJson = json.decode(response.body);


      if(response.statusCode>=400){
        return {'status':false,'message':responseJson['message']};
      }
      if(responseJson['result']as bool){
        return {'status':true,'message':responseJson['message']};
      }else{
        return {'status':false,'message':responseJson['message']};

      }

    } catch (error) {
      print(error);
      return {'status':false,'message':'error occured'};
    }
  }

  Future<String> getProfileImage()async{
    var param = {

      'access_token': Globals.TOKEN,

    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Requested-With':'XMLHttpRequest',
    'Authorization': 'Bearer ${Globals.TOKEN}',
      'Current-Locale':Intl.getCurrentLocale()
    };

    try {
      var response = await http.post(
          Uri.parse('${Globals.BASE}get-user-by-access_token'),
          body: jsonEncode(param),
          headers: headers
      );

      print(param.toString());
      print('response  is '+response.body);
      final responseJson = json.decode(response.body);


      if(response.statusCode>=400){
        return '';
      }
      if(responseJson['result']as bool){
        return responseJson['avatar_original']as String??'';
      }else{
        return '';

      }

    } catch (error) {
      print(error);
      return '';
    }
  }



  Future<bool> changePass(String code,String pass)async{
    var param = {

      'verification_code': code,
      'password': pass,

    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Requested-With':'XMLHttpRequest',
      'Current-Locale':Intl.getCurrentLocale()
    };

    try {
      var response = await http.post(
          Uri.parse('${Globals.BASE}auth/password/confirm_reset'),
          body: jsonEncode(param),
          headers: headers
      );

      print(param.toString());
      print('response  is '+response.body);
      final responseJson = json.decode(response.body);


      if(response.statusCode>=400){
        return false;
      }
      if(responseJson['result']as bool){
        return true;
      }else{
        return false;

      }

    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<Map<String,dynamic>> forgotPassword(String phone) async {
    var param = {
      'email_or_phone':phone,
      'send_code_by': 'phone',

    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Requested-With':'XMLHttpRequest',
      'Current-Locale':Intl.getCurrentLocale()
    };

    try {
      var response = await http.post(
          Uri.parse('${Globals.BASE}auth/password/forget_request'),
          body: jsonEncode(param),
          headers: headers
      );

      print('response  is '+response.body);
      final responseJson = json.decode(response.body);


      if(response.statusCode>=400){
        return {'status':false,'message':responseJson['message']};
      }
      if(responseJson['result'].toString() =='true'){
        return {'status':true,'message':responseJson['message']};
      }else{
        return {'status':false,'message':responseJson['message']};

      }

    } catch (error) {
      print(error);
      return {'status':false,'message':'error occured'};
    }
  }
}

class User {
  User({
    this.id,
    this.name,
    this.avatar,
this.email,
    this.phone,
    this.address
  });

  int id;
  String name;
  String avatar;

  String phone;
  String email;
  String address;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: int.parse(json['id'].toString()),
    name: json['name'].toString(),
    avatar: json['avatar'].toString(),
    email: json['email'].toString(),

    phone: json['phone'].toString(),
    address:json['address'].toString()
  );


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['address'] = this.address;
    return data;
  }

}
