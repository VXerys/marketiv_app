import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<UserEntity, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) async {
    return await repository.register(
      namaLengkap: params.namaLengkap,
      email: params.email,
      password: params.password,
      nomorWhatsapp: params.nomorWhatsapp,
      role: params.role,
    );
  }
}

class RegisterParams {
  final String namaLengkap;
  final String email;
  final String password;
  final String? nomorWhatsapp;
  final String role;

  RegisterParams({
    required this.namaLengkap,
    required this.email,
    required this.password,
    this.nomorWhatsapp,
    required this.role,
  });
}
