import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:extension/configs/app_globals.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/configs/routes.dart';
import 'package:extension/data/models/location_model.dart';
import 'package:extension/generated/l10n.dart';
import 'package:extension/model/my_reviews.dart';
import 'package:extension/utils/text_style.dart';
import 'package:extension/widgets/strut_text.dart';
import 'package:shimmer/shimmer.dart';

import '../../../main.dart';

class LocationHeader extends StatelessWidget {
  LocationHeader({Key key, this.location}) : super(key: key);

  final LocationModel location;

  void _openPhotoGallery(BuildContext context) {
    Navigator.pushNamed(
      context,
      Routes.locationGallery,
      arguments: <String, dynamic>{
        'photos': location.photos,
        'name': location.name,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _dialog = RatingDialog(
      // your app's name?
      title: Text('Rate Salon'),
      // encourage your user to leave a high rating?
      message:
      Text('Tap a star to set your rating. Add more description here if you want.'),
      // your app's logo?
      image:Image.asset('assets/images/onboarding/welcome.png',width: 100,height: 100,),
      submitButtonText: 'Submit',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) {
        MyReviews().submitReview(location.id.toString(), response.comment, double.parse(response.rating.toString()));

      },
    );
    if (location == null) {
      return Shimmer.fromColors(
        baseColor: Theme.of(context).hoverColor,
        highlightColor: Theme.of(context).highlightColor,
        enabled: true,
        child: Container(color: kWhite),
      );
    }

    var image = location.mainPhoto=='assets/images/onboarding/welcome.png'?AssetImage(location.mainPhoto):NetworkImage(location.mainPhoto);

    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: <Widget>[
        InkWell(
          onTap: (){},// => _openPhotoGallery(context),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: image as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        if (location.ratings > 0)
          InkWell(
            onTap: () {
              if(getIt.get<AppGlobals>().isUser)
              showDialog(
                context: context,
                builder: (context) => _dialog,
              );
            },//Navigator.pushNamed(context, Routes.locationReviews, arguments: location),
            child: Padding(
              padding: const EdgeInsetsDirectional.only(bottom: kPaddingM, start: kPaddingM),
              child: Container(
                width: 128,
                height: 66,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.all(Radius.circular(kFormFieldsRadius)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    StrutText(
                      location.rate.toString(),
                      style: Theme.of(context).textTheme.headline6.w800.white,
                    ),
                    const Padding(padding: EdgeInsets.only(top: 4)),
                   /* StrutText(
                      L10n.of(context).locationTotalReviews(location.ratings.toString()),
                      style: Theme.of(context).textTheme.bodyText2.white,
                    )*/
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
