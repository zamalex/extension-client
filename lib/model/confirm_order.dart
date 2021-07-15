import 'constants.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:salon/model/constants.dart';

class ConfirmOrder {

  Future confirmBooking(Map<String,dynamic> body) async {

    Map<String, String> headers = {
      'Authorization': 'Bearer ${Globals.TOKEN}',
      'Content-Type': 'application/json'
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
      return [];
    } catch (error) {
      print(error);
      return [];
    }
  }

}



