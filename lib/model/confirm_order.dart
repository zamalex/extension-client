
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:extension/utils/ui.dart';

import 'constants.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:extension/model/constants.dart';

class ConfirmOrder {


  /// confirm booking
  Future<Map> confirmBooking(Map<String,dynamic> body,BuildContext context) async {

    Map<String, String> headers = {
      'Authorization': 'Bearer ${Globals.TOKEN}',
      'Content-Type': 'application/json',
      'Current-Locale':Intl.getCurrentLocale()
    };
    // print('${Globals.TOKEN}');

    try {
      var response = await http.post(
          Uri.parse('${Globals.BASE}booking/store'),
          headers: headers,
        body: jsonEncode(body)
      );
      print('request is ${Globals.BASE}booking/store');
      print('body  is ${jsonEncode(body)}');
      print('respoonse is ${response.body}');

      final responseJson = json.decode(response.body);

      if(responseJson['result']as bool==false){



            UI.showErrorDialog(context,message:responseJson['message'].toString());

        return {
          'result':false,
          'message':responseJson['message']
        };
      }else{
        return {
          'booking_id':responseJson['booking_id'],
          'result':true,
          'message':responseJson['message']
        };
      }

    } catch (error) {
      print(error);
      UI.showErrorDialog(context,message:error.toString());

      return {
        'result':false,
        'message':error.toString()
      };
    }
  }
  Future<Map> confirmPackageBooking(Map<String,dynamic> body,BuildContext context) async {

    Map<String, String> headers = {
      'Authorization': 'Bearer ${Globals.TOKEN}',
      'Content-Type': 'application/json',
      'Current-Locale':Intl.getCurrentLocale()
    };
    // print('${Globals.TOKEN}');

    try {
      var response = await http.post(
          Uri.parse('${Globals.BASE}package/store'),
          headers: headers,
        body: jsonEncode(body)
      );
      print('request is ${Globals.BASE}package/store');
      print('body  is ${jsonEncode(body)}');
      print('respoonse is ${response.body}');

      final responseJson = json.decode(response.body);

      if(responseJson['result']as bool==false){



            UI.showErrorDialog(context,message:responseJson['message'].toString());

        return {
          'result':false,
          'message':responseJson['message']
        };
      }else{
        return {
          'booking_id':responseJson['booking_id'],
          'result':true,
          'message':responseJson['message']
        };
      }

    } catch (error) {
      print(error);
      UI.showErrorDialog(context,message:error.toString());

      return {
        'result':false,
        'message':error.toString()
      };
    }
  }

}



