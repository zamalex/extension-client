import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:extension/data/models/review_model.dart';
import 'package:extension/data/repositories/ratings_repository.dart';
import 'package:extension/model/my_reviews.dart';

part 'ratings_event.dart';
part 'ratings_state.dart';

class RatingsBloc extends Bloc<RatingsEvent, RatingsState> {
  RatingsBloc() : super(InitialRatingsState());

  @override
  Stream<RatingsState> mapEventToState(RatingsEvent event) async* {
    if (event is ListRequestedRatingsEvent) {
      yield* _mapGetRatingsEventToState(event);
    }
  }


  /// get rated salons
  Stream<RatingsState> _mapGetRatingsEventToState(ListRequestedRatingsEvent event) async* {
    yield LoadInProgressRatingsState();

    List<SingleReview> reviews=[];

    await MyReviews().getMyReviews('8').then((value) {
      reviews = value;
     // print(value[0].moduleName);


    });
    // = await const RatingsRepository().getRatings();
    //print('size is ${_reviews.length}');
    yield LoadSuccessRatingsState(reviews);
  }
}
