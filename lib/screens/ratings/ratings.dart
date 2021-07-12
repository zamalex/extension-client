import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salon/blocs/ratings/ratings_bloc.dart';
import 'package:salon/configs/app_globals.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/data/models/review_model.dart';
import 'package:salon/generated/l10n.dart';
import 'package:salon/main.dart';
import 'package:salon/model/my_reviews.dart';
import 'package:salon/screens/ratings/widgets/ratings_list_item.dart';
import 'package:salon/utils/bottom_bar_items.dart';
import 'package:salon/widgets/jumbotron.dart';
import 'package:salon/widgets/loading_overlay.dart';
import 'package:salon/utils/list.dart';
import 'package:salon/utils/text_style.dart';
import 'package:salon/widgets/strut_text.dart';

class RatingsScreen extends StatefulWidget {
  @override
  _RatingsScreenState createState() => _RatingsScreenState();
}

class _RatingsScreenState extends State<RatingsScreen> {
  final RefreshController _controller = RefreshController(initialRefresh: false);

  /// Manage state of modal progress HUD widget.
  bool _isLoading = false;
  bool _isInited = false;

  List<SingleReview> _reviews;

  @override
  void initState() {
    super.initState();
    _loadRatings();
  }

  Future<void> _loadRatings({int page = 1}) async {
    setState(() => _isLoading = true);

    BlocProvider.of<RatingsBloc>(context).add(ListRequestedRatingsEvent(
      page: page,
      resultsPerPage: kReviewsPerPage,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RatingsBloc, RatingsState>(
      builder: (BuildContext context, RatingsState state) {
        return BlocListener<RatingsBloc, RatingsState>(
          listener: (BuildContext context, RatingsState state) {
            if (state is LoadSuccessRatingsState) {
              //_controller.refreshCompleted();
             // _controller.loadComplete();
             // print('new saize os '+_reviews.length.toString());

              setState(() {
                _reviews = state.reviews;
                _isLoading = false;
                _isInited = true;
              });
            }
          },
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(L10n.of(context).reviewsTitle),
            ),
            body: LoadingOverlay(
              isLoading: _isLoading,
              child: Column(
                children: <Widget>[
                  Expanded(child: _buildRatingssList()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRatingssList() {
    if (_reviews.isNotNullOrEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: kPaddingS),
        itemCount: _reviews.length,
        itemBuilder: (BuildContext context, int index) => RatingsListItem(review: _reviews[index]),
      );
    }

    if (_isInited) {
      String _title;

      return Padding(
        padding: const EdgeInsets.all(kPaddingM),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Jumbotron(
              title: _title,
              icon: Icons.calendar_today,
              padding: const EdgeInsets.all(0),
            ),
            RaisedButton(
              child: StrutText(
                L10n.of(context).appointmentsBtnExplore,
                style: Theme.of(context).textTheme.button.fs16.white.w500,
              ),
              onPressed: () {
                // Tap on BottomNavigationBar's Explore button.
                (getIt.get<AppGlobals>().globalKeyBottomBar.currentWidget as BottomNavigationBar)
                    .onTap(getIt.get<BottomBarItems>().getBottomBarItem('explore'));
              },
            ),
          ],
        ),
      );
    }

    return Container();
  }
}
