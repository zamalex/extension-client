import 'package:flutter/material.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/configs/routes.dart';
import 'package:salon/data/models/location_model.dart';
import 'package:salon/generated/l10n.dart';
import 'package:salon/utils/text_style.dart';
import 'package:salon/widgets/strut_text.dart';
import 'package:shimmer/shimmer.dart';

class LocationHeader extends StatelessWidget {
  const LocationHeader({Key key, this.location}) : super(key: key);

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
            onTap: () => Navigator.pushNamed(context, Routes.locationReviews, arguments: location),
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
                    StrutText(
                      L10n.of(context).locationTotalReviews(location.ratings.toString()),
                      style: Theme.of(context).textTheme.bodyText2.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
