import 'package:flutter/material.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/configs/routes.dart';
import 'package:salon/data/models/review_model.dart';
import 'package:salon/model/my_reviews.dart';
import 'package:salon/widgets/list_item.dart';
import 'package:salon/widgets/star_rating.dart';
import 'package:salon/widgets/strut_text.dart';
import 'package:sprintf/sprintf.dart';
import 'package:salon/utils/text_style.dart';
import 'package:salon/utils/datetime.dart';

class RatingsListItem extends StatelessWidget {
  const RatingsListItem({
    Key key,
    this.review,
  }) : super(key: key);

  final SingleReview review;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBoxDecorationRadius),
      ),
      margin: const EdgeInsets.symmetric(horizontal: kPaddingM, vertical: kPaddingS),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(kPaddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: kPaddingS),
              child: StrutText(
                review.time,//reviewDate.toLocalDateString,
                style: Theme.of(context).textTheme.bodyText1.copyWith(color: Theme.of(context).hintColor),
              ),
            ),
            ListItem(
              title: review.moduleName,//location.name,
              titleTextStyle: Theme.of(context).textTheme.headline6,
              subtitle: '',//sprintf('%s\n%s', <String>[review.location.address, review.location.city]),
              leading: Padding(
                padding: const EdgeInsetsDirectional.only(end: kPaddingS),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(Radius.circular(kFormFieldsRadius)),
                    image: DecorationImage(
                      image: (review.avatar==null||review.avatar.isEmpty||review.avatar=='null')?AssetImage('assets/images/onboarding/welcome.png')as ImageProvider:NetworkImage(review.avatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              showBorder: false,
              onPressed: null //Navigator.pushNamed(context, Routes.location, arguments: review.location.id),
            ),
            Padding(
              padding: const EdgeInsets.only(top: kPaddingS),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsetsDirectional.only(end: kPaddingS),
                    child: StarRating(
                      rating: double.parse(review.rating.toString()),
                      size: 44,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: kPaddingM),
              child: StrutText(
                review.comment,
                style: Theme.of(context).textTheme.subtitle1.h15.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
