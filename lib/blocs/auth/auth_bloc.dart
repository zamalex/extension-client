import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:extension/blocs/base_bloc.dart';
import 'package:extension/configs/app_globals.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/data/models/data_response_model.dart';
import 'package:extension/data/models/user_model.dart';
import 'package:extension/main.dart';
import 'package:extension/model/loginmodel.dart';
import 'package:extension/model/profile_data.dart';
import 'package:extension/utils/app_cache_manager.dart';
import 'package:extension/utils/app_preferences.dart';

import 'package:flutter/material.dart';
import 'package:extension/data/models/payment_card_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repositories/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  AuthBloc() : super(InitialAuthState());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is NewPasswordRequestedAuthEvent) {
      yield* _mapRequestNewPasswordAuthEventToState(event);
    } else if (event is UserRegisteredAuthEvent) {
      yield* _mapOnRegisterAuthEventToState(event);
    } else if (event is LoginRequestedAuthEvent) {
      yield* _mapLoginAuthEventToState(event);
    } else if (event is UserSavedAuthEvent) {
      yield* _mapSaveUserAuthEventToState(event);
    } else if (event is ProfileLoadedAuthEvent) {
      yield* _mapGetProfileAuthEventToState();
    } else if (event is UserLoggedOutAuthEvent) {
      yield* _mapLogoutAuthEventToState();
    } else if (event is UserClearedAuthEvent) {
      yield* _mapClearUserAuthEventToState();
    } else if (event is ProfileUpdatedAuthEvent) {
      yield* _mapProfileUpdateAuthEventToState(event);
    } else if (event is PaymentCardSavedAuthEvent) {
      yield* _mapSavePaymentCardAuthEventToState(event);
    }
  }

  Stream<AuthState> _mapRequestNewPasswordAuthEventToState(NewPasswordRequestedAuthEvent event) async* {
    yield ProcessInProgressAuthState();

    // Wait for some random time. Simulate net activity ;)
    await Future<int>.delayed(Duration(seconds: Random().nextInt(2)));

    yield ForgetPasswordSuccessAuthState();

  }

  Stream<AuthState> _mapOnRegisterAuthEventToState(UserRegisteredAuthEvent event) async* {
    ///Notify loading to UI
    yield ProcessInProgressAuthState();

    //getIt.get<AppGlobals>().user = await const UserRepository().getProfile();

     final result = await UserRepository().register(name: event.fullName,email: event.email,password: event.password);

     if(result['status']as bool){
       yield LoginSuccessAuthState(user_id: result['user_id']as int??0);

     }else{
       yield RegistrationFailureAuthState(result['message'].toString());
     }


  }

  Stream<AuthState> _mapLoginAuthEventToState(LoginRequestedAuthEvent event) async* {
    ///Notify loading to UI
    yield ProcessInProgressAuthState();

    final LoginModel user = await const UserRepository().login(
      email: event.email,
      password: event.password,
    );

    if (user==null||user.user==null) {
      yield LoginFailureAuthState('invalid user data');
    } else {
     // getIt.get<AppGlobals>().user = UserModel.fromJson(user.data);
     // AppCacheManager().emptyCache();

      try {
     //   add(UserSavedAuthEvent(getIt.get<AppGlobals>().user));

        yield LoginSuccessAuthState(loginModel: user);
      } catch (error) {
        yield LoginFailureAuthState(error.toString());
      }
    }
  }


  Stream<AuthState> _mapSaveUserAuthEventToState(UserSavedAuthEvent event) async* {
    AppCacheManager().emptyCache();

    ///Save to Storage phone
    final bool savePreferences = await getIt.get<AppPreferences>().setString(PreferenceKey.user, event.user.id.toString());

    if (savePreferences) {
      yield PreferenceSaveSuccessAuthState();
    }
  }

  /// get user profile
  Stream<AuthState> _mapGetProfileAuthEventToState() async* {
    yield ProcessInProgressAuthState();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final bool hasToken = getIt.get<AppPreferences>().containsKey(PreferenceKey.user);

    if (hasToken) {
      //getIt.get<AppGlobals>().user = await const UserRepository().getProfile();

      add(UserSavedAuthEvent(getIt.get<AppGlobals>().user));
    } else {
      yield AuthenticationFailureAuthState();
    }
  }


  ///logout user
  Stream<AuthState> _mapLogoutAuthEventToState() async* {
    yield ProcessInProgressAuthState();

       SharedPreferences prefs = await SharedPreferences.getInstance();
       prefs.setBool("logged", false);getIt.get<AppGlobals>().isUser=false;
    try {
      add(UserClearedAuthEvent());

      yield LogoutSuccessAuthState();
    } catch (error) {
      yield LogoutFailureAuthState(error.toString());
    }
  }


  ///clear user data
  Stream<AuthState> _mapClearUserAuthEventToState() async* {
    final bool deletePreferences = await getIt.get<AppPreferences>().remove(PreferenceKey.user);

    if (deletePreferences) {
     // getIt.get<AppGlobals>().user = null;
      yield AuthenticationFailureAuthState();
    }
  }

  Stream<AuthState> _mapProfileUpdateAuthEventToState(ProfileUpdatedAuthEvent event) async* {
    yield ProcessInProgressAuthState();

    
   /* if(event.image!=null){
      final bytes =
      event.image.readAsBytesSync();
      String img64 = base64Encode(bytes);
      print(event.image.path.split('/').last);
     await ProfileData().updateImage(event.image.path.split('/').last, img64);
    }

    await ProfileData().updateProfile(event.fullName,event.phone,event.email,event.address);*/

    //getIt.get<AppGlobals>().user = await const UserRepository().getProfile();

    //add(UserSavedAuthEvent(getIt.get<AppGlobals>().user));

    yield ProfileUpdateSuccessAuthState();
  }



  Stream<AuthState> _mapSavePaymentCardAuthEventToState(PaymentCardSavedAuthEvent event) async* {
    yield ProcessInProgressAuthState();

    // Wait for some random time. Simulate net activity ;)
    await Future<int>.delayed(Duration(seconds: Random().nextInt(2)));

    yield PaymentCardSaveSuccessAuthState();
  }
}
