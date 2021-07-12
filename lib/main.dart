import 'dart:convert';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_is_emulator/flutter_is_emulator.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';
import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:provider/provider.dart';
import 'package:salon/blocs/app_observer.dart';
import 'package:salon/configs/app_theme.dart';
import 'package:salon/configs/app_globals.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/main_app.dart';
import 'package:salon/model/cart_provider.dart';
import 'package:salon/model/constants.dart';
import 'package:salon/utils/app_preferences.dart';

import 'package:salon/utils/bottom_bar_items.dart';import 'package:shared_preferences/shared_preferences.dart';

import 'model/loginmodel.dart';

GetIt getIt = GetIt.instance;

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();



  // Init service locator singletons.
  initServiceLocator();

  // Init remote logging service.
  createLogger();

  /// Running on emulator or real device?
  getIt.get<AppGlobals>().isEmulator = await FlutterIsEmulator.isDeviceAnEmulatorOrASimulator;
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  getIt.get<AppGlobals>().isUser = prefs.getBool('logged')??false;
  // Obtain a list of the available cameras on the device.
  if(getIt.get<AppGlobals>().isUser){
     final json = jsonDecode(prefs.getString('me')??null);
     if(json!=null){
       LoginModel loginModel = LoginModel.fromJson(json as Map<String,dynamic>);

       if(loginModel!=null){
         getIt.get<AppGlobals>().user.fullName = loginModel.user.name;
         getIt.get<AppGlobals>().user.token = loginModel.accessToken;
         getIt.get<AppGlobals>().user.id = loginModel.user.id;
          Globals.TOKEN = loginModel.accessToken;
         print(loginModel.user.name);

       }
     }
   }




  initCameras();

  /// The App's [BlocObserver].
  Bloc.observer = AppObserver();

  // Inflate the MainApp widget.
  runApp(ChangeNotifierProvider(
    create: (context) => CartProvider(),
    child: MainApp(),
  ),);
}

/// Completes with a list of available cameras.
Future<void> initCameras() async {
  /// Obtain a list of the available cameras on the device.
  final List<CameraDescription> cameras = await availableCameras();

  /// Save the list of available cameras.
  getIt.get<AppGlobals>().cameras = cameras;
}

/// Registers all the singletons we need by passing a factory function.
Future<void> initServiceLocator() async {
  getIt.registerLazySingleton<AppTheme>(() => AppTheme());
  getIt.registerLazySingleton<BottomBarItems>(() => BottomBarItems());
  getIt.registerLazySingleton<Location>(() => Location());
  getIt.registerLazySingleton<AppGlobals>(() => AppGlobals());

  final AppPreferences appPreferencesInstance = await AppPreferences.getInstance();
  getIt.registerSingleton<AppPreferences>(appPreferencesInstance);
}

/// Remote logging with Flutter on the logz.io ELK stack.
void createLogger() {
  if (!kReleaseMode || kLogzioToken.isEmpty) {
    return;
  }

  Logger.root.level = Level.ALL;

  LogzIoApiAppender(
    apiToken: kLogzioToken,
    url: kLogzioUrl,
    labels: <String, String>{'version': kAppVersion},
  ).attachToLogger(Logger.root);
}
