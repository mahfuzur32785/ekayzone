import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekayzone/modules/directory/controller/directory_repository.dart';
import 'package:ekayzone/modules/directory/model/directory_response_model.dart';
import 'package:ekayzone/modules/home/model/category_model.dart';

import '../../../../core/remote_urls.dart';
import '../../../../utils/constants.dart';
import 'package:stream_transform/stream_transform.dart';

import '../model/directory_model.dart';
part 'directory_state.dart';
part 'directory_event.dart';
class DirectoryBloc extends Bloc<DirectoryEvent,DirectoryState> {
  final DirectoryRepository _directoryRepository;
  // final CategoryBloc _categoryBloc;
  DirectoryBloc({
    required DirectoryRepository directoryRepository,
    // required CategoryBloc categoryBloc
  })
      : _directoryRepository = directoryRepository,
  // _categoryBloc = categoryBloc,
        super(const DirectoryStateInitial()){
    // on<SearchAdsEventSearch>(_searchAds, transformer: debounce());
    on<DirectoryEventSearch>(_searchDirectory,);
    on<DirectoryEventLoadMore>( _loadMore);
  }

  List<Category> categories = [];

  List<DirectoryModel> directoryList = [];
  DirectoryResponseModel? directoryResponseModel;

  List<String> sortingList = ['az','za'];
  String sortingText = 'az';

  void _searchDirectory(DirectoryEventSearch event, Emitter<DirectoryState> emit) async {
    directoryList = [];
    emit(const DirectoryStateLoading());
    final uri = Uri.parse(RemoteUrls.searchDirectory).replace(
      queryParameters: {
        'keyword': event.search,
        'paginate': '10',
        'sort': sortingText,
        'category': event.category,
      },
    );

    final result = await _directoryRepository.searchDirectory(uri);

    result.fold((failure) {
      emit(DirectoryStateError(failure.message, failure.statusCode));
    }, (successData) {
      directoryResponseModel = successData;

      directoryList = successData.directoryData;

      emit(DirectoryStateLoaded(successData.directoryData));
    });
  }

  void _loadMore(DirectoryEventLoadMore event, Emitter<DirectoryState> emit) async {
    if (state is DirectoryStateLoadMore) return;
    if (directoryResponseModel == null ||
        directoryResponseModel?.nextPageUrl == null) {
      return;
    }

    emit(const DirectoryStateLoadMore());

    final uri = Uri.parse(directoryResponseModel!.nextPageUrl!);

    final result = await _directoryRepository.searchDirectory(uri);

    result.fold(
          (failure) {
        emit(DirectoryStateMoreError(failure.message, failure.statusCode));
      },
          (successData) {
            directoryResponseModel = successData;
            directoryList.addAll(successData.directoryData);

        emit(DirectoryStateMoreLoaded(directoryList.toSet().toList()));
      },
    );
  }
}

EventTransformer<Event> debounce<Event>() {
  return (events, mapper) => events.debounce(kDuration).switchMap(mapper);
}
