import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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


  Future<LoginModel> loginUser(String email, String password) async {
    var param = {
      'phone': email,
      'email': email,
      'password': password,
    };



    try {
      var response = await http.post(
        Uri.parse('http://salon.badee.com.sa/api/v2/auth/login'),
        body: param,
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
      'X-Requested-With':'XMLHttpRequest'
    };

    try {
      var response = await http.post(
        Uri.parse('http://salon.badee.com.sa/api/v2/auth/signup'),
        body: jsonEncode(param),
        headers: headers
      );

      print(param.toString());
      print('response  is '+response.body);
      final responseJson = json.decode(response.body);


      if(response.statusCode>=400){
        return {'status':false,'message':responseJson['message']};
      }

       return {'status':true,'message':responseJson['message']};
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
      'X-Requested-With':'XMLHttpRequest'
    };

    try {
      var response = await http.post(
          Uri.parse('http://salon.badee.com.sa/api/v2/auth/confirm_code'),
          body: jsonEncode(param),
          headers: headers
      );

      print(param.toString());
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


  Future<Map<String,dynamic>> forgotPassword(String phone) async {
    var param = {
      'email_or_phone':phone,
      'send_code_by': 'phone',

    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Requested-With':'XMLHttpRequest'
    };

    try {
      var response = await http.post(
          Uri.parse('http://salon.badee.com.sa/api/v2/auth/password/forget_request'),
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

    this.phone,
  });

  int id;
  String name;
  String avatar;

  String phone;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: int.parse(json['id'].toString()),
    name: json['name'].toString(),
    avatar: json['avatar'].toString(),

    phone: json['phone'].toString(),
  );


}
