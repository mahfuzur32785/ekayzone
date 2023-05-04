import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekayzone/core/error/exception.dart';
import 'package:ekayzone/modules/directory/controller/directory_repository.dart';
import 'package:ekayzone/modules/directory/model/directory_response_model.dart';
import 'package:ekayzone/modules/home/model/category_model.dart';

import '../../../../core/remote_urls.dart';
import '../../../../utils/constants.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../authentication/controllers/login/login_bloc.dart';
import '../../model/directory_model.dart';

part 'my_directory_state.dart';
part 'my_directory_event.dart';
class MyDirectoryBloc extends Bloc<MyDirectoryEvent, MyDirectoryState> {
  final DirectoryRepository _directoryRepository;
  final LoginBloc _loginBloc;
  MyDirectoryBloc({
    required DirectoryRepository directoryRepository,
    required LoginBloc loginBloc,
  })
      : _directoryRepository = directoryRepository,
        _loginBloc = loginBloc,
        super(const MyDirectoryStateInitial()){
    on<MyDirectoryEventSearch>(_searchDirectory, transformer: debounce());
    // on<MyDirectoryEventSearch>(_searchDirectory,);
    on<MyDirectoryEventLoadMore>( _loadMore);
  }

  List<Category> categories = [];

  List<DirectoryModel> directoryList = [];
  DirectoryResponseModel? directoryResponseModel;

  List<String> sortingList = ['az','za'];
  String sortingText = 'az';

  void _searchDirectory(MyDirectoryEventSearch event, Emitter<MyDirectoryState> emit) async {
    if (_loginBloc.userInfo == null) {
      emit(const MyDirectoryStateError('Please sign in',401));
      return;
    }
    directoryList = [];
    emit(const MyDirectoryStateLoading());
    final uri = Uri.parse(RemoteUrls.getMyDirectory).replace(
      queryParameters: {
        'keyword': '',
        'paginate': '10',
        'sort': sortingText,
        'category': '',
      },
    );

    final token = _loginBloc.userInfo!.accessToken;

    final result = await _directoryRepository.getMyDirectory(uri,token);

    result.fold((failure) {
      emit(MyDirectoryStateError(failure.message, failure.statusCode));
    }, (successData) {
      directoryResponseModel = successData;

      directoryList = successData.directoryData;

      emit(MyDirectoryStateLoaded(successData.directoryData));
    });
  }

  void _loadMore(MyDirectoryEventLoadMore event, Emitter<MyDirectoryState> emit) async {
    if (_loginBloc.userInfo == null) {
      emit(const MyDirectoryStateError('Please sign in',401));
      return;
    }
    if (state is MyDirectoryStateLoadMore) return;
    if (directoryResponseModel == null ||
        directoryResponseModel?.nextPageUrl == null) {
      return;
    }

    emit(const MyDirectoryStateLoadMore());

    final uri = Uri.parse(directoryResponseModel!.nextPageUrl!);

    final token = _loginBloc.userInfo!.accessToken;

    final result = await _directoryRepository.getMyDirectory(uri,token);

    result.fold(
          (failure) {
        emit(MyDirectoryStateMoreError(failure.message, failure.statusCode));
      },
          (successData) {
        directoryResponseModel = successData;
        directoryList.addAll(successData.directoryData);

        emit(MyDirectoryStateMoreLoaded(directoryList.toSet().toList()));
      },
    );
  }
}

EventTransformer<Event> debounce<Event>() {
  return (events, mapper) => events.debounce(kDuration).switchMap(mapper);
}
