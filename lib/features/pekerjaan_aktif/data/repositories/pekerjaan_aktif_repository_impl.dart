import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/pekerjaan_entity.dart';
import '../../domain/repositories/pekerjaan_aktif_repository.dart';
import '../datasources/pekerjaan_aktif_remote_datasource.dart';

class PekerjaanAktifRepositoryImpl implements PekerjaanAktifRepository {
  final PekerjaanAktifRemoteDataSource _dataSource;

  PekerjaanAktifRepositoryImpl({
    required PekerjaanAktifRemoteDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<Either<Failure, List<PekerjaanEntity>>> getMyPekerjaan(
    String kreatorId,
  ) async {
    try {
      final models = await _dataSource.getMyPekerjaan(kreatorId);
      return Right(List<PekerjaanEntity>.from(models));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
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
  Future<Either<Failure, PekerjaanEntity>> submitBuktiTayang(
    String submissionId,
    String urlBukti,
  ) async {
    try {
      final model = await _dataSource.submitBuktiTayang(
        submissionId,
        urlBukti,
      );
      return Right(model);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
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
  Future<Either<Failure, PekerjaanEntity>> getPekerjaanById(
    String submissionId,
  ) async {
    try {
      final model = await _dataSource.getPekerjaanById(submissionId);
      return Right(model);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
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
}
