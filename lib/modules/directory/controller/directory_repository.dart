import 'package:dartz/dartz.dart';
import 'package:ekayzone/modules/ads/model/adlist_response_model.dart';
import 'package:ekayzone/modules/ads/model/customer_adlist_response_model.dart';
import 'package:ekayzone/modules/directory/create_directory/controller/create_directory_bloc.dart';
import 'package:ekayzone/modules/directory/model/directory_response_model.dart';
import '../../../../core/data/datasources/remote_data_source.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../home/model/category_model.dart';

abstract class DirectoryRepository {
  Future<Either<Failure, DirectoryResponseModel>> searchDirectory(Uri uri);
  Future<Either<Failure, DirectoryResponseModel>> getMyDirectory(Uri uri,String token);
  Future<Either<Failure, List<Category>>> getDirectoryCategories();
  Future<Either<Failure,String>> createDirectory(CreateDirectoryModalState state,String token);
}

class DirectoryRepositoryImp extends DirectoryRepository {
  final RemoteDataSource _remoteDataSource;

  DirectoryRepositoryImp({
    required RemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, DirectoryResponseModel>> searchDirectory(Uri uri) async {
    try {
      final result = await _remoteDataSource.searchDirectory(uri);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
  @override
  Future<Either<Failure, DirectoryResponseModel>> getMyDirectory(Uri uri,String token) async {
    try {
      final result = await _remoteDataSource.getMyDirectory(uri,token);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, String>> createDirectory(CreateDirectoryModalState state,String token) async {
    try {
      final result = await _remoteDataSource.createDirectory(state,token);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }


  @override
  Future<Either<Failure, List<Category>>> getDirectoryCategories() async {
    try {
      final result = await _remoteDataSource.getDirectoryCategories();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

}
