import 'package:flutter/material.dart';
import 'package:extension/configs/app_globals.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/data/models/search_session_model.dart';
import 'package:extension/data/models/toolbar_option_model.dart';
import 'package:extension/generated/l10n.dart';
import 'package:extension/main.dart';
import 'package:extension/widgets/filter_button.dart';
import 'package:extension/widgets/modal_bottom_sheet_item.dart';

class SearchListToolbar extends StatefulWidget {
  const SearchListToolbar({
    Key key,
    // @required this.searchSortTypes,
    @required this.searchGenderTypes,
    @required this.currentSort,
    @required this.currentGenderFilter,
    @required this.onSortChange,
    @required this.onGenderFilterChange,
    this.session,
    this.onFilterTap,
  }) : super(key: key);

  // final List<ToolbarOptionModel> searchSortTypes;
  final List<ToolbarOptionModel> searchGenderTypes;
  final ToolbarOptionModel currentSort;
  final ToolbarOptionModel currentGenderFilter;
  final ToolbarOptionModelCallback onSortChange;
  final ToolbarOptionModelCallback onGenderFilterChange;
  final VoidCallback onFilterTap;
final SearchSessionModel session;
  @override
  _SearchListToolbarState createState() => _SearchListToolbarState();
}

class _SearchListToolbarState extends State<SearchListToolbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.only(start: kPaddingM, top: kPaddingS, bottom: kPaddingS),
      color:  Theme.of(context).appBarTheme.color.withAlpha(50),
      child: Row(
        children: <Widget>[
          FilterButton(
            label: widget.session.currentGenderFilter.label,
            modalTitle: L10n.of(context).searchTitleFilter,
            modalItems: widget.searchGenderTypes,
            selectedItem: ModalBottomSheetItem<ToolbarOptionModel>(
              text: widget.currentGenderFilter.label,
              value: widget.currentGenderFilter,
            ),
            onSelection: (ToolbarOptionModel filterModel) => widget.onGenderFilterChange(filterModel),
          ),
          // FilterButton(
          //   label: widget.currentSort.label,
          //   modalTitle: L10n.of(context).searchTitleSortOrder,
          //   modalItems: widget.searchSortTypes,
          //   selectedItem: ModalBottomSheetItem<ToolbarOptionModel>(
          //     text: widget.currentSort.label,
          //     value: widget.currentSort,
          //   ),
          //   onSelection: (ToolbarOptionModel sortModel) => widget.onSortChange(sortModel),
          // ),

        ],
      ),
    );
  }
}
