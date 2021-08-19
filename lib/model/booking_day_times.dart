import 'dart:io';

import 'package:intl/intl.dart';

import 'constants.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:salon/model/constants.dart';

class BookingDayTimes {
  Data data;
  bool result;
  String message;

  BookingDayTimes({this.data, this.result, this.message});

  BookingDayTimes.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']as Map<String,dynamic>) : null;
    result = json['result']as bool;
    message = json['message'].toString();
  }
  Future<List<Slot>> getDayTimes(String id,String date) async {

    Map<String, String> headers = {
      'Authorization': 'Bearer ${Globals.TOKEN}',
      'Current-Locale':Intl.getCurrentLocale()
    };
    // print('${Globals.TOKEN}');

    try {
      var response = await http.get(
          Uri.parse('${Globals.BASE}booking/$id/available-slots?date=$date'),
          headers: headers
      );
      print('request is ${Globals.BASE}booking/$id/available-slots?date=$date');
      if(response.statusCode>=400){

      }else{
        final responseJson = json.decode(response.body);
        print('respoonse is ${response.body}');

        if(responseJson['result'] as bool==false){
          return [];
        }else{
          return BookingDayTimes.fromJson(responseJson as Map<String,dynamic>).data.slots;
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
  List<Slot> slots;

  Data({this.slots});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['slots'] != null) {
      slots = [];
      json['slots'].forEach((v) {
        slots.add(Slot.fromJson(v as Map<String,dynamic>));
      });
    }
  }


}

class Slot {
  int id;
  String time;

  Slot({this.id, this.time});

  Slot.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    time = json['time'].toString();
  }


}