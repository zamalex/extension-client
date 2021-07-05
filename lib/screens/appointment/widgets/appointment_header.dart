import 'package:flutter/material.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/configs/routes.dart';
import 'package:salon/data/models/appointment_model.dart';
import 'package:salon/generated/l10n.dart';
import 'package:salon/model/appointments_data.dart';
import 'package:salon/widgets/appointment_status_badge.dart';
import 'package:salon/utils/datetime.dart';
import 'package:salon/utils/text_style.dart';
import 'package:salon/widgets/strut_text.dart';
import 'package:sprintf/sprintf.dart';

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
                    widget.appointment.date,
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
                    status: widget.appointment.deliveryStatus,
                    inverse: kPrimaryColor == Theme.of(context).appBarTheme.color,
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () => Navigator.pushNamed(context, Routes.location, arguments: 'widget.appointment.location.id'),
              child: Padding(
                padding: const EdgeInsets.only(top: kPaddingM),
                child: StrutText(
                  'The Barbery',
                  style: Theme.of(context).textTheme.headline6.white,
                  maxLines: 1,
                ),
              ),
            ),
            InkWell(
              onTap: () => Navigator.pushNamed(context, Routes.location, arguments: 'widget.appointment.location.id'),
              child: Padding(
                padding: const EdgeInsets.only(top: kPaddingS),
                child: StrutText(
                  '1234 Utah',
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
