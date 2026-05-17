import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/pekerjaan_entity.dart';
import '../repositories/pekerjaan_aktif_repository.dart';

class GetMyPekerjaanUseCase
    implements UseCase<List<PekerjaanEntity>, String> {
  final PekerjaanAktifRepository repository;

  GetMyPekerjaanUseCase(this.repository);

  @override
  Future<Either<Failure, List<PekerjaanEntity>>> call(
    String kreatorId,
  ) async {
    return await repository.getMyPekerjaan(kreatorId);
  }
}
