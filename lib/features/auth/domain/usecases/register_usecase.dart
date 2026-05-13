import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterParams extends Equatable {
  final String namaLengkap;
  final String email;
  final String password;
  final String role;
  final String? nomorWhatsapp;

  const RegisterParams({
    required this.namaLengkap,
    required this.email,
    required this.password,
    required this.role,
    this.nomorWhatsapp,
  });

  @override
  List<Object?> get props => [namaLengkap, email, password, role, nomorWhatsapp];
}

class RegisterUseCase implements UseCase<UserEntity, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) async {
    return await repository.register(
      namaLengkap: params.namaLengkap,
      email: params.email,
      password: params.password,
      role: params.role,
      nomorWhatsapp: params.nomorWhatsapp,
    );
  }
}
