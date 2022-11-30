import 'package:flutter/material.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/utils/text_style.dart';
import 'package:extension/widgets/strut_text.dart';

class LocationContactInfo extends StatelessWidget {
  const LocationContactInfo({
    Key key,
    @required this.icon,
    @required this.label,
    @required this.text,
    this.onTap,
    this.trailing,
  }) : super(key: key);

  final IconData icon;
  final String label;
  final String text;
  final VoidCallback onTap;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(top: kPaddingM),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: <Widget>[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Icon(
                icon,
                color: kPrimaryColor,
                size: 18,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: kPaddingS, right: kPaddingS),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    StrutText(
                      label,
                      style: Theme.of(context).textTheme.caption.primaryColor,
                    ),
                    StrutText(
                      text,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyText2.w500.black,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            trailing ?? Container(),
          ],
        ),
      ),
    );
  }
}
