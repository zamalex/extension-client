import 'package:flutter/material.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/utils/text_style.dart';
import 'package:extension/widgets/strut_text.dart';

class UppercaseTitle extends StatelessWidget {
  const UppercaseTitle({
    Key key,
    this.title,
    this.padding,
  }) : super(key: key);

  final String title;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(top: kPaddingL),
      child: StrutText(
        (title ?? '').toUpperCase(),
        style: Theme.of(context).textTheme.bodyText2.w800.black,
      ),
    );
  }
}
