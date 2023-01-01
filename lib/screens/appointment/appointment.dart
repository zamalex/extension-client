import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:extension/blocs/appointment/appointment_bloc.dart';
import 'package:extension/configs/app_globals.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/configs/routes.dart';
import 'package:extension/data/models/appointment_model.dart';
import 'package:extension/data/models/service_model.dart';
import 'package:extension/generated/l10n.dart';
import 'package:extension/main.dart';
import 'package:extension/model/appointments_data.dart';
import 'package:extension/model/my_reviews.dart';
import 'package:extension/screens/appointment/widgets/appointment_header.dart';
import 'package:extension/screens/appointment/widgets/appointment_tabbar.dart';
import 'package:extension/screens/appointments/appointments.dart';
import 'package:extension/screens/booking/widgets/booking_notes.dart';
import 'package:extension/screens/orders/orders.dart';
import 'package:extension/utils/ui.dart';
import 'package:extension/utils/text_style.dart';
import 'package:extension/widgets/card_divider.dart';
import 'package:extension/widgets/link_button.dart';
import 'package:extension/widgets/list_item.dart';
import 'package:extension/widgets/list_title.dart';
import 'package:extension/widgets/loading_overlay.dart';
import 'package:extension/widgets/portrait_mode_mixin.dart';
import 'package:extension/widgets/sliver_app_title.dart';
import 'package:extension/widgets/strut_text.dart';
import 'package:sprintf/sprintf.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({
    Key key,
    this.appointment,
  }) : super(key: key);

  final Data appointment;

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> with PortraitStatefulModeMixin<AppointmentScreen> {
  Data _appointment;
  AppointmentBloc _bloc;

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _appointment = widget.appointment;
    _bloc = BlocProvider.of<AppointmentBloc>(context);

    final _dialog = RatingDialog(
      // your app's name?
      title: Text('Rate ${widget.appointment.booking_staff_name??''}'),
      // encourage your user to leave a high rating?
      message:
      Text('Tap a star to set your rating. Add more description here if you want.'),
      // your app's logo?
      image:Image.asset('assets/images/onboarding/welcome.jpg',width: 100,height: 100,),
      submitButtonText: 'Submit',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) {
        MyReviews().submitWorkerReview(widget.appointment.booking_staff_id.toString()??'0', response.comment, double.parse(response.rating.toString()));

      },
    );



    Future.delayed(Duration.zero).then((value) {

      if(/*widget.appointment.deliveryStatus=='delivered'&&*/widget.appointment.booking_staff_id!=null&&widget.appointment.booking_staff_id!=0)

        /// check if staff is rated
        MyReviews().checkReview(widget.appointment.booking_staff_id).then((value){

          if(value){
            showDialog(
              context: context,
              builder: (context) => _dialog,
            );
          }
        });

    });
  }


/// cancel order
  void cancelReservation() {
    if(!widget.appointment.canCancel){
      UI.showErrorDialog(context,title: '',message: getIt.get<AppGlobals>().isRTL?'لا يمكن الغاء الطلب':'you can\'t cancel this appointment');
      return;
    }

    UI.confirmationDialogBox(
      context,
      message: L10n.of(context).appointmentCancelationConfirmation,
      onConfirmation: () {
        setState(() => _isLoading = true);
        _bloc.add(CanceledAppointmentEvent(id: widget.appointment.id));

        }
      ,
    );
  }

  setNotes(String n){

      _appointment.notes=n;

  }

  /// open editor to add notes
  Future<void> showNotesEditor() async {
    /*final String editedNotes = await Navigator.pushNamed(context, Routes.bookingNotes, arguments: '');
    if (editedNotes != null) {
      _bloc.add(NotesUpdatedAppointmentEvent(editedNotes));
    }*/
    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>BookingNotes(appointment: _appointment.id,setNotes: setNotes,notes: _appointment.notes,),));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocConsumer<AppointmentBloc, AppointmentState>(
      listener: (BuildContext context, AppointmentState apiListener) {
        if (apiListener is UpdateNotesInProgressAppointmentState) {
          // _appointment = _appointment.rebuild(notes: apiListener.notes);
        }
        if (apiListener is CancelSuccessAppointmentState) {
          //  _appointment = _appointment.rebuild(status: AppointmentStatus.canceled);
          setState(() => _isLoading = false);
          _appointment.canCancel=false;
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => _appointment.orderType=='booking'?AppointmentsScreen():OrdersScreen()),
                  (Route<dynamic> route) => route.isFirst
          );
        }
      },
      builder: (context, state) => Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                pinned: true,
                expandedHeight: 302,
                backgroundColor:
                getIt.get<AppGlobals>().isPlatformBrightnessDark ? Theme.of(context).accentColor : Theme.of(context).accentColor,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: AppointmentHeader(_appointment),
                ),
                title: _appointment != null ? SliverAppTitle(child: Text(_appointment.code)) : Container(),
              ),
            ];
          },
          body: LoadingOverlay(
            isLoading: _isLoading,
            child: ListView(
              padding: const EdgeInsets.all(kPaddingM),
              children: <Widget>[
                AppointmentTabBar(
                  _appointment,
                  onCancelTap: cancelReservation,
                  onNotesTap: showNotesEditor,
                ),
                _serviceList(),
                SizedBox(height: 10,),
                const CardDivider(),
                SizedBox(height: 10,),
                Column(children: List.generate(_appointment.items.data.length, (index){
                  return  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadiusDirectional.only(
                        topStart: Radius.circular(kBoxDecorationRadius),
                        topEnd: Radius.circular(kBoxDecorationRadius),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(child:  StrutText(
                          _appointment.items.data[index].productName,
                          style: Theme.of(context).textTheme.subtitle1.w500.fs18,
                          overflow: TextOverflow.ellipsis,
                        ),),
                        StrutText(
                          '${_appointment.items.data[index].price} ${kCurrency}',
                          style: Theme.of(context).textTheme.subtitle1.w500.fs18,
                        ),
                      ],
                    ),
                  );
                }),),
              CardDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: kPaddingM),
                    child: StrutText(
                      getIt.get<AppGlobals>().isRTL?'خصم الكوبون':'Coupon Discount',
                      style: Theme.of(context).textTheme.headline6,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: kPaddingM),
                    child: StrutText(
                      _appointment.coupon_discount,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: kPaddingM),
                    child: StrutText(
                      getIt.get<AppGlobals>().isRTL?'خصم الرصيد':'Balance Discount',
                      style: Theme.of(context).textTheme.headline6,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: kPaddingM),
                    child: StrutText(
                      _appointment.balance,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ],
              ),
                _totalPrice(),
               // const CardDivider(),
                if(widget.appointment.orderType!='purchase') _footer(),
              ],
            ),
          ),
        ),
      ),

    );
  }

  Widget _serviceList() {
   // if (_appointment == null || _appointment.services.isEmpty) {
      return Container();
   // }

    /*return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: kPaddingM),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        final ServiceModel item = _appointment.services[index];

        return ListItem(
          title: item.name,
          titleTextStyle: Theme.of(context).textTheme.subtitle1.w600,
          subtitle: (item.description.isNotEmpty) ? item.description : '',
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              StrutText(
                L10n.of(context).commonCurrencyFormat(sprintf('%.2f', <double>[item.price])),
                style: Theme.of(context).textTheme.subtitle1.fs18.w500,
              ),
              StrutText(
                L10n.of(context).commonDurationFormat(item.duration.toString()),
                style: Theme.of(context).textTheme.bodyText1.w300.copyWith(color: Theme.of(context).hintColor),
              ),
            ],
          ),
          showBorder: false,
        );
      },
      itemCount: _appointment.services.length,
    );*/
  }

  Widget _totalPrice() {
    if (_appointment == null) {
      return Container();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(vertical: kPaddingM),
          child: StrutText(
            L10n.of(context).appointmentSubtitleTotal,
            style: Theme.of(context).textTheme.headline6,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: kPaddingM),
          child: StrutText(
            _appointment.grandTotal,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ],
    );
  }

  Widget _footer() {
    if (_appointment == null) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
       /* if (_appointment.status == AppointmentStatus.active)*/ //ListTitle(title: L10n.of(context).appointmentSubtitleNotes),
       /* if (_appointment.notes.isNotEmpty) Text(_appointment.notes),*/
        /*if (_appointment.notes.isEmpty && _appointment.status == AppointmentStatus.active)*/
         /* LinkButton(
            label: L10n.of(context).bookingAddNotes,
            onPressed: showNotesEditor,
          ),*/
        /*if (_appointment.status == AppointmentStatus.active)*/ //ListTitle(title: L10n.of(context).bookingSubtitleCancelationPolicy),
        /*if (_appointment.status == AppointmentStatus.active)*/
         /* Padding(
            padding: const EdgeInsets.only(bottom: kPaddingM),
            child: Text(getIt.get<AppGlobals>().isRTL?'يمكنك الإلغاء مجانًا في أي وقت مقدمًا ، وإلا فسيتم تحصيل 10٪ من سعر الخدمة مقابل عدم الحضور':'Cancel for free anytime in advance, otherwise you can be charged with 10% of the service price for not showing up.'),
          ),*/
      ],
    );
  }
}
