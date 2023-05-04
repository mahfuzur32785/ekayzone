import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../authentication/controllers/login/login_bloc.dart';
import '../../../../profile/repository/profile_repository.dart';
import '../../../model/city_model.dart';
import '../../../model/country_model.dart';
import '../../../model/country_state_model.dart';

part 'country_state_by_id_state.dart';

class CountryStateByIdCubit extends Cubit<CountryStateByIdState> {
  final LoginBloc _loginBloc;
  final ProfileRepository _profileRepository;
  CountryStateByIdCubit({
    required LoginBloc loginBloc,
    required ProfileRepository profileRepository,
  })  : _loginBloc = loginBloc,
        _profileRepository = profileRepository,
        super(CountryStateByIdStateInitial());

  List<CountryStateModel> stateList = [];
  List<CityModel> cities = [];

  Future<void> stateLoadIdCountryId(String id) async {
    stateList = [];
    cities = [];

    emit(const CountryStateByIdStateLoading());
    final result = await _profileRepository.statesByCountryId(
        id, _loginBloc.userInfo!.accessToken);
    result.fold(
      (failure) {
        emit(CountryStateByIdStateError(failure.statusCode, failure.message));
      },
      (dataList) {
        stateList = dataList.toSet().toList();
        emit(CountryStateByIdStateLoadied(stateList));
      },
    );
  }

  Future<void> cityLoadIdStateId(String id) async {
    cities = [];
    emit(const CountryStateByIdCityLoading());
    final result = await _profileRepository.citiesByStateId(
        id, _loginBloc.userInfo!.accessToken);
    result.fold(
      (failure) {
        emit(CountryStateByIdStateError(failure.statusCode, failure.message));
      },
      (dataList) {
        cities = dataList.toSet().toList();
        emit(CountryStateByIdCityLoaded(cities));
        emit(CountryStateByIdCityFilter(cities));
      },
    );
  }

  Future<void> cityStateChangeCityFilter(CountryStateModel stateModel) async {
    cities = [];
    emit(const CountryStateByIdCityLoading());
    cities = stateModel.cities.toSet().toList();
    if (kDebugMode) {
      print("city data filter : $cities");
    }
    emit(CountryStateByIdCityFilter(cities));
    emit(CountryStateByIdCityLoaded(cities));
  }

  CountryStateModel? filterState(int id) {
    for (var item in stateList) {
      if (item.id== id) {
        return item;
      }
    }
    return null;
  }

  CityModel? filterCity(int id) {
    for (var item in cities) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  CountryModel? filterCountryWithCountries(List<CountryModel> countries,int id) {
    for (var item in countries) {
      if (item.id== id) {
        return item;
      }
    }
    return null;
  }

  CountryStateModel? filterStateWithStates(List<CountryStateModel> states,int id) {
    stateList = states;
    for (var item in stateList) {
      if (item.id== id) {
        return item;
      }
    }
    return null;
  }

  CityModel? filterCityWithCities(List<CityModel> cities,int id) {
    this.cities = cities;
    for (var item in this.cities) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }
}
