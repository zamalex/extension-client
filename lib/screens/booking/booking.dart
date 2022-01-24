import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final int totalSteps = 4;

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
          UI.confirmationDialogBox(context,title: 'info',message: 'cant add from different salons',onConfirmation: (){
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
        if (session.appointmentId > 0) {
          return BookingSuccessDialog(_locationId.toString());
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
