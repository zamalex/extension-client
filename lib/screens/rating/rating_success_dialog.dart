import 'package:flutter/material.dart';
import 'package:extension/generated/l10n.dart';
import 'package:extension/widgets/success_dialog.dart';

class RatingSuccessDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SuccessDialog(
      title: L10n.of(context).reviewSuccessTitle.toUpperCase(),
      subtitle: L10n.of(context).reviewSuccessSubtitle,
      startIcon: Icons.star_border,
      endIcon: Icons.star,
    );
  }
}
