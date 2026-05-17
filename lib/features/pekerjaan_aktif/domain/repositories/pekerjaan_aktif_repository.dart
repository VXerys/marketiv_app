import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/pekerjaan_entity.dart';

abstract class PekerjaanAktifRepository {
  Future<Either<Failure, List<PekerjaanEntity>>> getMyPekerjaan(
    String kreatorId,
  );
  Future<Either<Failure, PekerjaanEntity>> submitBuktiTayang(
    String submissionId,
    String urlBukti,
  );
  Future<Either<Failure, PekerjaanEntity>> getPekerjaanById(
    String submissionId,
  );
}
