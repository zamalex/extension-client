import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:salon/blocs/search/search_bloc.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/data/models/location_model.dart';
import 'package:salon/data/models/toolbar_option_model.dart';
import 'package:salon/generated/l10n.dart';
import 'package:salon/widgets/jumbotron.dart';
import 'package:salon/widgets/location_list_item.dart';
import 'package:salon/widgets/strut_text.dart';

class SearchResultList extends StatelessWidget {


  SearchResultList({
    Key key,
    this.searchBlock,
    this.locations,
    this.currentListType,
  }) : super(key: key);

  final List<LocationModel> locations;
  final ToolbarOptionModel currentListType;
  final SearchBloc searchBlock;
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    _scrollController
        .addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('scrolllled');
        searchBlock.add(FilteredListRequestedSearchEvent());
      }
    });
    if (locations == null) {
      return Container();
    }

    if (locations.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 3 * kPaddingM),
        child: Column(
          children: <Widget>[
            Jumbotron(
              title: L10n.of(context).searchTitleNoResults.toUpperCase(),
              icon: Icons.info_outline,
            ),
            StrutText(
              L10n.of(context).locationNoResults,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: Theme.of(context).disabledColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final LocationListItemViewType _viewType = LocationListItemViewType.values
        .firstWhere((LocationListItemViewType e) =>
    describeEnum(e) == currentListType.code);

    return Column(
      children: [
        Container(
            height: 400,
            padding: const EdgeInsetsDirectional.only(end: kPaddingM),
            child: ListView.builder(

              controller: _scrollController,
              itemBuilder: (c, i) {
                return Container(
                  margin: EdgeInsets.all(10),
                  child: LocationListItem(
                    location: locations[i],
                    viewType: _viewType,
                  ),
                );
              },
              itemCount: locations.length,
            )),
      ],
    );
  }
}
