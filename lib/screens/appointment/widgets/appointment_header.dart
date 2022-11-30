import 'package:flutter/material.dart';
import 'package:extension/configs/app_globals.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/configs/routes.dart';
import 'package:extension/data/models/appointment_model.dart';
import 'package:extension/generated/l10n.dart';
import 'package:extension/model/appointments_data.dart';
import 'package:extension/widgets/appointment_status_badge.dart';
import 'package:extension/utils/datetime.dart';
import 'package:extension/utils/text_style.dart';
import 'package:extension/widgets/strut_text.dart';

import '../../../main.dart';

class AppointmentHeader extends StatefulWidget {
  const AppointmentHeader(this.appointment);

  @override
  _AppointmentHeaderState createState() => _AppointmentHeaderState();

  final Data appointment;
}

class _AppointmentHeaderState extends State<AppointmentHeader> {
  @override
  Widget build(BuildContext context) {
    if (widget.appointment == null) {
      return Container();
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: kPaddingM,
          left: kPaddingM,
          right: kPaddingM,
          top: kToolbarHeight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: StrutText(
        widget.appointment.bookingDateTime!=null?DateTime.parse(widget.appointment.bookingDateTime.replaceAll('  ',' ')).toLocalDateString:'',

                    style: Theme.of(context).textTheme.headline4.white.bold,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: kPaddingS),
              child: Row(
                children: <Widget>[
                  AppointmentStatusBadge(
                    status: getIt.get<AppGlobals>().getStatus(widget.appointment.deliveryStatus),
                    inverse: kPrimaryColor == Theme.of(context).appBarTheme.color,
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(top: kPaddingM),
                child: StrutText(
                  widget.appointment.shop?.data?.first?.name??'',
                  style: Theme.of(context).textTheme.headline6.white,
                  maxLines: 1,
                ),
              ),
            ),
            InkWell(
              onTap: (){},
              child: Padding(
                padding: const EdgeInsets.only(top: kPaddingS),
                child: StrutText(
                  widget.appointment.shop?.data?.first?.address??'',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white70),
                  maxLines: 1,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: kPaddingS),
              child: StrutText(
                widget.appointment.code,
                style: Theme.of(context).textTheme.subtitle1.white,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
