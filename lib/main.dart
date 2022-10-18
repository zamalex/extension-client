import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_sell_sdk_flutter/go_sell_sdk_flutter.dart';
import 'package:location/location.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
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
import 'model/share_data.dart';

GetIt getIt = GetIt.instance;
ShareData shareData = ShareData(salon: 0,product: 0,type: 0);

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
    name: 'salon-customer',
    options: Platform.isAndroid || Platform.isIOS
        ? FirebaseOptions(
      appId: '1:923766598429:android:8c89238bc6d4b52a3e4ff4',
      apiKey: 'AAAA1xTHqx0:APA91bG00Y1YvTUxeZUo6QKg68FEc2uZxwvZoL3X8l75NBfBoypczfZpL51FGUSKVuFo0TSk68iz5htCDKXYnx9773PF7NDLDd85NEzYXaAMByQZvZTjAivNgqiXFqumLAmkox-V868Y',
      projectId: 'salon-customer-6c286',
      messagingSenderId: '923766598429',
      databaseURL: 'https://salon-customer-6c286-default-rtdb.firebaseio.com',
    )
        : FirebaseOptions(
      appId: '1:923766598429:ios:be1aefc009dae2143e4ff4',
      apiKey: 'AAAA1xTHqx0:APA91bG00Y1YvTUxeZUo6QKg68FEc2uZxwvZoL3X8l75NBfBoypczfZpL51FGUSKVuFo0TSk68iz5htCDKXYnx9773PF7NDLDd85NEzYXaAMByQZvZTjAivNgqiXFqumLAmkox-V868Y',
      projectId: 'salon-customer-6c286',
      messagingSenderId: '923766598429',
      databaseURL: 'https://salon-customer-6c286-default-rtdb.firebaseio.com',
    ),
  );




// Print the data of the snapshot
  // Get any initial links
  // Init service locator singletons.
  //Remove this method to stop OneSignal Debugging
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId("a72e072e-86c4-443f-9001-e8a8d82b0d86");

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });

  OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
    // Will be called whenever a notification is received in foreground
    // Display Notification, pass null param for not displaying the notification
    event.complete(event.notification);
  });

  OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    // Will be called whenever a notification is opened/button pressed.
  });

  OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
    // Will be called whenever the permission changes
    // (ie. user taps Allow on the permission prompt in iOS)
  });

  OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) {
    // Will be called whenever the subscription changes
    // (ie. user gets registered with OneSignal and gets a user ID)
  });

  OneSignal.shared.setEmailSubscriptionObserver((OSEmailSubscriptionStateChanges emailChanges) {
    // Will be called whenever then user's email subscription changes
    // (ie. OneSignal.setEmail(email) is called and the user gets registered
  });
  initServiceLocator();

  // Init remote logging service.
  createLogger();

  /// Running on emulator or real device?
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
         getIt.get<AppGlobals>().user.phone= loginModel.user.phone;
         getIt.get<AppGlobals>().user.email= loginModel.user.email;

         getIt.get<AppGlobals>().ID = loginModel.user.id;
          Globals.TOKEN = loginModel.accessToken;
         print(loginModel.user.name);
         final status = await OneSignal.shared.getDeviceState();
         final String osUserID = status.userId;

         print('onesignal id $osUserID');
          if(osUserID!=null)
            getIt.get<AppGlobals>().sendPlayerID(osUserID);
       }
     }
   }




  initCameras();

  /// The App's [BlocObserver].
  Bloc.observer = AppObserver();

  runApp(ChangeNotifierProvider(
    create: (context) => CartProvider(),
    child: MainApp(shareData: shareData,),
  ),);
}

/// Completes with a list of available cameras.
Future<void> initCameras() async {
  /// Obtain a list of the available cameras on the device.
  //final List<CameraDescription> cameras = await availableCameras();

  /// Save the list of available cameras.
 // getIt.get<AppGlobals>().cameras = cameras;
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

 /* Logger.root.level = Level.ALL;

  LogzIoApiAppender(
    apiToken: kLogzioToken,
    url: kLogzioUrl,
    labels: <String, String>{'version': kAppVersion},
  ).attachToLogger(Logger.root);*/
}
