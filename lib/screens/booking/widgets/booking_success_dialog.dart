import 'package:flutter/material.dart';
import 'package:extension/generated/l10n.dart';
import 'package:extension/widgets/success_dialog.dart';

class BookingSuccessDialog extends StatelessWidget {
  String id;
  BookingSuccessDialog(this.id);
  @override
  Widget build(BuildContext context) {
    return SuccessDialog(
      title: L10n.of(context).bookingSuccessTitle.toUpperCase(),
      subtitle: L10n.of(context).bookingSuccessSubtitle,
      btnLabel: L10n.of(context).bookingBtnClose,
      startIcon: Icons.calendar_today,
      endIcon: Icons.event_available,
      id:id ,
    );
  }
}
