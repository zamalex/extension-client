
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:salon/utils/ui.dart';

import 'constants.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:salon/model/constants.dart';

class ConfirmOrder {

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
          'result':true,
          'message':responseJson['message']
        };
      }
      /*if(response.statusCode>=400){

      }else{
        final responseJson = json.decode(response.body);
        print('respoonse is ${response.body}');

        if(responseJson['result'] as bool==false){
          return [];
        }else{
          return null;//BookingDayTimes.fromJson(responseJson as Map<String,dynamic>).data.slots;
        }
      }

      print('response  is '+response.body);

*/
      // print(responseJson);

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



