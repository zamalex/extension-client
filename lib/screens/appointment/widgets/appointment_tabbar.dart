import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:salon/data/models/appointment_model.dart';
import 'package:salon/generated/l10n.dart';
import 'package:salon/model/appointments_data.dart';
import 'package:salon/utils/async.dart';
import 'package:salon/utils/ui.dart';
import 'package:salon/widgets/labeled_icon_button.dart';
import 'package:sprintf/sprintf.dart';

class AppointmentTabBar extends StatefulWidget {
  const AppointmentTabBar(
    this.appointment, {
    this.onCancelTap,
    this.onNotesTap,
  });

  @override
  _AppointmentTabBarState createState() => _AppointmentTabBarState();

  final Data appointment;
  final VoidCallback onCancelTap;
  final VoidCallback onNotesTap;
}

class _AppointmentTabBarState extends State<AppointmentTabBar> {
  @override
  Widget build(BuildContext context) {
    /*if (widget.appointment == null || widget.appointment.status != AppointmentStatus.active) {
      return Container();
    }*/

    final List<Widget> _widgets = <Widget>[];

    if (/*widget.appointment.location.phone.isNotEmpty*/true) {
      _widgets.add(LabeledIconButton(
        icon: Icons.call,
        text: L10n.of(context).bookingBtnCall,
        onTap: () {

          if(widget.appointment.shop.data.first.phone!=null&&widget.appointment.shop.data.first.phone.isNotEmpty)
          UI.confirmationDialogBox(
            context,
            message: L10n.of(context).bookingCallConfirmation(widget.appointment.shop.data.first.phone),
            onConfirmation: () => Async.launchUrl('tel://${widget.appointment.shop.data.first.phone}'),
          );
          else
            UI.showErrorDialog(context,message: 'no available phone number');
        },
        disableTouchWhenLoading: true,
      ));
    }

    _widgets.add(LabeledIconButton(
      icon: Icons.calendar_today,
      text: L10n.of(context).bookingBtnCalendar,
      onTap: () {
        Add2Calendar.addEvent2Cal(Event(
          title: widget.appointment.shop.data.first.name??'',
          description: 'Booking appointment',
          location: widget.appointment.shop.data.first.address??'',
          startDate: DateTime.parse(widget.appointment.bookingDateTime.replaceAll('  ', ' ')),
          endDate: DateTime.parse(widget.appointment.bookingDateTime.replaceAll('  ', ' ')),
        ));
      },
      disableTouchWhenLoading: true,
    ));

    _widgets.add(LabeledIconButton(
      icon: Icons.edit,
      text: L10n.of(context).bookingBtnNotes,
      onTap: widget.onNotesTap,
      disableTouchWhenLoading: true,
    ));

    if (widget.onCancelTap != null) {
      _widgets.add(LabeledIconButton(
        icon: Icons.cancel,
        text: L10n.of(context).bookingBtnCancel,
        onTap: widget.onCancelTap,
        disableTouchWhenLoading: true,
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _widgets,
    );
  }
}
