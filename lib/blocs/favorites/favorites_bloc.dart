import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:extension/data/models/location_model.dart';
import 'package:extension/data/repositories/favorites_repository.dart';
import 'package:extension/model/location_model.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(InitialFavoritesState());

  @override
  Stream<FavoritesState> mapEventToState(FavoritesEvent event) async* {
    if (event is DataLoadedFavoritesEvent) {
      yield* _mapLoadFavoritesEventToState(event);
    }
  }


  ///get my favourites salons
  Stream<FavoritesState> _mapLoadFavoritesEventToState(DataLoadedFavoritesEvent event) async* {
    yield LoadInProgressFavoritesState();

    List<LocationModel> favorites = [];//await const FavoritesRepository().getFavorites();
    await SalonModel().getFavSalons().then((value) {
      favorites = value.map((e){
        return LocationModel(e.offer,e.id, e.name, e.rating, 50, e.address, 'Utah', 'phone', 'email', 'website', 'description', e.logo, 'genders', [], null, [], [], [], [], [], 'cancelationPolicy');
      }).toList();

    });



    yield LoadSuccessFavoritesState(favorites);
  }
}
