import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/pekerjaan_entity.dart';
import '../repositories/pekerjaan_aktif_repository.dart';

class SubmitBuktiTayangUseCase
    implements UseCase<PekerjaanEntity, SubmitBuktiParams> {
  final PekerjaanAktifRepository repository;

  SubmitBuktiTayangUseCase(this.repository);

  @override
  Future<Either<Failure, PekerjaanEntity>> call(
    SubmitBuktiParams params,
  ) async {
    return await repository.submitBuktiTayang(
      params.submissionId,
      params.urlBukti,
    );
  }
}

class SubmitBuktiParams extends Equatable {
  final String submissionId;
  final String urlBukti;

  const SubmitBuktiParams({
    required this.submissionId,
    required this.urlBukti,
  });

  @override
  List<Object?> get props => [submissionId, urlBukti];
}
