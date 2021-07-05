import 'package:flutter/material.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/data/models/appointment_model.dart';
import 'package:salon/generated/l10n.dart';
import 'package:salon/widgets/badge.dart';

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
