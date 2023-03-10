import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:extension/configs/app_globals.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/configs/routes.dart';
import 'package:extension/data/models/appointment_model.dart';
import 'package:extension/generated/l10n.dart';
import 'package:extension/model/appointments_data.dart';
import 'package:extension/widgets/appointment_status_badge.dart';
import 'package:extension/utils/string.dart';
import 'package:extension/utils/datetime.dart';
import 'package:extension/utils/text_style.dart';
import 'package:extension/widgets/card_divider.dart';

import 'package:extension/widgets/strut_text.dart';
import 'package:sprintf/sprintf.dart';

import '../../main.dart';

class OrdersListItem extends StatelessWidget {
  const OrdersListItem({
    Key key,
    this.appointment,
    this.routeName = '',
    this.leftMargin = kPaddingM,
    this.rightMargin = kPaddingM,
  }) : super(key: key);

  final Data appointment;
  final String routeName;
  final double leftMargin;
  final double rightMargin;

  void openRatingScreen(BuildContext context) {
    Navigator.pushNamed(context, Routes.appointmentRating, arguments: appointment);
  }

  @override
  Widget build(BuildContext context) {
    Color _dateTimeColor;

    _dateTimeColor = null;

    return InkWell(
      onTap: () {
        if (routeName.isNotNullOrEmpty) {
          Navigator.pushNamed(context, routeName, arguments: appointment);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBoxDecorationRadius),
        ),
        margin: EdgeInsetsDirectional.only(
          start: leftMargin,
          end: rightMargin,
          bottom: kPaddingS,
          top: kPaddingS,
        ),
        elevation: 1,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(kPaddingM),
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
                  StrutText(
              appointment.bookingDateTime!=null?DateTime.parse(appointment.bookingDateTime.replaceAll('  ',' ')).toLocalDateString:'',

                    style: Theme.of(context).textTheme.headline5.bold.copyWith(color: _dateTimeColor),
                  ),
                  StrutText(
                      appointment.bookingDateTime!=null?DateFormat('hh:mm a').format(DateTime.parse(appointment.bookingDateTime.replaceAll('  ',' '))).toString()
                    :'',

                    style: Theme.of(context).textTheme.headline5.bold.copyWith(color: _dateTimeColor),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: kPaddingM, right: kPaddingM, bottom: kPaddingM),
              color: Theme.of(context).cardColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      StrutText(
                        appointment.shop.data.isEmpty?'':appointment.shop.data.first.name??'',
                        style: Theme.of(context).textTheme.subtitle1.w500.fs18,
                      ),
                      const Padding(padding: EdgeInsets.only(top: kPaddingS / 2)),
                      StrutText(
                        appointment.shop.data.isEmpty?'':appointment.shop.data.first.address??'',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Theme.of(context).hintColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsetsDirectional.only(start: kPaddingS),
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          StrutText(
                            '',//appointment.grandTotal,
                            style: Theme.of(context).textTheme.subtitle1.fs18,
                          ),
                          const Padding(padding: EdgeInsets.only(top: kPaddingS / 2)),
                          StrutText(
                            '',
                            style: Theme.of(context).textTheme.bodyText2.w400.copyWith(color: Theme.of(context).hintColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
           Column(children: List.generate(appointment.items.data.length, (index){
             return  Container(
               padding: const EdgeInsets.symmetric(horizontal: kPaddingM,vertical: 8),
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
                    'x${appointment.items.data[index].quantity} ${appointment.items.data[index].productName}',
                    style: Theme.of(context).textTheme.subtitle1.w500.fs18,
                    overflow: TextOverflow.ellipsis,
                  ),),
                   StrutText(
                     '${appointment.items.data[index].price} ${kCurrency}',
                     style: Theme.of(context).textTheme.subtitle1.w500.fs18,
                   ),
                 ],
               ),
             );
           }),),
            Container(
              //padding: const EdgeInsets.all(2),
              margin: EdgeInsetsDirectional.only(start: leftMargin, end: rightMargin),
              color: Theme.of(context).cardColor,
              child: const CardDivider(),
            ),
            Container(
              padding: const EdgeInsets.all(kPaddingM),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(kBoxDecorationRadius),
                  bottomEnd: Radius.circular(kBoxDecorationRadius),
                ),
              ),
              child: _reservationStatus(context,appointment),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reservationStatus(BuildContext context, Data appointment) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        StrutText(
         'Total ${appointment.grandTotal} SAR',
          style: Theme.of(context).textTheme.bodyText2.w500.primaryColor,
        ),
        AppointmentStatusBadge(status: getIt.get<AppGlobals>().getStatus(appointment.deliveryStatus),),
      ],
    );


  }
}
