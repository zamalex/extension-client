import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:extension/configs/app_globals.dart';
import 'package:extension/model/constants.dart';

import '../main.dart';

class ProfileData {


  /// upload user image
  Future<bool> updateImage(String filename,String image) async {

    final Map<String, String> headers = {
      'Authorization': 'Bearer ${Globals.TOKEN}',
      'Content-Type': 'application/json',
      'Current-Locale':Intl.getCurrentLocale()
    };

    Map<String,dynamic> body = {
      'id':'${getIt.get<AppGlobals>().ID}',
      'filename':filename,
      'image':image
    };


    try {
      var response = await http.post(
          Uri.parse('${Globals.BASE}profile/update-image'),
          headers: headers,
          body: jsonEncode(body)
      );
      print('response  is '+response.body);

      if(response.statusCode>=400){
        return false;

      }else{
        final responseJson = json.decode(response.body);
        if(responseJson['result'] as bool==false){
          return false;
        }else{
          return true;
        }
      }



    } catch (error) {
      print(error);
      return false;
    }
  }



  /// update profile
  Future<bool> updateProfile(String name,String phone,String email,String address,String city) async {

    final Map<String, String> headers = {
      'Authorization': 'Bearer ${Globals.TOKEN}',
      'Content-Type': 'application/json',
      'Current-Locale':Intl.getCurrentLocale()
    };

    Map<String,dynamic> body = {
      'id':'${getIt.get<AppGlobals>().ID}',
      'name':name,
      'phone':phone,
      'email':email,
      'address':address,
      'latitude' : '',
      'longitude' : '',
      'password':''
    };

    print(body.toString());
    print('${Globals.BASE}profile/update');


    try {
      var response = await http.post(
          Uri.parse('${Globals.BASE}profile/update'),
          headers: headers,
          body: jsonEncode(body)
      );
      print('response  is '+response.body);

      if(response.statusCode>=400){
        return false;

      }else{
        final responseJson = json.decode(response.body);
        if(responseJson['result'] as bool==false){
          return false;
        }else{
          return true;
        }
      }



    } catch (error) {
      print(error);
      return false;
    }
  }


}