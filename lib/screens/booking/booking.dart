import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_sell_sdk_flutter/go_sell_sdk_flutter.dart';
import 'package:go_sell_sdk_flutter/model/models.dart';
import 'package:provider/provider.dart';
import 'package:salon/blocs/booking/booking_bloc.dart';
import 'package:salon/configs/app_globals.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/data/models/booking_session_model.dart';
import 'package:salon/data/models/booking_wizard_page_model.dart';
import 'package:salon/data/models/location_model.dart';
import 'package:salon/data/models/service_group_model.dart';
import 'package:salon/data/models/service_model.dart';
import 'package:salon/data/models/staff_model.dart';
import 'package:salon/generated/l10n.dart';
import 'package:salon/model/cart_provider.dart';
import 'package:salon/model/confirm_order.dart';
import 'package:salon/screens/booking/widgets/booking_step1.dart';
import 'package:salon/screens/booking/widgets/booking_step2.dart';
import 'package:salon/screens/booking/widgets/booking_step3.dart';
import 'package:salon/screens/booking/widgets/booking_step4.dart';
import 'package:salon/screens/booking/widgets/booking_success_dialog.dart';
import 'package:salon/utils/ui.dart';
import 'package:salon/widgets/full_screen_indicator.dart';
import 'package:salon/widgets/loading_overlay.dart';
import 'package:salon/widgets/portrait_mode_mixin.dart';
import 'package:salon/widgets/sliver_app_title.dart';
import 'package:salon/utils/text_style.dart';
import 'package:salon/widgets/strut_text.dart';
import 'package:salon/widgets/theme_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprintf/sprintf.dart';

import '../../main.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({
    Key key,
    this.params,
  }) : super(key: key);

  final Map<String, dynamic> params;

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> with PortraitStatefulModeMixin<BookingScreen> {
  Map<dynamic, dynamic> tapSDKResult;
  String responseID = "";
  String sdkStatus = "";
  String sdkErrorCode;
  String sdkErrorMessage;
  String sdkErrorDescription;

  final int totalSteps = 4;
  String txt = getIt.get<AppGlobals>().isRTL?'سيتم حذف عربة التسوق الخاصة بك':'Your cart will be deleted';

  int _locationId = 0;
  int _currentStep = 1;

  ServiceModel _preselectedService;
  List<ServiceModel> services = [];
  List<StaffModel> staff = [];
  BookingSessionModel session;
  LocationModel locationModel;

  List<BookingWizardPageModel> wizardPages = <BookingWizardPageModel>[];

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
  }

  checkPrevious() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map map = jsonDecode(prefs.getString('previous'))as Map;

    if(map!=null){
      print('previous is '+map['total'].toString());
    }
  }
  @override
  void initState() {
    super.initState();


    _locationId = widget.params['locationId'] as int ?? 0;
    locationModel = widget.params['location'] as LocationModel;
    services = widget.params['services'] as List<ServiceModel> ?? [];
    staff = widget.params['staff'] as List<StaffModel> ?? [];
    _preselectedService = widget.params['preselectedService'] as ServiceModel;


    BlocProvider.of<BookingBloc>(context).add(LocationLoadedBookingEvent(locationId: _locationId));

    wizardPages.add(BookingWizardPageModel.fromJson(<String, dynamic>{
      'step': 1,
      'body': BookingStep1(preselectedService: _preselectedService),
    }));
    wizardPages.add(BookingWizardPageModel.fromJson(<String, dynamic>{
      'step': 2,
      'body': BookingStep2(staff),
    }));
    wizardPages.add(BookingWizardPageModel.fromJson(<String, dynamic>{
      'step': 3,
      'body': BookingStep3(locationModel.id),
    }));
    wizardPages.add(BookingWizardPageModel.fromJson(<String, dynamic>{
      'step': 4,
      'body': BookingStep4(),
    }));
  }

  void _nextStep() {
    if (_currentStep == 1) {
    //  startSDK();
     // return;

      if (session.selectedServiceIds == null || session.selectedServiceIds.isEmpty) {
        UI.showErrorDialog(
          context,
          message: L10n.of(context).bookingWarningServices,
        );

        return;
      }
    } else if (_currentStep == 3) {
      if (session.selectedTimestamp == 0) {
        UI.showErrorDialog(
          context,
          message: L10n.of(context).bookingWarningAppointment,
        );

        return;
      }
      checkPrevious();
    } else if (_currentStep == 4) {



      UI.confirmationDialogBox(context,message: '',title:L10n.of(context).bookingBtnConfirm , onConfirmation: (){
        BlocProvider.of<BookingBloc>(context).add(SubmittedBookingEvent(context: context));

      },
      onCancel: ()async{
        final DateTime now = DateTime.fromMillisecondsSinceEpoch(session.selectedTimestamp);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String servicesTxt='';
        for (final ServiceGroupModel serviceGroupModel in session.location.serviceGroups) {
          for (final ServiceModel serviceModel in serviceGroupModel.services) {
            if (session.selectedServiceIds.contains(serviceModel.id)) {
                servicesTxt=servicesTxt+serviceModel.name+'\n';
            }
          }
        }


        var map = {
          'booked_shift_id':1.toString(),
          'shop_id':session.location.serviceGroups.first.services.first.shop_id.toString(),
          'seller_id':session.location.serviceGroups.first.services.first.seller_id.toString(),
          'services_ids':session.selectedServiceIds,
          if(session.selectedStaff.id!=0)'staff_id':session.selectedStaff.id.toString(),
          'date':'${now.year}-${now.month}-${now.day}',
          'time':'${now.hour}:${now.minute}',
          'payment_type':'cash_on_delivery',
          'pay_with_points':false,
          'services':servicesTxt,
          'duration':session.totalDuration,
          'total':session.totalPrice

        };

        if(!Provider.of<CartProvider>(context,listen: false).canAdd(session.location.serviceGroups.first.services.first.shop_id)){
          UI.confirmationDialogBox(context,title: 'info',message: txt,onConfirmation: (){
            Provider.of<CartProvider>(context,listen: false).deleteCart().then((value){
              Provider.of<CartProvider>(context,listen: false).addAppointments(map);
              Navigator.pop(context);
            });
          });
          return;
        }
        Provider.of<CartProvider>(context,listen: false).addAppointments(map);
        Navigator.pop(context);
        //prefs.setString("previous", jsonEncode(map));

      },
        okButtonText: L10n.of(context).bookingBtnConfirm,
        cancelButtonText: L10n.of(context).continueShopping
      );
     /* UI.showCustomDialog(context, message: '',actions: [
        InkWell(
          onTap: (){

            BlocProvider.of<BookingBloc>(context).add(SubmittedBookingEvent(context: context));

          },

            child: Text(L10n.of(context).bookingBtnConfirm)),
        InkWell(
            onTap: ()async{
              final DateTime now = DateTime.fromMillisecondsSinceEpoch(session.selectedTimestamp);

              SharedPreferences prefs = await SharedPreferences.getInstance();

              var map = {
                'booked_shift_id':1.toString(),
                'shop_id':session.location.serviceGroups.first.services.first.shop_id.toString(),
                'seller_id':session.location.serviceGroups.first.services.first.seller_id.toString(),
                'services_ids':session.selectedServiceIds,
                if(session.selectedStaff.id!=0)'staff_id':session.selectedStaff.id.toString(),
                'date':'${now.year}-${now.month}-${now.day}',
                'time':'${now.hour}:${now.minute}',
                'payment_type':'cash_on_delivery',
                'pay_with_points':false

              };

              prefs.setString("previous", jsonEncode(map));
              Navigator.pop(context);
            },
            child: Text(L10n.of(context).continueShopping)),
      ],title: L10n.of(context).bookingBtnConfirm,);*/
    }

    if (_currentStep < totalSteps) {
      _scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      _scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
      setState(() => _currentStep--);
    }
  }

  Future<void> configureSDK() async {
    // configure app
    configureApp();
    // sdk session configurations
    setupSDKSession();
  }

  // configure app key and bundle-id (You must get those keys from tap)
  Future<void> configureApp() async {
   /* GoSellSdkFlutter.configureApp(
        bundleId: Platform.isAndroid ? "com.badee.salon" : "com.creativitySol.salon",
        productionSecreteKey: Platform.isAndroid ? "pk_test_s9uF4wrkjvf82gJ1ipHnTVEL" : "pk_test_s9uF4wrkjvf82gJ1ipHnTVEL",
        sandBoxsecretKey: Platform.isAndroid ? "sk_test_u2EgVnvBw78NZSUCFHQIyX5z" : "sk_test_6HqM9b2hSKJRjsAlT7CEOgyr",
        lang: "ar");*/
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> setupSDKSession() async {
    try {
      await GoSellSdkFlutter.terminateSession();
      GoSellSdkFlutter.sessionConfigurations(
          trxMode: TransactionMode.PURCHASE,
          transactionCurrency: "sar",
          amount: session.totalPrice.toString(),
          customer: Customer(
              customerId: "", // customer id is important to retrieve cards saved for this customer
              email: "",
              isdNumber: getIt.get<AppGlobals>().user.phone,
              number: getIt.get<AppGlobals>().user.phone,
              firstName: "test",
              middleName: "test",
              lastName: "test",
              metaData: null),
          /*paymentItems: <PaymentItem>[
            PaymentItem(
                name: "item1",
                amountPerUnit: 1,
                quantity: Quantity(value: 1),
                discount: {"type": "F", "value": 10, "maximum_fee": 10, "minimum_fee": 1},
                description: "Item 1 Apple",
                taxes: [Tax(amount: Amount(type: "F", value: 10, minimumFee: 1, maximumFee: 10), name: "tax1", description: "tax describtion")],
                totalAmount: 100),
          ],
          // List of taxes
          taxes: [
            Tax(amount: Amount(type: "F", value: 10, minimumFee: 1, maximumFee: 10), name: "tax1", description: "tax describtion"),
            Tax(amount: Amount(type: "F", value: 10, minimumFee: 1, maximumFee: 10), name: "tax1", description: "tax describtion")
          ],
          // List of shippnig
          shippings: [
            Shipping(name: "shipping 1", amount: 100, description: "shiping description 1"),
            Shipping(name: "shipping 2", amount: 150, description: "shiping description 2")
          ],*/
          // Post URL
          postURL: "https://tap.company",
          // Payment description
          paymentDescription: "paymentDescription",
          // Payment Metadata
          paymentMetaData: {
            "a": "a meta",
            "b": "b meta",
          },
          // Payment Reference
          paymentReference: Reference(
              acquirer: "acquirer", gateway: "gateway", payment: "payment", track: "track", transaction: "trans_910101", order: "order_262625"),
          // payment Descriptor
          paymentStatementDescriptor: "paymentStatementDescriptor",
          // Save Card Switch
          isUserAllowedToSaveCard: false,
          // Enable/Disable 3DSecure
          isRequires3DSecure: true,
          // Receipt SMS/Email
          receipt: Receipt(true, false),
          // Authorize Action [Capture - Void]
          authorizeAction: AuthorizeAction(type: AuthorizeActionType.CAPTURE, timeInHours: 10),
          // Destinations
          destinations: null,
          // merchant id
          merchantID: "",
          // Allowed cards
          allowedCadTypes: CardType.ALL,
          applePayMerchantID: "",
          allowsToSaveSameCardMoreThanOnce: false,
          // pass the card holder name to the SDK
          cardHolderName: "",
          // disable changing the card holder name by the user
          allowsToEditCardHolderName: true,
          // select payments you need to show [Default is all, and you can choose between WEB-CARD-APPLEPAY ]
          paymentType: PaymentType.CARD,
          // Transaction mode
          sdkMode: SDKMode.Sandbox);
    } on PlatformException {
      // platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      tapSDKResult = {};
    });
  }

  Future<void> startSDK() async {

    await configureSDK();

    tapSDKResult = await GoSellSdkFlutter.startPaymentSDK as Map;

    print('>>>> ${tapSDKResult['sdk_result']}');

      switch (tapSDKResult['sdk_result'].toString()) {
        case "CANCELLED":

          break;
        case "SUCCESS":
          sdkStatus = "SUCCESS";

          handleSDKResult();

          BlocProvider.of<BookingBloc>(context).add(CardDoneEvent(transaction: tapSDKResult['charge_id'].toString()));

          break;
        case "FAILED":
          sdkStatus = "FAILED";
          handleSDKResult();
          break;
        case "SDK_ERROR":
          print('sdk error............');
          print(tapSDKResult['sdk_error_code']);
          print(tapSDKResult['sdk_error_message']);
          print(tapSDKResult['sdk_error_description']);
          print('sdk error............');
          sdkErrorCode = tapSDKResult['sdk_error_code'].toString();
          sdkErrorMessage = tapSDKResult['sdk_error_message'].toString();
          sdkErrorDescription = tapSDKResult['sdk_error_description'].toString();
          break;

        case "NOT_IMPLEMENTED":
          sdkStatus = "NOT_IMPLEMENTED";
          break;
      }

  }

  void handleSDKResult() {
    switch (tapSDKResult['trx_mode'].toString()) {
      case "CHARGE":
        printSDKResult('Charge');
        break;

      case "AUTHORIZE":
        printSDKResult('Authorize');
        break;

      case "SAVE_CARD":
        printSDKResult('Save Card');
        break;

      case "TOKENIZE":
        print('TOKENIZE token : ${tapSDKResult['token']}');
        print('TOKENIZE token_currency  : ${tapSDKResult['token_currency']}');
        print('TOKENIZE card_first_six : ${tapSDKResult['card_first_six']}');
        print('TOKENIZE card_last_four : ${tapSDKResult['card_last_four']}');
        print('TOKENIZE card_object  : ${tapSDKResult['card_object']}');
        print('TOKENIZE card_exp_month : ${tapSDKResult['card_exp_month']}');
        print('TOKENIZE card_exp_year    : ${tapSDKResult['card_exp_year']}');

        responseID = tapSDKResult['token'].toString();
        break;
    }
  }

  void printSDKResult(String trx_mode) {
    print('$trx_mode status                : ${tapSDKResult['status']}');
    print('$trx_mode id               : ${tapSDKResult['charge_id']}');
    print('$trx_mode  description        : ${tapSDKResult['description']}');
    print('$trx_mode  message           : ${tapSDKResult['message']}');
    print('$trx_mode  card_first_six : ${tapSDKResult['card_first_six']}');
    print('$trx_mode  card_last_four   : ${tapSDKResult['card_last_four']}');
    print('$trx_mode  card_object         : ${tapSDKResult['card_object']}');
    print('$trx_mode  card_brand          : ${tapSDKResult['card_brand']}');
    print('$trx_mode  card_exp_month  : ${tapSDKResult['card_exp_month']}');
    print('$trx_mode  card_exp_year: ${tapSDKResult['card_exp_year']}');
    print('$trx_mode  acquirer_id  : ${tapSDKResult['acquirer_id']}');
    print('$trx_mode  acquirer_response_code : ${tapSDKResult['acquirer_response_code']}');
    print('$trx_mode  acquirer_response_message: ${tapSDKResult['acquirer_response_message']}');
    print('$trx_mode  source_id: ${tapSDKResult['source_id']}');
    print('$trx_mode  source_channel     : ${tapSDKResult['source_channel']}');
    print('$trx_mode  source_object      : ${tapSDKResult['source_object']}');
    print('$trx_mode source_payment_type : ${tapSDKResult['source_payment_type']}');
    responseID = tapSDKResult['charge_id'].toString();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<BookingBloc, BookingState>(
      builder: (BuildContext context, BookingState state) {
        if (state is! SessionRefreshSuccessBookingState) {
          /// Show the full screen indicator until we return here.
          return FullScreenIndicator(
            color: Theme.of(context).cardColor,
            backgroundColor: Theme.of(context).cardColor,
          );
        }

        session = (state as SessionRefreshSuccessBookingState).session;
        session.location.serviceGroups=[];
        session.location.staff=[];
        session.location.staff = staff;
        session.location.name = locationModel.name;
        session.location.address = locationModel.address;
        session.location.mainPhoto = locationModel.mainPhoto;
        //session.selectedDateRange=-1;

        session.location.serviceGroups.add(ServiceGroupModel('Top Services', '', services));
        if (session.appointmentId == 1/*&&session.paymentMethod==PaymentMethod.inStore*/) {
          return BookingSuccessDialog(_locationId.toString());
        }
        else if(session.appointmentId == 2&&session.paymentMethod==PaymentMethod.cc){
          startSDK();
          session.appointmentId=0;
        }


        return BlocListener<BookingBloc, BookingState>(
          listener: (BuildContext context, BookingState listener) {
            if (listener is StaffSelectionSuccessBookingState) {
              _nextStep();
            } else if (listener is SessionRefreshSuccessBookingState) {
              if (listener.session.apiError.isNotEmpty) {
                UI.showErrorDialog(context, message: listener.session.apiError);
              }
            }
          },
          child: Scaffold(
            body: LoadingOverlay(
              isLoading: session.isSubmitting,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: <Widget>[
                        SliverAppBar(
                          automaticallyImplyLeading: false, //no back button
                          pinned: true,
                          leading: Visibility(
                            visible: _currentStep > 1,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              tooltip: L10n.of(context).commonTooltipInfo,
                              onPressed: _previousStep,
                            ),
                          ),
                          actions: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.close),
                              tooltip: L10n.of(context).commonTooltipInfo,
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                          expandedHeight: 150.0,
                          title: SliverAppTitle(
                            child: Text(
                              sprintf(
                                  '%d/%d: %s', <dynamic>[_currentStep, totalSteps, L10n.of(context).bookingTitleWizardPage('page' + _currentStep.toString())]),
                            ),
                          ),
                          centerTitle: true,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Container(
                              padding: const EdgeInsets.only(left: kPaddingM, bottom: kPaddingM, right: kPaddingM),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  StrutText(
                                    L10n.of(context).bookingLabelSteps(_currentStep, totalSteps),
                                    style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white70),
                                    maxLines: 1,
                                  ),
                                  StrutText(
                                    L10n.of(context).bookingTitleWizardPage('page' + _currentStep.toString()),
                                    style: Theme.of(context).textTheme.headline4.white.w600,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverFillRemaining(
                          hasScrollBody: true,
                          child: IndexedStack(
                            index: _currentStep - 1,
                            children: List<Widget>.generate(wizardPages.length, (int index) => wizardPages[index].body),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _bottomBar(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _bottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(
            width: 2,
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      padding: const EdgeInsets.all(kPaddingM),
      child: SafeArea(
        top: false,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    StrutText(
                      sprintf('%.2f', <double>[session.totalPrice]),
                      style: Theme.of(context).textTheme.headline5.bold.copyWith(color: Theme.of(context).textTheme.bodyText2.color),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: StrutText(
                        getIt.get<AppGlobals>().isRTL?'ر.س':'SAR',
                        style: Theme.of(context).textTheme.headline6.w400.copyWith(color: Theme.of(context).textTheme.caption.color),
                      ),
                    ),
                  ]),
                  Row(
                    children: <Widget>[
                      StrutText(
                        session.totalDuration.toString(),
                        style: Theme.of(context).textTheme.headline5.w500,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: StrutText(
                          L10n.of(context).bookingMinutes,
                          style: Theme.of(context).textTheme.headline6.w400.copyWith(color: Theme.of(context).textTheme.caption.color),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ThemeButton(
              text: _currentStep == totalSteps ? L10n.of(context).bookingBtnConfirm : L10n.of(context).bookingBtnNext,
              onPressed: _nextStep,
              disableTouchWhenLoading: true,
              showLoading: session.isSubmitting,
            ),
          ],
        ),
      ),
    );
  }
}
