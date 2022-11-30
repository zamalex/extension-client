import 'package:flutter/material.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/utils/text_style.dart';
import 'package:extension/widgets/strut_text.dart';

/// Listing title.
///
/// Used alongside [ListItem].
class ListTitle extends StatelessWidget {
  const ListTitle({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kPaddingL, bottom: kPaddingS),
      child: Row(
        children: <Widget>[
          StrutText(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.subtitle2.w400.copyWith(color: Theme.of(context).hintColor),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
