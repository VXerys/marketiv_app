import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/campaign_repository.dart';

class GenerateBriefUseCase implements UseCase<String, GenerateBriefParams> {
  final CampaignRepository repository;

  GenerateBriefUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(GenerateBriefParams params) async {
    return await repository.generateBrief(
      namaProduk: params.namaProduk,
      niche: params.niche,
      deskripsi: params.deskripsi,
    );
  }
}

class GenerateBriefParams {
  final String namaProduk;
  final String niche;
  final String? deskripsi;

  const GenerateBriefParams({
    required this.namaProduk,
    required this.niche,
    this.deskripsi,
  });
}
