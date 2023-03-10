import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:extension/configs/app_theme.dart';
import 'package:extension/data/models/category_model.dart';
import 'package:extension/data/models/user_model.dart';
import 'package:extension/model/constants.dart';
import 'package:extension/model/share_data.dart';
import 'package:http/http.dart' as http;

/// Class to store runtime global settings.
class AppGlobals {
  factory AppGlobals() => instance;

  AppGlobals._();


  int serviceIndex = 0;

  /// Singleton instance.
  static final AppGlobals instance = AppGlobals._();


  String getStatus(String status){

    if(isRTL??false){
      switch (status.toLowerCase()) {
        case 'picked_up':
        case 'confirmed':
        case 'approved':
          return 'تم التأكيد';
          break;
        case 'delivered':
        case 'finished':
        case 'completed':
          return 'مكتمل';
          break;
        case 'canceled':
          return 'ملغي';
          break;
        case 'rejected':
          return 'مرفوض';
          break;
        case 'on_the_way':
        case 'active':
        case 'on_delivery':
        case  'processing':
          return 'جاري التنفيذ';
          break;
        case 'pending':
          return 'قيد الانتظار';
          break;
        default:
          return 'قيد الانتظار';
      }
    }
    else{
      switch (status.toLowerCase()) {
        case 'picked_up':
        case 'confirmed':
        case 'approved':
          return 'confirmed';
          break;
        case 'delivered':
        case 'finished':
        case 'completed':
          return 'completed';
          break;
        case 'canceled':
          return 'canceled';
          break;
        case 'rejected':
          return 'rejected';
          break;
        case 'on_the_way':
        case 'active':
        case 'on_delivery':
        case  'processing':
          return 'processing';
          break;
        case 'pending':
          return 'pending';
          break;
        default:
          return 'pending';
      }
    }

  }

  Future sendPlayerID(String id) async {

    Map<String, String> headers = {
      'Authorization': 'Bearer ${Globals.TOKEN}',
      'Content-Type': 'application/json',
      'Current-Locale':Intl.getCurrentLocale()
    };

    Map<String,dynamic> body = {
      'player_id':id,
    };


    try {
      var response = await http.post(
          Uri.parse('${Globals.BASE}notifications/subscribe'),
          headers: headers,
          body:jsonEncode(body)
      );

      print('request  is '+'${Globals.BASE}notifications/subscribe');
      print('response  is '+response.body);
      print('body  is '+body.toString());


      return true;

    } catch (error) {
      print(error);
      return false;
    }
  }

  /// List of available cameras on device.
 // List<CameraDescription> cameras;

  /// [GlobalKey] for our bottom bar.
  GlobalKey globalKeyBottomBar;

  /// [GlobalKey] for our [HomeScreen].
  GlobalKey globalKeyHomeScreen;

  /// [GlobalKey] for our [SearchScreen].
  GlobalKey globalKeySearchScreen;

  /// [GlobalKey] for tab bar in [SearchScreen].
  GlobalKey globalKeySearchTabs;

  /// Dark Theme option
  DarkOption darkThemeOption = DarkOption.dynamic;

  /// User's current position.
  LocationData currentPosition;

  /// Business/Location categories.
  List<CategoryModel> categories;

  /// Logged in user data.
  UserModel user=UserModel(0, 'Mohamed El-Katteb', 'profilePhoto', 'mkhatteb@badee.com', 'phone', 'city', 'zip', '', 0, 0);
  int ID;
  bool isUser=false;
  /// Currently selected [Locale].
  Locale selectedLocale;

  /// Is user onbaorded or this is their first run?
  bool isUserOnboarded = false;

  /// App is running on emulator (or real device)?
  bool isEmulator;

  /// Is the current locale RTL?
  bool isRTL;

  /// The current brightness mode of the host platform.
  Brightness get getPlatformBrightness => SchedulerBinding.instance.window.platformBrightness;

  /// Is the current brightness mode of the host platform dark?
  bool get isPlatformBrightnessDark {
    switch (darkThemeOption) {
      case DarkOption.alwaysOff:
        return false;
        break;
      case DarkOption.alwaysOn:
        return true;
      default:
        return Brightness.dark == getPlatformBrightness;
    }
  }
}
