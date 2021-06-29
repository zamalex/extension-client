import 'package:flutter/material.dart';
import 'package:salon/generated/l10n.dart';
import 'package:salon/widgets/success_dialog.dart';

class BookingSuccessDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SuccessDialog(
      title: L10n.of(context).bookingSuccessTitle.toUpperCase(),
      subtitle: L10n.of(context).bookingSuccessSubtitle,
      btnLabel: L10n.of(context).bookingBtnClose,
      startIcon: Icons.calendar_today,
      endIcon: Icons.event_available,
    );
  }
}
