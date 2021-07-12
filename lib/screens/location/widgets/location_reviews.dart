import 'package:flutter/material.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/configs/routes.dart';
import 'package:salon/data/models/location_model.dart';
import 'package:salon/data/models/review_model.dart';
import 'package:salon/generated/l10n.dart';
import 'package:salon/widgets/link_text.dart';
import 'package:salon/widgets/review_list_item.dart';
import 'package:salon/widgets/star_rating.dart';
import 'package:salon/utils/text_style.dart';
import 'package:salon/widgets/strut_text.dart';
import 'package:salon/widgets/uppercase_title.dart';
import 'package:sprintf/sprintf.dart';
import 'package:salon/utils/list.dart';

class LocationReviews extends StatelessWidget {
  const LocationReviews({
    Key key,
    this.location,
    this.showLatest = 2,
  }) : super(key: key);

  final LocationModel location;
  final int showLatest;


  @override
  Widget build(BuildContext context) {
    if (location == null || location.reviews.isNullOrEmpty) {
      return Container();
    }

    List<ReviewModel> _reviews;

    if (showLatest >= location.reviews.length) {
      _reviews = location.reviews;
    } else {
      _reviews = location.reviews.sublist(0, showLatest);
    }

    return Container(
      padding: const EdgeInsets.only(left: kPaddingM, right: kPaddingM, bottom: kPaddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          UppercaseTitle(title: L10n.of(context).locationTitleReviews),
        SizedBox(height: 20,),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(0),
            children: _reviews.map((ReviewModel review) => ReviewListItem(review: review)).toList(),
          ),
          if (showLatest < location.reviews.length)
            Padding(
              padding: const EdgeInsets.only(top: kPaddingS),
              child: LinkText(
                text: L10n.of(context).locationLinkAllReviews,
                onTap: () => Navigator.pushNamed(context, Routes.locationReviews, arguments: location),
              ),
            )
        ],
      ),
    );
  }
}
