import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:salon/blocs/appointment/appointment_bloc.dart';
import 'package:salon/blocs/auth/auth_bloc.dart';
import 'package:salon/blocs/booking/booking_bloc.dart';
import 'package:salon/blocs/chat/chat_bloc.dart';
import 'package:salon/blocs/cities/cities_bloc.dart';
import 'package:salon/blocs/favorites/favorites_bloc.dart';
import 'package:salon/blocs/loyalty/loyalty_bloc.dart';
import 'package:salon/blocs/ratings/ratings_bloc.dart';
import 'package:salon/blocs/search/search_bloc.dart';
import 'package:salon/blocs/theme/theme_bloc.dart';
import 'package:salon/configs/app_theme.dart';
import 'package:salon/configs/app_globals.dart';
import 'package:salon/configs/routes.dart';
import 'package:salon/screens/cart/cart.dart';
import 'package:salon/screens/onboarding.dart';
import 'package:salon/screens/products/products_list.dart';
import 'package:salon/screens/splash.dart';
import 'package:salon/screens/vendor/appointment_details.dart';
import 'package:salon/screens/vendor/order_details.dart';
import 'package:salon/screens/vendor/vendor_login.dart';
import 'package:salon/screens/verify.dart';
import 'package:salon/utils/localization.dart';
import 'package:salon/widgets/bottom_navigation.dart';
import 'package:intl/intl.dart' as intl;

import 'blocs/application/application_bloc.dart';

import 'generated/l10n.dart';
import 'main.dart';

/// The global RouteObserver.
final RouteObserver<PageRoute<dynamic>> routeObserver = RouteObserver<PageRoute<dynamic>>();

ApplicationBloc _applicationBloc;
AuthBloc _authBloc;
SearchBloc _searchBloc;
CitiesBloc _citiesBloc;
ThemeBloc _themeBloc;
AppointmentBloc _appointmentBloc;
FavoritesBloc _favoritesBloc;
LoyaltyBloc _loyaltyBloc;
BookingBloc _bookingBloc;
RatingsBloc _ratingsBloc;
ChatBloc _chatBloc;

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  @override
  void initState() {
    /// The glue between the widgets layer and the Flutter engine.
    WidgetsBinding.instance.addObserver(this);

    _initGlobalKeys();
    _initBlocs();

    super.initState();
  }

  /// Init all [Bloc]s here.
  void _initBlocs() {
    _authBloc = AuthBloc();
    _searchBloc = SearchBloc();
    _citiesBloc = CitiesBloc();
    _themeBloc = ThemeBloc();
    _appointmentBloc = AppointmentBloc();
    _favoritesBloc = FavoritesBloc();
    _loyaltyBloc = LoyaltyBloc();
    _ratingsBloc = RatingsBloc();
    _chatBloc = ChatBloc();

    _applicationBloc = ApplicationBloc(
      authBloc: _authBloc,
      themeBloc: _themeBloc,
    );

    _bookingBloc = BookingBloc(authBloc: _authBloc);
  }

  void _initGlobalKeys() {
    getIt.get<AppGlobals>().globalKeyBottomBar = GlobalKey(debugLabel: 'bottom_bar');
    getIt.get<AppGlobals>().globalKeyHomeScreen = GlobalKey(debugLabel: 'home_screen');
    getIt.get<AppGlobals>().globalKeySearchScreen = GlobalKey(debugLabel: 'search_screen');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _authBloc.close();
    _searchBloc.close();
    _citiesBloc.close();
    _themeBloc.close();
    _applicationBloc.close();
    _appointmentBloc.close();
    _favoritesBloc.close();
    _loyaltyBloc.close();
    _bookingBloc.close();
    _ratingsBloc.close();
    _chatBloc.close();

    super.dispose();
  }

  /// Called when the system puts the app in the background or returns the app
  /// to the foreground.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (getIt.get<AppGlobals>().isUserOnboarded) {
      /// Notify ApplicationBloc with a new [LifecycleChangedApplicationEvent].
      _applicationBloc.add(LifecycleChangedApplicationEvent(state: state));
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<ApplicationBloc>(create: (BuildContext context) => _applicationBloc),
        BlocProvider<AuthBloc>(create: (BuildContext context) => _authBloc),
        BlocProvider<SearchBloc>(create: (BuildContext context) => _searchBloc),
        BlocProvider<CitiesBloc>(create: (BuildContext context) => _citiesBloc),
        BlocProvider<ThemeBloc>(create: (BuildContext context) => _themeBloc),
        BlocProvider<AppointmentBloc>(create: (BuildContext context) => _appointmentBloc),
        BlocProvider<FavoritesBloc>(create: (BuildContext context) => _favoritesBloc),
        BlocProvider<LoyaltyBloc>(create: (BuildContext context) => _loyaltyBloc),
        BlocProvider<BookingBloc>(create: (BuildContext context) => _bookingBloc),
        BlocProvider<RatingsBloc>(create: (BuildContext context) => _ratingsBloc),
        BlocProvider<ChatBloc>(create: (BuildContext context) => _chatBloc),
      ],
      child: BlocBuilder<ApplicationBloc, ApplicationState>(
        buildWhen: (ApplicationState previousState, ApplicationState currentState) =>
            // Refresh app is lifecycle has been changed to Resumed state...
            (currentState is LifecycleChangeInProgressApplicationState && currentState.state == AppLifecycleState.resumed) ||
            currentState is! LifecycleChangeInProgressApplicationState,
        builder: (BuildContext context, ApplicationState appState) {
          Widget homeWidget;

          if (appState is UpdateLanguageSuccessApplicationState) {
            _initGlobalKeys();
          }

          if (appState is SetupSuccessApplicationState ||
              appState is UpdateLanguageSuccessApplicationState ||
              appState is LifecycleChangeInProgressApplicationState) {
            homeWidget = getIt.get<AppGlobals>().isUserOnboarded ?  Phoenix(child: BottomNavigation()) : Phoenix(child: OnboardingScreen());
          } else {
            homeWidget =   Phoenix(child: SplashScreen());
          }

          final Locale selectedLocale = getIt.get<AppGlobals>().selectedLocale;
          getIt.get<AppGlobals>().isRTL = intl.Bidi.isRtlLanguage(selectedLocale.toString());

          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (BuildContext context, ThemeState theme) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                locale: selectedLocale,
                supportedLocales: L10n.delegate.supportedLocales,
                localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
                  L10n.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate, // Needed for iOS!
                  FallbackCupertinoLocalisationsDelegate(),
                ],
                localeResolutionCallback: (Locale locale, Iterable<Locale> supportedLocales) => selectedLocale,
                navigatorObservers: <NavigatorObserver>[routeObserver],
                onGenerateRoute: Routes().generateRoute,
                theme: getIt.get<AppTheme>().lightTheme,
                darkTheme: getIt.get<AppTheme>().darkTheme,
                home: Directionality(
                  textDirection: getIt.get<AppGlobals>().isRTL ? TextDirection.rtl : TextDirection.ltr,
                  child: homeWidget,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
