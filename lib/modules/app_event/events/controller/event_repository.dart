import 'package:dartz/dartz.dart';
import 'package:ekayzone/core/data/datasources/remote_data_source.dart';
import 'package:ekayzone/modules/app_event/model/event_params_model.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../create_event/controller/create_event_bloc.dart';
import '../../model/event_model.dart';

abstract class EventRepository {
  Future<Either<Failure, List<EventModel>>> getEvents(Uri uri);
  Future<Either<Failure, EventModel>> getEventDetails(String slug,String token);
  Future<Either<Failure, EventParamsModel>> getEventParams();
  Future<Either<Failure,String>> createEventSubmit(CreateEventModalState state,String token);
}

class EventRepositoryImpl extends EventRepository {
  final RemoteDataSource remoteDataSource;
  EventRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<EventModel>>> getEvents(Uri uri) async {
    try {
      final result = await remoteDataSource.getEvents(uri);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }


  @override
  Future<Either<Failure, String>> createEventSubmit(CreateEventModalState state,String token) async {
    try {
      final result = await remoteDataSource.createEventSubmit(state,token);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, EventModel>> getEventDetails(String slug,String token) async {
    try {
      final result = await remoteDataSource.getEventDetails(slug,token);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
  @override
  Future<Either<Failure, EventParamsModel>> getEventParams() async {
    try {
      final result = await remoteDataSource.getEventParams();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

}