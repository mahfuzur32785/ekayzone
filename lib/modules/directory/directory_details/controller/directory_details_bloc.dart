import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekayzone/core/error/exception.dart';
import 'package:ekayzone/modules/ads/model/adlist_response_model.dart';
import 'package:ekayzone/modules/home/model/ad_model.dart';
import 'package:ekayzone/utils/utils.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/remote_urls.dart';
import '../../../authentication/controllers/login/login_bloc.dart';
import '../../model/directory_model.dart';
import 'directory_details_repository.dart';
part 'directory_details_event.dart';
part 'directory_details_state.dart';
class DirectoryDetailsBloc extends Bloc<DirectoryDetailsEvent,DirectoryDetailsState> {
  final DirectoryDetailsRepository _directoryDetailsRepository;
  final LoginBloc _loginBloc;
  DirectoryDetailsBloc({
    required DirectoryDetailsRepository directoryDetailsRepository,
    required LoginBloc loginBloc,
  })
      : _directoryDetailsRepository = directoryDetailsRepository,
        _loginBloc = loginBloc,
        super(const DirectoryDetailsStateInitial()){
    on<DirectoryDetailsEventGetData>(_getDirectory,);
    on<DirectoryDetailsEventClaim>(_businessClaim,);
  }

  void _getDirectory(DirectoryDetailsEventGetData event, Emitter<DirectoryDetailsState> emit) async {
    emit(const DirectoryDetailsStateLoading());
    final uri = Uri.parse(RemoteUrls.getDirectoryDetails(event.id,event.slug));

    if (kDebugMode) {
      print(uri);
    }

    final result = await _directoryDetailsRepository.getDirectory(uri);

    result.fold((failure) {
      emit(DirectoryDetailsStateError(failure.message, failure.statusCode));
    }, (successData) {
      emit(DirectoryDetailsStateLoaded(successData));
    });
  }

  void _businessClaim(DirectoryDetailsEventClaim event, Emitter<DirectoryDetailsState> emit) async {
    if (!_loginBloc.isLoggedIn) {
      throw const UnauthorisedException("Please Sign in first!",401);
    }

    emit( const DirectoryDetailsStateClaimLoading());

    final token = _loginBloc.userInfo!.accessToken;

    final body = <String, String>{};
    body.addAll({"email": event.email.trim().toString()});
    body.addAll({"name": event.name.trim().toString()});
    body.addAll({"post_id": event.postId});

    final result = await _directoryDetailsRepository.claimBusiness(body,token);

    result.fold((failure) {
      emit(DirectoryDetailsStateClaimError(failure.message,failure.statusCode));
    }, (message) {
      emit(DirectoryDetailsStateClaimLoaded(message));
    });
  }


  // Future<Either<Failure, String>> _contactWithAuthor(DirectoryDetailsEventContactAuthor event, Emitter<DirectoryDetailsState> emit) async {
  //
  //   if (!_loginBloc.isLoggedIn) {
  //     throw const UnauthorisedException("Please Sign in first!",401);
  //   }
  //
  //   final token = _loginBloc.userInfo!.accessToken;
  //
  //   final body = <String, String>{};
  //   body.addAll({"email": event.email.trim().toString()});
  //   body.addAll({"message": event.message.trim().toString()});
  //   body.addAll({"post_id": event.postId.trim().toString()});
  //
  //   final result = await _directoryDetailsRepository.contactWithAuthor(body,token);
  //
  //   return result;
  // }

  Future<Either<Failure, String>> contactWithAuthor(String email,String message, int postId) async {

    if (!_loginBloc.isLoggedIn) {
      throw const UnauthorisedException("Please Sign in first!",401);
    }

    final token = _loginBloc.userInfo!.accessToken;

    final body = <String, String>{};
    body.addAll({"email": email.trim().toString()});
    body.addAll({"message": message.trim().toString()});
    body.addAll({"post_id": '$postId'});

    final result = await _directoryDetailsRepository.contactWithAuthor(body,token);

    return result;
  }

}

