import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';
import 'package:salon/configs/app_globals.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/data/models/city_model.dart';
import 'package:salon/data/models/location_model.dart';
import 'package:salon/data/models/search_session_model.dart';
import 'package:salon/data/models/toolbar_option_model.dart';
import 'package:salon/data/repositories/location_repository.dart';
import 'package:salon/model/location_model.dart';
import 'package:salon/utils/geo.dart';

import '../../main.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(InitialSearchState());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SessionInitedSearchEvent) {
      yield* _mapInitSessionSearchEventToState(event);
    } else if (event is FilteredListRequestedSearchEvent) {
      yield* _mapFilteredSearchEventToState(event);
    } else if (event is CategoryFilteredSearchEvent) {
      yield* _mapCategoryFilteredSearchEventToState(event);
    } else if (event is ListTypeChangedSearchEvent) {
      yield* _mapListTypeSearchEventToState(event);
    } else if (event is SortOrderChangedSearchEvent) {
      yield* _mapSortOrderSearchEventToState(event);
    } else if (event is GenderFilterChangedSearchEvent) {
      yield* _mapGenderFilterSearchEventToState(event);
    } else if (event is CitySelectedSearchEvent) {
      yield* _mapCitySelectedSearchEventToState(event);
    } else if (event is NewDateRangeSelectedSearchEvent) {
      yield* _mapNewDateRangeSearchEventToState(event);
    } else if (event is KeywordChangedSearchEvent) {
      yield* _mapKeywordSearchEventToState(event);
    } else if (event is QuickSearchRequestedSearchEvent) {
      yield* _mapQuickSearchEventToState(event);
    } else if (event is MapSearchEvent) {
      yield* _mapMapSearchEventToState(event);
    }
  }

  Stream<SearchState> _mapInitSessionSearchEventToState(SessionInitedSearchEvent event) async* {
    yield RefreshSuccessSearchState(
      SearchSessionModel(
        currentPage: 1,
        selectedCity: event.selectedCity,
        currentSort: event.currentSort,
        currentListType: event.currentListType,
        currentGenderFilter: event.currentGenderFilter,
        activeSearchTab: event.activeSearchTab,
        searchType: SearchType.full,
      ),
    );

    //if ((event.selectedCity.id.isEmpty && getIt.get<AppGlobals>().currentPosition != null) || event.selectedCity.id.isNotEmpty) {
    add(FilteredListRequestedSearchEvent());
    //}
  }

  getLocation() async {
    getIt.get<Location>().changeSettings(accuracy: LocationAccuracy.low);

    /// Checks if the location service is enabled.
    try {
      bool serviceEnabled = await getIt.get<Location>().serviceEnabled();
      if (serviceEnabled == null || !serviceEnabled) {
        /// Request the activation of the location service.
        final bool serviceRequestedResult = await getIt.get<Location>().requestService();
        serviceEnabled = serviceRequestedResult;
      }

      /// Checks if the app has permission to access location.
      PermissionStatus permissionGranted = await getIt.get<Location>().hasPermission();
      if (permissionGranted != PermissionStatus.granted) {
        final PermissionStatus permissionRequestedResult = await getIt.get<Location>().requestPermission();
        permissionGranted = permissionRequestedResult;
      }
      if (permissionGranted == PermissionStatus.granted) {
        /// getLocation() may loop forever on emulators if location is set to 'None'!
        ///
        if (true) {
          try{
            getIt.get<AppGlobals>().currentPosition = await Future.any([
              getIt.get<Location>().getLocation(),
              Future.delayed(Duration(seconds: 5), () => null),
            ]);
            //if (getIt.get<AppGlobals>().currentPosition == null) {
            //getIt.get<AppGlobals>().currentPosition = await getIt.get<Location>().getLocation();          }


          }catch(ee){}
        } else {
          getIt.get<AppGlobals>().currentPosition = LocationData.fromMap(<String, double>{
            'latitude': kDefaultLat,
            'longitude': kDefaultLon,
            'accuracy': 0.0,
            'altitude': 0.0,
            'speed': 0.0,
            'speed_accuracy': 0.0,
            'heading': 0.0,
            'time': 0.0,
          });
        }
      }
    } catch (e) {
     // Console.log('Location ERROR', e.toString(), error: e);
    }
  }
  Stream<SearchState> _mapFilteredSearchEventToState(FilteredListRequestedSearchEvent event) async* {
    if (state is RefreshSuccessSearchState) {

      final SearchSessionModel session = (state as RefreshSuccessSearchState).session;


      yield RefreshSuccessSearchState(session.rebuild(
        isLoading: true,
        searchType: SearchType.full,
      ));

      if(session.currentPage==1)
      await getLocation();
      const LocationRepository locationRepository = LocationRepository();

      List<LocationModel> _locations;

     /* if (session.activeSearchTab == 0) {
        _locations = await locationRepository.search();
      } else {
        _locations = await locationRepository.searchCategory(id: session.activeSearchTab);
      }

      if (_locations.isNotEmpty && session.q.isNotEmpty) {
        _locations = _locations.where((LocationModel location) => location.name.toLowerCase().contains(session.q.toLowerCase())).toList();
      }*/

      bool offer = session.currentGenderFilter.label=='All Salons'?false:true;
     
      if(offer){
        await SalonModel().filterSalons('', '', session.activeSearchTab.toString()!='0'?session.activeSearchTab.toString():'', session.selectedCity.id, session.q,page: session.currentPage).then((value){
          _locations =value.where((element) => element.offer).map((e){
            return LocationModel(e.offer,e.id, e.name, e.rating??0, 100, e.address??'', '', '545545545', 'email', 'website', 'description', e.logo, 'genders', [],GeoPoint(latitude: double.parse(e.latitude), longitude:  double.parse(e.longitude)), [], [], [], [], [], 'cancelationPolicy');
          }).toList();

        });
      }else{
        await SalonModel().filterSalons('', '', session.activeSearchTab.toString()!='0'?session.activeSearchTab.toString():'', session.selectedCity.id, session.q,page: session.currentPage).then((value){
          _locations =value.map((e){
            return LocationModel(e.offer,e.id, e.name, e.rating??0, 100, e.address??'', '', '545545545', 'email', 'website', 'description', e.logo, 'genders', [],GeoPoint(latitude: double.parse(e.latitude), longitude:  double.parse(e.longitude)), [], [], [], [], [], 'cancelationPolicy');
          }).toList();

        });
      }



      if(session.locations==null){
        session.locations=[];
      }
      if(session.currentPage==1){
        yield RefreshSuccessSearchState(session.rebuild(
          locations:_locations,
          isLoading: false,
          searchType: SearchType.full,
          currentPage: session.currentPage+1
        ));
      }else{
        yield RefreshSuccessSearchState(session.rebuild(
          locations:session.locations..addAll(_locations),
          isLoading: false,
          searchType: SearchType.full,
            currentPage: session.currentPage+1
        ));
      }


    }
  }

  Stream<SearchState> _mapCategoryFilteredSearchEventToState(CategoryFilteredSearchEvent event) async* {
    if (state is RefreshSuccessSearchState) {
      final SearchSessionModel session = (state as RefreshSuccessSearchState).session;
      session.currentPage=1;
      yield RefreshSuccessSearchState(session.rebuild(
        activeSearchTab: event.activeSearchTab,
        searchType: SearchType.full,
        isLoading: true,
      ));

      add(FilteredListRequestedSearchEvent());
    }
  }

  Stream<SearchState> _mapListTypeSearchEventToState(ListTypeChangedSearchEvent event) async* {
    if (state is RefreshSuccessSearchState) {

      final SearchSessionModel session = (state as RefreshSuccessSearchState).session;
      session.currentPage=1;

      yield RefreshSuccessSearchState(session.rebuild(
        searchType: SearchType.full,
        currentListType: event.newListType,
      ));
    }
  }

  Stream<SearchState> _mapSortOrderSearchEventToState(SortOrderChangedSearchEvent event) async* {
    if (state is RefreshSuccessSearchState) {
      final SearchSessionModel session = (state as RefreshSuccessSearchState).session;
      session.currentPage=1;

      yield RefreshSuccessSearchState(session.rebuild(
        currentSort: event.newSort,
        searchType: SearchType.full,
        isLoading: true,
      ));

      add(FilteredListRequestedSearchEvent());
    }
  }

  Stream<SearchState> _mapGenderFilterSearchEventToState(GenderFilterChangedSearchEvent event) async* {
    if (state is RefreshSuccessSearchState) {
      final SearchSessionModel session = (state as RefreshSuccessSearchState).session;
      session.currentPage=1;

      yield RefreshSuccessSearchState(session.rebuild(
        currentGenderFilter: event.genderFilter,
        searchType: SearchType.full,
        isLoading: true,
      ));

      add(FilteredListRequestedSearchEvent());
    }
  }

  Stream<SearchState> _mapCitySelectedSearchEventToState(CitySelectedSearchEvent event) async* {
    if (state is RefreshSuccessSearchState) {
      final SearchSessionModel session = (state as RefreshSuccessSearchState).session;
      session.currentPage=1;

      yield RefreshSuccessSearchState(session.rebuild(
        selectedCity: event.city,
        searchType: SearchType.full,
        isLoading: true,
      ));

      add(FilteredListRequestedSearchEvent());
    }
  }

  Stream<SearchState> _mapNewDateRangeSearchEventToState(NewDateRangeSelectedSearchEvent event) async* {
    if (state is RefreshSuccessSearchState) {
      final SearchSessionModel session = (state as RefreshSuccessSearchState).session;
      session.currentPage=1;

      yield RefreshSuccessSearchState(session.rebuild(
        selectedDateRange: event.dateRange,
        searchType: SearchType.full,
        isLoading: true,
      ));

      add(FilteredListRequestedSearchEvent());
    }
  }

  Stream<SearchState> _mapKeywordSearchEventToState(KeywordChangedSearchEvent event) async* {
    if (state is RefreshSuccessSearchState) {
      final SearchSessionModel session = (state as RefreshSuccessSearchState).session;
      session.currentPage=1;

      yield RefreshSuccessSearchState(session.rebuild(
        q: event.q,
        searchType: SearchType.full,
        isLoading: true,
      ));

      add(FilteredListRequestedSearchEvent());
    }
  }

  Stream<SearchState> _mapQuickSearchEventToState(QuickSearchRequestedSearchEvent event) async* {
    if (state is RefreshSuccessSearchState) {
      if (event.q.length >= kMinimalNameQueryLength) {
        final SearchSessionModel session = (state as RefreshSuccessSearchState).session;
        session.currentPage=1;

        yield RefreshSuccessSearchState(session.rebuild(
          isLoading: true,
          locations: null,
          searchType: SearchType.quick,
        ));

        await getLocation();
        const LocationRepository locationRepository = LocationRepository();

        List<LocationModel> _locations;

        /* if (session.activeSearchTab == 0) {
        _locations = await locationRepository.search();
      } else {
        _locations = await locationRepository.searchCategory(id: session.activeSearchTab);
      }

      if (_locations.isNotEmpty && session.q.isNotEmpty) {
        _locations = _locations.where((LocationModel location) => location.name.toLowerCase().contains(session.q.toLowerCase())).toList();
      }*/

        bool offer = session.currentGenderFilter.label=='All Salons'?false:true;

        if(offer){
          await SalonModel().filterSalons('', '', session.activeSearchTab.toString()!='0'?session.activeSearchTab.toString():'', session.selectedCity.id, session.q,page: session.currentPage).then((value){
            _locations =value.where((element) => element.offer).map((e){
              return LocationModel(e.offer,e.id, e.name, e.rating??0, 100, e.address??'', '', '545545545', 'email', 'website', 'description', e.logo, 'genders', [],GeoPoint(latitude: double.parse(e.latitude), longitude:  double.parse(e.longitude)), [], [], [], [], [], 'cancelationPolicy');
            }).where((element) =>element.name.toLowerCase().contains(event.q.toLowerCase())).toList();

          });
        }else{
          await SalonModel().filterSalons('', '', session.activeSearchTab.toString()!='0'?session.activeSearchTab.toString():'', session.selectedCity.id, session.q,page: session.currentPage).then((value){
            _locations =value.map((e){
              return LocationModel(e.offer,e.id, e.name, e.rating??0, 100, e.address??'', '', '545545545', 'email', 'website', 'description', e.logo, 'genders', [],GeoPoint(latitude: double.parse(e.latitude), longitude:  double.parse(e.longitude)), [], [], [], [], [], 'cancelationPolicy');
            }).where((element) =>element.name.toLowerCase().contains(event.q.toLowerCase())).toList();

          });
        }


        yield RefreshSuccessSearchState(session.rebuild(
          locations: _locations,
          isLoading: false,
          searchType: SearchType.quick,
        ));
      }
    }
  }

  Stream<SearchState> _mapMapSearchEventToState(MapSearchEvent event) async* {
    if (state is RefreshSuccessSearchState) {
      final SearchSessionModel session = (state as RefreshSuccessSearchState).session;
      session.currentPage=1;

      yield RefreshSuccessSearchState(session.rebuild(
        isLoading: true,
        locations: null,
        searchType: SearchType.map,
      ));

      const LocationRepository locationRepository = LocationRepository();

      List<LocationModel> _locations;

      if (session.activeSearchTab == 0) {
        _locations = await locationRepository.search();
      } else {
        _locations = await locationRepository.searchCategory(id: session.activeSearchTab);
      }

      if (_locations.isNotEmpty && session.q.isNotEmpty) {
        _locations = _locations.where((LocationModel location) => location.name.toLowerCase().contains(session.q.toLowerCase())).toList();
      }

      yield RefreshSuccessSearchState(session.rebuild(
        locations: _locations,
        isLoading: false,
        searchType: SearchType.map,
      ));
    }
  }
}
