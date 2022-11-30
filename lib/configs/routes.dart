import 'package:flutter/material.dart';
import 'package:extension/configs/app_globals.dart';
import 'package:extension/data/models/appointment_model.dart';
import 'package:extension/data/models/location_model.dart';
import 'package:extension/data/models/voucher_model.dart';
import 'package:extension/main.dart';
import 'package:extension/model/appointments_data.dart';
import 'package:extension/screens/appointment/appointment.dart';
import 'package:extension/screens/booking/booking.dart';
import 'package:extension/screens/booking/widgets/booking_notes.dart';
import 'package:extension/screens/edit_profile/edit_profile.dart';
import 'package:extension/screens/edit_profile/take_picture.dart';
import 'package:extension/screens/empty.dart';
import 'package:extension/screens/favorites.dart';
import 'package:extension/screens/forgot_password.dart';
import 'package:extension/screens/location/location.dart';
import 'package:extension/screens/orders/orders.dart';

import 'package:extension/screens/photo_gallery.dart';
import 'package:extension/screens/photo_view.dart';
import 'package:extension/screens/rating/rating.dart';
import 'package:extension/screens/rating/rating_success_dialog.dart';
import 'package:extension/screens/ratings/ratings.dart';
import 'package:extension/screens/reviews.dart';
import 'package:extension/screens/search/search_map.dart';
import 'package:extension/screens/settings.dart';
import 'package:extension/screens/sign_up.dart';

import 'package:extension/widgets/picker.dart';

/// Generate [MaterialPageRoute] for our screens.
class Routes {
  static const String location = '/location';
  static const String locationReviews = '/location/reviews';
  static const String locationGallery = '/location/gallery';
  static const String locationGalleryView = '/location/gallery/view';
  static const String picker = '/picker';
  static const String searchMap = '/search/map';
  static const String forgotPassword = '/forgotPassword';
  static const String signUp = '/signUp';
  static const String settings = '/settings';
  static const String editProfile = '/editProfile';
  static const String takePicture = '/takePicture';
  static const String favorites = '/favorites';
  static const String vouchers = '/vouchers';
  static const String voucher = '/voucher';
  static const String booking = '/booking';
  static const String bookingNotes = '/booking/notes';
  static const String appointment = '/appointment';
  static const String appointmentRating = '/appointment/rating';
  static const String appointmentRatingSuccess = '/appointment/rating/success';
  static const String ratings = '/ratings';
  static const String paymentCard = '/paymentCard';
  static const String addPaymentCard = '/paymentCard/add';
  static const String invite = '/invite';
  static const String chat = '/chat';

  Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case location:
        return MaterialPageRoute<LocationScreen>(
          builder: (BuildContext context) {
            return Directionality(
              textDirection: getIt.get<AppGlobals>().isRTL ? TextDirection.rtl : TextDirection.ltr,
              child: LocationScreen(locationId: routeSettings.arguments as LocationModel,),
            );
          },
          settings: const RouteSettings(name: location),
        );
      case locationReviews:
        return MaterialPageRoute<ReviewsScreen>(
          builder: (BuildContext context) {
            return Directionality(
              textDirection: getIt.get<AppGlobals>().isRTL ? TextDirection.rtl : TextDirection.ltr,
              child: ReviewsScreen(location: routeSettings.arguments as LocationModel),
            );
          },
          settings: const RouteSettings(name: locationReviews),
        );
      case picker:
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) {
            return Directionality(
              textDirection: getIt.get<AppGlobals>().isRTL ? TextDirection.rtl : TextDirection.ltr,
              child: Picker(params: routeSettings.arguments as Map<String, dynamic>),
            );
          },
        );
      case locationGallery:
        return MaterialPageRoute<PhotoGalleryScreen>(
          builder: (BuildContext context) {
            return Directionality(
              textDirection: getIt.get<AppGlobals>().isRTL ? TextDirection.rtl : TextDirection.ltr,
              child: PhotoGalleryScreen(params: routeSettings.arguments as Map<String, dynamic>),
            );
          },
        );
      case locationGalleryView:
        return MaterialPageRoute<PhotoViewScreen>(
          builder: (BuildContext context) {
            return Directionality(
              textDirection: getIt.get<AppGlobals>().isRTL ? TextDirection.rtl : TextDirection.ltr,
              child: PhotoViewScreen(params: routeSettings.arguments as Map<String, dynamic>),
            );
          },
        );
      case searchMap:
        return MaterialPageRoute<SearchMapScreen>(
          builder: (BuildContext context) {
            return Directionality(
              textDirection: getIt.get<AppGlobals>().isRTL ? TextDirection.rtl : TextDirection.ltr,
              child: SearchMapScreen(params: routeSettings.arguments as Map<String, dynamic>),
            );
          },
        );
      case forgotPassword:
        return MaterialPageRoute<ForgotPasswordScreen>(
          builder: (BuildContext context) {
            return Directionality(
              textDirection: getIt.get<AppGlobals>().isRTL ? TextDirection.rtl : TextDirection.ltr,
              child: const ForgotPasswordScreen(),
            );
          },
        );
      case signUp:
        return MaterialPageRoute<SignUpScreen>(
          builder: (BuildContext context) {
            return Directionality(
              textDirection: getIt.get<AppGlobals>().isRTL ? TextDirection.rtl : TextDirection.ltr,
              child: const SignUpScreen(),
            );
          },
        );
      case settings:
        return MaterialPageRoute<SettingsScreen>(
          builder: (BuildContext context) {
            return Directionality(
              textDirection: getIt.get<AppGlobals>().isRTL ? TextDirection.rtl : TextDirection.ltr,
              child: const SettingsScreen(),
            );
          },
        );
      case editProfile:
        return MaterialPageRoute<EditProfileScreen>(
          builder: (BuildContext context) {
            return Directionality(
              textDirection: getIt.get<AppGlobals>().isRTL ? TextDirection.rtl : TextDirection.ltr,
              child: const EditProfileScreen(),
            );
          },
        );
      case takePicture:
        return MaterialPageRoute<String>(
          builder: (BuildContext context) {
            return Directionality(
              textDirection: getIt.get<AppGlobals>().isRTL ? TextDirection.rtl : TextDirection.ltr,
              child: const TakePictureScreen(),
            );
          },
        );
      case favorites:
        return MaterialPageRoute<String>(
          builder: (BuildContext context) {
            return Directionality(
              textDirection: getIt.get<AppGlobals>().isRTL ? TextDirection.rtl : TextDirection.ltr,
              child: const FavoritesScreen(),
            );
          },
        );
      case vouchers:
        return MaterialPageRoute<String>(
          builder: (BuildContext context) {
            return Directionality(
              textDirection: getIt.get<AppGlobals>().isRTL ? TextDirection.rtl : TextDirection.ltr,
              child: const OrdersScreen(),
            );
          },
        );

      case booking:
        return MaterialPageRoute<BookingScreen>(
          builder: (BuildContext context) {
            return Directionality(
              textDirection: getIt.get<AppGlobals>().isRTL ? TextDirection.rtl : TextDirection.ltr,
              child: BookingScreen(params: routeSettings.arguments as Map<String, dynamic>),
            );
          },
          fullscreenDialog: true,
        );
      case bookingNotes:
        return MaterialPageRoute<String>(
          builder: (BuildContext context) {
            return Directionality(
              textDirection: getIt.get<AppGlobals>().isRTL ? TextDirection.rtl : TextDirection.ltr,
              child: BookingNotes(notes: routeSettings.arguments as String),
            );
          },
        );
      case appointment:
        return MaterialPageRoute<AppointmentScreen>(
          builder: (BuildContext context) {
            return Directionality(
              textDirection: getIt.get<AppGlobals>().isRTL ? TextDirection.rtl : TextDirection.ltr,
              child: AppointmentScreen(appointment: routeSettings.arguments as Data),
            );
          },
        );
      case appointmentRating:
        return MaterialPageRoute<AppointmentModel>(
          builder: (BuildContext context) {
            return Directionality(
              textDirection: getIt.get<AppGlobals>().isRTL ? TextDirection.rtl : TextDirection.ltr,
              child: RatingScreen(appointment: routeSettings.arguments as AppointmentModel),
            );
          },
        );
      case appointmentRatingSuccess:
        return MaterialPageRoute<RatingSuccessDialog>(
          builder: (BuildContext context) {
            return Directionality(
              textDirection: getIt.get<AppGlobals>().isRTL ? TextDirection.rtl : TextDirection.ltr,
              child: RatingSuccessDialog(),
            );
          },
        );
      case ratings:
        return MaterialPageRoute<RatingsScreen>(
          builder: (BuildContext context) {
            return Directionality(
              textDirection: getIt.get<AppGlobals>().isRTL ? TextDirection.rtl : TextDirection.ltr,
              child: RatingsScreen(),
            );
          },
        );


      default:
        return MaterialPageRoute<EmptyScreen>(
          builder: (BuildContext context) {
            return Directionality(
              textDirection: getIt.get<AppGlobals>().isRTL ? TextDirection.rtl : TextDirection.ltr,
              child: const EmptyScreen(),
            );
          },
        );
    }
  }
}
