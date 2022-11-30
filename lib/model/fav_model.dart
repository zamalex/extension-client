import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:extension/model/constants.dart';

class FavModel{

  /// add or remove slaon from favourites
  Future addRemoveFav(String id) async {
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer ${Globals.TOKEN}',
        'Current-Locale':Intl.getCurrentLocale()
      };
      print('${Globals.TOKEN}');

      var response = await http.post(
        Uri.parse('${Globals.BASE}shops/$id/add-to-favourite'),
        headers: headers
      );
      print('${Globals.BASE}shops/$id/add-to-favourite');
      print('response  is '+response.body);

      if(response.statusCode>=400){
        return [];

      }else{
        final responseJson = json.decode(response.body);
        if(responseJson['success'] as bool==false){
          return [];
        }else{

          return [];
        }
      }



    } catch (error) {
      print(error);
      return [];
    }
  }
}

