import 'package:flutter/material.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/data/models/review_model.dart';
import 'package:salon/generated/l10n.dart';
import 'package:salon/utils/text_style.dart';
import 'package:salon/utils/string.dart';
import 'package:salon/utils/datetime.dart';
import 'package:salon/widgets/initials_circle_avatar.dart';
import 'package:salon/widgets/star_rating.dart';
import 'package:salon/widgets/strut_text.dart';

class ReviewListItem extends StatelessWidget {
  const ReviewListItem({
    Key key,
    @required this.review,
    this.showDetails = false,
  }) : super(key: key);

  final ReviewModel review;
  final bool showDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          //padding: const EdgeInsets.only(bottom: kPaddingS),
          child: Row(
            children: <Widget>[
              if (review.user.profilePhoto.isEmpty)
                InitialsCircleAvatar(initials: review.user.fullName.initials)
              else
                CircleAvatar(
                  backgroundImage: AssetImage(review.user.profilePhoto),
                  radius: kCircleAvatarSizeRadiusSmall,
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPaddingS),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    StrutText(
                      review.user.fullName,
                      style: Theme.of(context).textTheme.subtitle1.w600.black,
                    ),
                    StrutText(
                      review.reviewDate.toLocalDateString,
                      style: Theme.of(context).textTheme.bodyText1.w300.copyWith(color: kPrimaryColor),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  child: StarRating(
                    color: kPrimaryColor,
                    rating: review.rate.toDouble(),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (review.comment.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: kPaddingS),
            child: StrutText(
              review.comment,
              style: Theme.of(context).textTheme.subtitle1.h15.w300.primaryColor,
            ),
          ),
        if (showDetails && review.reply != null)
          Container(
            margin: const EdgeInsets.only(top: kPaddingS),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(kBoxDecorationRadius)),
            ),
            padding: const EdgeInsets.all(kPaddingS),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                StrutText(
                  L10n.of(context).locationRepliedOn(review.reply.replyDate.toLocalDateString),
                  style: Theme.of(context).textTheme.caption.w600,
                ),
                StrutText(
                  review.reply.comment,
                  style: Theme.of(context).textTheme.subtitle1.h15.w300,
                ),
              ],
            ),
          ),
        const Padding(padding: EdgeInsets.only(bottom: kPaddingL)),
      ],
    );
  }
}
