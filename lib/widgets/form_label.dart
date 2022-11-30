import 'package:flutter/material.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/utils/text_style.dart';
import 'package:extension/widgets/strut_text.dart';

/// Generic form label.
class FormLabel extends StatelessWidget {
  const FormLabel({
    Key key,
    @required this.text,
    this.padding,
  }) : super(key: key);

  /// label text.
  final String text;

  /// Optional label padding.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: kPaddingS, top: kPaddingM),
      child: StrutText(
        text,
        style:TextStyle(color: Colors.black,fontFamily:'Expo' ) //Theme.of(context).inputDecorationTheme.labelStyle.w600,
      ),
    );
  }
}
