import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:salon/blocs/auth/auth_bloc.dart';
import 'package:salon/blocs/booking/booking_bloc.dart';
import 'package:salon/configs/app_globals.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/configs/routes.dart';
import 'package:salon/data/models/booking_session_model.dart';
import 'package:salon/data/models/service_group_model.dart';
import 'package:salon/data/models/service_model.dart';
import 'package:salon/generated/l10n.dart';
import 'package:salon/main.dart';
import 'package:salon/model/cart_provider.dart';
import 'package:salon/widgets/arrow_right_icon.dart';
import 'package:salon/widgets/list_item.dart';
import 'package:salon/widgets/list_title.dart';
import 'package:salon/widgets/sign_in.dart';
import 'package:salon/widgets/strut_text.dart';
import 'package:sprintf/sprintf.dart';
import 'package:salon/utils/datetime.dart';
import 'package:salon/utils/text_style.dart';

class BookingStep4 extends StatefulWidget {
  int payment_status;
  BookingStep4(this.payment_status);

  @override
  _BookingStep4State createState() => _BookingStep4State();
}

class _BookingStep4State extends State<BookingStep4> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('status ${widget.payment_status}');
    Future.delayed(Duration.zero).then((value){
      Provider.of<CartProvider>(context,listen: false).setPayWithBalance(false);

      Provider.of<CartProvider>(context,listen: false).checkBalance();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (BuildContext context, AuthState state) {
        return getIt.get<AppGlobals>().user == null
            ? SignInWidget(title: L10n.of(context).bookingSubtitleSignin)
            : BlocBuilder<BookingBloc, BookingState>(
                buildWhen: (BookingState previous, BookingState current) {
                  // return true/false to determine whether or not
                  // to rebuild the widget with state
                  return current is SessionRefreshSuccessBookingState && current.session.totalPrice > 0;
                },
                builder: (BuildContext context, BookingState state) {
                  final BookingSessionModel session = (state as SessionRefreshSuccessBookingState).session;

                  if (session.totalPrice == 0 || session.totalDuration == 0) {
                    return Container();
                  }

                  final List<ServiceModel> _selectedServices = <ServiceModel>[];

                  for (final ServiceGroupModel serviceGroupModel in session.location.serviceGroups) {
                    for (final ServiceModel serviceModel in serviceGroupModel.services) {
                      if (session.selectedServiceIds.contains(serviceModel.id)) {
                        _selectedServices.add(serviceModel);
                       // print('id is ${serviceModel.id}');
                      }
                    }
                  }

                  final DateTime startTime = DateTime.fromMillisecondsSinceEpoch(session.selectedTimestamp);
                  final DateTime endTime = startTime.add(Duration(minutes: session.totalDuration));

                  return ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: kPaddingM),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //ListTitle(title: L10n.of(context).bookingSubtitleLocation),
                            ListItem(
                              title: session.location.name,
                              titleTextStyle: Theme.of(context).textTheme.headline6,
                              subtitle: sprintf('%s\n%s', <String>[session.location.address, session.location.city]),
                              leading: Padding(
                                padding: const EdgeInsetsDirectional.only(bottom: kPaddingM, top: kPaddingM, end: kPaddingS),
                                child: InkWell(
                                  onTap: () => Navigator.pushNamed(context, Routes.location, arguments: session.location.id),
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: const BorderRadius.all(Radius.circular(kFormFieldsRadius)),
                                      image: DecorationImage(
                                        image: session.location.mainPhoto=='assets/images/onboarding/welcome.png'?AssetImage('assets/images/onboarding/welcome.png')as ImageProvider:NetworkImage(session.location.mainPhoto),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              showBorder: false,
                            ),
                            ListTitle(title: L10n.of(context).bookingSubtitleAppointment),
                            ListItem(
                              title: startTime.toLocalDateTimeString,
                              titleTextStyle: Theme.of(context).textTheme.subtitle1.fs18.w600,
                              subtitle: sprintf('%s\n%s', <String>[
                                L10n.of(context).bookingTotalTime(
                                    startTime.toLocalTimeString, endTime.toLocalTimeString, L10n.of(context).commonDurationFormat(session.totalDuration)),
                                if (session.selectedStaff != null && session.selectedStaff.id > 0)
                                  L10n.of(context).bookingWithStaff(session.selectedStaff.name.toUpperCase())
                                else
                                  '',
                              ]),
                              showBorder: false,
                            ),
                            //ListTitle(title: L10n.of(context).bookingSubtitleServices),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List<ListItem>.generate(_selectedServices.length, (int index) {
                                return ListItem(
                                  title: _selectedServices[index].name,
                                  titleTextStyle: Theme.of(context).textTheme.subtitle1.w600,
                                  subtitle: (_selectedServices[index].description.isNotEmpty) ? _selectedServices[index].description : '',
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      StrutText(
                                        L10n.of(context).commonCurrencyFormat(sprintf('%.2f', <double>[_selectedServices[index].price])),
                                        style: Theme.of(context).textTheme.subtitle1.fs18.w500,
                                      ),
                                      StrutText(
                                        L10n.of(context).commonDurationFormat(_selectedServices[index].duration.toString()),
                                        style: Theme.of(context).textTheme.bodyText1.w300.copyWith(color: Theme.of(context).hintColor),
                                      ),
                                    ],
                                  ),
                                  showBorder: false,
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Theme.of(context).cardColor,
                        padding: const EdgeInsets.all(kPaddingM),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListItem(
                              title: L10n.of(context).bookingAddNotes,
                              subtitle: session.notes,
                              showBorder: false,
                              trailing: const ArrowRightIcon(),
                              onPressed: () => showNotesEditor(session.notes),
                            ),

                            if( Provider.of<CartProvider>(context).balance>0)
                              Row(
                                children: [
                                  CupertinoSwitch(
                                    value: Provider.of<CartProvider>(context).payWithBalance,
                                    onChanged: (value) {
                                      if(value)
                                        selectPaymentmethodEvent(PaymentMethod.inStore);
                                      else{
                                        selectPaymentmethodEvent(PaymentMethod.inStore);
                                      }
                                      Provider.of<CartProvider>(context,listen: false).setPayWithBalance(value);
                                    },
                                  ),

                                  Column(children: [
                                    Text(getIt.get<AppGlobals>().isRTL?'الرصيد':'Balance'),
                                    Text(Provider.of<CartProvider>(context).balance.toString())
                                  ],)
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              )
                            else
                              AbsorbPointer(
                                absorbing: true,
                                child: Row(
                                  children: [
                                    CupertinoSwitch(
                                      value: Provider.of<CartProvider>(context).payWithBalance,
                                      onChanged: (value) {

                                        Provider.of<CartProvider>(context,listen: false).setPayWithBalance(value);
                                      },
                                    ),

                                    Column(children: [
                                      Text(getIt.get<AppGlobals>().isRTL?'الرصيد':'Balance'),
                                      Text(Provider.of<CartProvider>(context).balance.toString())
                                    ],)
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                ),
                              ),
                            ListTitle(title: L10n.of(context).bookingSubtitleCheckout),

                            ListItem(
                              title: L10n.of(context).bookingPayInStore,
                              showBorder: false,
                              leading: Radio<PaymentMethod>(
                                value: PaymentMethod.inStore,
                                groupValue: session.paymentMethod,
                                onChanged: (PaymentMethod selected) => selectPaymentmethodEvent(selected),
                              ),
                              onPressed: () => selectPaymentmethodEvent(PaymentMethod.inStore),
                            ),
                            /*if (Provider.of<CartProvider>(context).balance==-2)*/
                            if(widget.payment_status==1)
                            ListItem(
                                title: L10n.of(context).bookingPayWithCard,
                                showBorder: false,
                                leading: Radio<PaymentMethod>(
                                  value: PaymentMethod.cc,
                                  groupValue: session.paymentMethod,
                                  onChanged: (PaymentMethod selected) => selectPaymentmethodEvent(selected),
                                ),
                                onPressed: () => selectPaymentmethodEvent(PaymentMethod.cc),
                              )

                           /* ListTitle(title: L10n.of(context).bookingSubtitleCancelationPolicy),
                            Padding(
                              padding: const EdgeInsets.only(bottom: kPaddingM),
                              child: Text(session.location.cancelationPolicy),
                            ),*/
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
      },
    );
  }

  void selectPaymentmethodEvent(PaymentMethod paymentMethod) {
    context.read<BookingBloc>().add(PaymentMethodSelectedBookingEvent(paymentMethod));
  }

  Future<void> showNotesEditor(String notes) async {
    final String editedNotes = await Navigator.pushNamed(context, Routes.bookingNotes, arguments: notes);
    if (editedNotes != null) {
      //BlocProvider.of<BookingBloc>(context).add(NotesUpdatedBookingEvent(editedNotes,0));
      BlocProvider.of<BookingBloc>(context).notes=editedNotes;
    }
  }



}
