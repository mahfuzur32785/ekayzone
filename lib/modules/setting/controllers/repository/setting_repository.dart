import 'package:dartz/dartz.dart';
import 'package:ekayzone/modules/setting/model/faq_category_model.dart';
import '../../../../core/data/datasources/remote_data_source.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../model/about_us_model.dart';
import '../../model/contact_us_mesage_model.dart';
import '../../model/contact_us_mode.dart';
import '../../model/faq_model.dart';

abstract class SettingRepository {
  Future<Either<Failure, String>> getAboutUs();
  Future<Either<Failure, List<FaqCategoryModel>>> getFaqList();
  Future<Either<Failure, String>>
      getPrivacyPolicy();
  Future<Either<Failure, String>>
      getPostingRules();
  Future<Either<Failure, String>>
      getTermsAndCondition();
  Future<Either<Failure, ContactUsModel>> getContactUsContent();
  Future<Either<Failure, bool>> getContactUsMessageSend(
      ContactUsMessageModel body);
  Future<Either<Failure, String>> deletionRequest(String reason,String reasonInText,String token);
}

class SettingRepositoryImp extends SettingRepository {
  final RemoteDataSource remoteDataSource;
  SettingRepositoryImp({required this.remoteDataSource});

  @override
  Future<Either<Failure, bool>> getContactUsMessageSend(
      ContactUsMessageModel body) async {
    try {
      final result = await remoteDataSource.getContactUsMessageSend(body);
      return right(result);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, ContactUsModel>> getContactUsContent() async {
    try {
      final result = await remoteDataSource.getContactUsContent();
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, String>> getAboutUs() async {
    try {
      final result = await remoteDataSource.getAboutUsData();
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<FaqCategoryModel>>> getFaqList() async {
    try {
      final result = await remoteDataSource.getFaqList();
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, String>>
      getPrivacyPolicy() async {
    try {
      final result = await remoteDataSource.getPrivacyPolicy();
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, String>>
      getPostingRules() async {
    try {
      final result = await remoteDataSource.getPostingRules();
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, String>>
      getTermsAndCondition() async {
    try {
      final result = await remoteDataSource.getTermsAndCondition();
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, String>> deletionRequest(String reason,String reasonInText,String token) async {
    try {
      final result = await remoteDataSource.accDeletionRequest(reason,reasonInText,token);
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
}
