import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:salon/data/models/location_model.dart';
import 'package:salon/data/repositories/favorites_repository.dart';
import 'package:salon/model/location_model.dart';

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

  Stream<FavoritesState> _mapLoadFavoritesEventToState(DataLoadedFavoritesEvent event) async* {
    yield LoadInProgressFavoritesState();

    List<LocationModel> favorites = [];//await const FavoritesRepository().getFavorites();
    await SalonModel().getFavSalons().then((value) {
      favorites = value.map((e){
        return LocationModel(e.id, e.name, e.rating, 50, e.address, 'Utah', 'phone', 'email', 'website', 'description', 'assets/images/data/categories/barber-shop.jpg', 'genders', [], null, [], [], [], [], [], 'cancelationPolicy');
      }).toList();

    });



    yield LoadSuccessFavoritesState(favorites);
  }
}
