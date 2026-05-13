import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/campaign_entity.dart';
import '../../domain/repositories/campaign_repository.dart';
import '../../domain/usecases/create_campaign_usecase.dart';
import '../datasources/campaign_remote_datasource.dart';

class CampaignRepositoryImpl implements CampaignRepository {
  final CampaignRemoteDataSource remoteDataSource;

  CampaignRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CampaignEntity>>> getActiveCampaigns({
    String? niche,
    double? minHarga,
    double? maxHarga,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final models = await remoteDataSource.getActiveCampaigns(
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
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CampaignEntity>>> getMyCampaigns(
    String umkmId, {
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final models = await remoteDataSource.getMyCampaigns(
        umkmId,
        limit: limit,
        offset: offset,
      );
      return Right(models.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CampaignEntity>> getCampaignById(String id) async {
    try {
      final model = await remoteDataSource.getCampaignById(id);
      return Right(model.toEntity());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CampaignEntity>> createCampaign(
    CreateCampaignParams params,
    String umkmId,
  ) async {
    try {
      final model = await remoteDataSource.createCampaign(params, umkmId);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> generateBrief({
    required String namaProduk,
    required String niche,
    String? deskripsi,
  }) async {
    try {
      final brief = await remoteDataSource.generateBrief(
        namaProduk: namaProduk,
        niche: niche,
        deskripsi: deskripsi,
      );
      return Right(brief);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
