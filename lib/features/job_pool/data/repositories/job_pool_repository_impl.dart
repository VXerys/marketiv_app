import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../campaign/domain/entities/campaign_entity.dart';
import '../../domain/entities/submission_entity.dart';
import '../../domain/repositories/job_pool_repository.dart';
import '../datasources/job_pool_remote_datasource.dart';

class JobPoolRepositoryImpl implements JobPoolRepository {
  final JobPoolRemoteDataSource _dataSource;

  JobPoolRepositoryImpl({required JobPoolRemoteDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<Either<Failure, List<CampaignEntity>>> getActiveCampaigns({
    String? niche,
    double? minHarga,
    double? maxHarga,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final models = await _dataSource.getActiveCampaigns(
        niche: niche,
        minHarga: minHarga,
        maxHarga: maxHarga,
        limit: limit,
        offset: offset,
      );
      return Right(models.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ConflictException catch (e) {
      return Left(ConflictFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CampaignEntity>> getCampaignById(String id) async {
    try {
      final model = await _dataSource.getCampaignById(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ConflictException catch (e) {
      return Left(ConflictFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SubmissionEntity>> claimCampaign(
    String campaignId,
    String kreatorId,
  ) async {
    try {
      final model = await _dataSource.claimCampaign(campaignId, kreatorId);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ConflictException catch (e) {
      return Left(ConflictFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkAlreadyClaimed(
    String campaignId,
    String kreatorId,
  ) async {
    try {
      final result = await _dataSource.checkAlreadyClaimed(
        campaignId,
        kreatorId,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ConflictException catch (e) {
      return Left(ConflictFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
