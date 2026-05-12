import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  Failure _handleException(dynamic e) {
    if (e is UnauthorizedException) {
      return AuthFailure(message: e.message);
    } else if (e is NotFoundException) {
      return NotFoundFailure(message: e.message);
    } else if (e is ConflictException) {
      return ConflictFailure(message: e.message);
    } else if (e is ServerException) {
      return ServerFailure(message: e.message);
    } else {
      return const ServerFailure(message: 'Terjadi kesalahan tidak terduga.');
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    try {
      final userModel = await remoteDataSource.login(email, password);
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String namaLengkap,
    required String email,
    required String password,
    String? nomorWhatsapp,
    required String role,
  }) async {
    try {
      final userModel = await remoteDataSource.register(
        namaLengkap,
        email,
        password,
        nomorWhatsapp,
        role,
      );
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> sendEmailVerification() async {
    try {
      await remoteDataSource.sendEmailVerification();
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
}
