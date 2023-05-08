import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../model/home_model.dart';
import '../repository/home_repository.dart';

part 'home_controller_state.dart';

class HomeControllerCubit extends Cubit<HomeControllerState> {
  HomeControllerCubit(HomeRepository homeRepository)
      : _homeRepository = homeRepository,
        super(HomeControllerLoading()) {
    // getHomeData(jhkdfajiasdkhfjkasdf);
  }

  final HomeRepository _homeRepository;
  late HomeModel homeModel;

  String country = 'Select Country';
  String updatedCountry = '';

  TextEditingController searchController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  // getUpdateCountry(String country){
  //   emit(HomeControllerLoading());
  //   Future.delayed(const Duration(milliseconds: 100)).then((value){
  //     this.country = country;
  //     emit(HomeControllerLoaded(homeModel: homeModel));
  //   });
  // }

  Future<void> getHomeData(countryCode) async {
    emit(HomeControllerLoading());

    final result = await _homeRepository.getHomeData(countryCode);
    result.fold(
      (failure) {
        emit(HomeControllerError(errorMessage: failure.message));
      },
      (data) {
        homeModel = data;
        // country = data.topCountries.isEmpty ? 'Canada' : data.topCountries[0].nicename;
        emit(HomeControllerLoaded(homeModel: data));
      },
    );
  }

  Future<void> getHomeDataOnRefresh(countryCode) async {
    // emit(HomeControllerLoading());

    final result = await _homeRepository.getHomeData(countryCode);
    result.fold(
          (failure) {
        emit(HomeControllerError(errorMessage: failure.message));
      },
          (data) {
        homeModel = data;
        emit(HomeControllerLoaded(homeModel: data));
      },
    );
  }
}
