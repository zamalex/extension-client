import 'dart:io';

import 'package:intl/intl.dart';

import 'constants.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:extension/model/constants.dart';


///working hours model
class BookingWeekTimes {
  Data data;
  bool result;
  String message;

  BookingWeekTimes({this.data, this.result, this.message});

  BookingWeekTimes.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ?  Data.fromJson(json['data'] as Map<String,dynamic>) : null;
    result = json['result']as bool;
    message = json['message'].toString()??'';
  }


  /// get salon working hours
  Future<List<Slots>> getWeekTimes(String id) async {

    Map<String, String> headers = {
      'Authorization': 'Bearer ${Globals.TOKEN}',
      'Content-Type': 'application/json',

      'Current-Locale':Intl.getCurrentLocale()
    };

    // print('${Globals.TOKEN}');


    try {
      var response = await http.post(
          Uri.parse('${Globals.BASE}shop/workingHours'),
          headers: headers,
          body: jsonEncode({'shop_id':id})
      );
      print('request is ${Globals.BASE}shop/workingHours');
      if(response.statusCode>=400){

      }else{
        final responseJson = json.decode(response.body);
        print('respoonse is ${response.body}');

        if(responseJson['result'] as bool==false){
          return [];
        }else{
          return BookingWeekTimes.fromJson(responseJson as Map<String,dynamic>).data.slots;
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
  List<Slots> slots;

  Data({this.slots});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['slots'] != null) {
      slots = [];
      json['slots'].forEach((v) {
        slots.add( Slots.fromJson(v as Map<String,dynamic>));
      });
    }
  }




}

class Slots {
  int id;
  int day;
  String startTime;
  String endTime;

  Slots({this.id, this.day, this.startTime, this.endTime});

  Slots.fromJson(Map<String, dynamic> json) {
    id = json['id']as int??0;
    day = json['day']as int;
    startTime = json['time'].toString();
    endTime = json['end_time'].toString();
  }

}