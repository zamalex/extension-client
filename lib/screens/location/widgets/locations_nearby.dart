import 'package:flutter/material.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/data/models/location_model.dart';
import 'package:extension/generated/l10n.dart';
import 'package:extension/widgets/locations_carousel.dart';

class LocationsNearby extends StatelessWidget {
  const LocationsNearby({Key key, this.nearbyLocations}) : super(key: key);

  final List<LocationModel> nearbyLocations;

  @override
  Widget build(BuildContext context) {
    if (nearbyLocations == null || nearbyLocations.isEmpty) {
      return Container();
    }

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.only(bottom: kPaddingL),
      child: LocationsCarousel(
        locations: nearbyLocations,
        title: L10n.of(context).locationTitleNearby,
      ),
    );
  }
}
