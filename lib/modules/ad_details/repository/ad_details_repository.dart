import 'package:dartz/dartz.dart';
import 'package:ekayzone/core/data/datasources/remote_data_source.dart';
import 'package:ekayzone/core/error/exception.dart';
import 'package:ekayzone/core/error/failure.dart';
import 'package:ekayzone/modules/ad_details/model/details_response_model.dart';

abstract class AdDetailsRepository {
  Future<Either<Failure, DetailsResponseModel>> getAdDetails(String slug,String token);
}

class AdDetailsRepositoryImp extends AdDetailsRepository {
  final RemoteDataSource remoteDataSource;
  AdDetailsRepositoryImp({required this.remoteDataSource});

  @override
  Future<Either<Failure, DetailsResponseModel>> getAdDetails(String slug,String token) async {
    try {
      final result = await remoteDataSource.getAdDetails(slug,token);
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

}