import 'package:dartz/dartz.dart';
import 'package:ekayzone/modules/directory/model/directory_model.dart';

import '../../../../core/data/datasources/remote_data_source.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';

abstract class DirectoryDetailsRepository {
  Future<Either<Failure, DirectoryModel>> getDirectory(Uri uri);
  Future<Either<Failure, String>> contactWithAuthor(Map<String, String> body,String token);
  Future<Either<Failure, String>> claimBusiness(Map<String, String> body,String token);
}

class DirectoryDetailsRepositoryImpl extends DirectoryDetailsRepository {
  final RemoteDataSource _remoteDataSource;

  DirectoryDetailsRepositoryImpl({
    required RemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, DirectoryModel>> getDirectory(Uri uri) async {
    try {
      final result = await _remoteDataSource.getDirectoryDetails(uri);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, String>> contactWithAuthor(Map<String, String> body, String token) async {
    try {
      final result = await _remoteDataSource.contactWithAuthor(body,token);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
  @override
  Future<Either<Failure, String>> claimBusiness(Map<String, String> body, String token) async {
    try {
      final result = await _remoteDataSource.claimBusiness(body,token);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

}