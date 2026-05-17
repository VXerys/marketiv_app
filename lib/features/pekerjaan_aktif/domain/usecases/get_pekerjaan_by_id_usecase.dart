import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/pekerjaan_entity.dart';
import '../repositories/pekerjaan_aktif_repository.dart';

class GetPekerjaanByIdUseCase implements UseCase<PekerjaanEntity, String> {
  final PekerjaanAktifRepository repository;

  GetPekerjaanByIdUseCase(this.repository);

  @override
  Future<Either<Failure, PekerjaanEntity>> call(
    String submissionId,
  ) async {
    return await repository.getPekerjaanById(submissionId);
  }
}
