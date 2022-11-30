import 'package:flutter/material.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/data/models/appointment_model.dart';
import 'package:extension/generated/l10n.dart';
import 'package:extension/widgets/badge.dart';

/// [Badge] to represent appointment statuses.
class AppointmentStatusBadge extends StatelessWidget {
  const AppointmentStatusBadge({
    Key key,
    this.status,
    this.inverse = false,
  }) : super(key: key);

  final String status;
  final bool inverse;

  @override
  Widget build(BuildContext context) {
    Color _color;
    Color _backgroundColor;


        _color = inverse ? kPrimaryColor : kWhite;
        _backgroundColor = inverse ? kWhite : kPrimaryColor;

    return Badge(
      text: status,
      color: _color,
      backgroundColor: _backgroundColor,
    );
  }
}
