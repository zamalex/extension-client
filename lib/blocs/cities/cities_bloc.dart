import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/data/models/city_model.dart';
import 'package:extension/data/repositories/location_repository.dart';
import 'package:extension/model/cities_data.dart';

part 'cities_event.dart';
part 'cities_state.dart';

class CitiesBloc extends Bloc<CitiesEvent, CitiesState> {
  CitiesBloc() : super(InitialCitiesState());

  @override
  Stream<CitiesState> mapEventToState(CitiesEvent event) async* {
    if (event is SearchRequestedCitiesEvent) {
      yield* _mapSearchCitiesEventToState(event);
    }
  }


  /// search cities
  Stream<CitiesState> _mapSearchCitiesEventToState(SearchRequestedCitiesEvent event) async* {
    if (event.q.length >= kMinimalNameQueryLength) {
      yield LoadCitiesInProgressState();

      final String q = event.q.toLowerCase();
      const LocationRepository locationRepository = LocationRepository();

      List<CityModel> _cities = [];//await locationRepository.searchCities(q: event.q);

      await CitiesData().getCategories().then((value){
        _cities = value.map((e){
          return CityModel(e.id.toString(), e.name, 'ksa', null);
        }).toList();
      });


      if (_cities.isNotEmpty) {
        _cities = _cities.where((CityModel city) => city.name.toLowerCase().contains(q)).toList();
      }

      yield LoadCitiesSuccessState(_cities);
    }
  }
}
