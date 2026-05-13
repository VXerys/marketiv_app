import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class ConfirmPasswordResetParams extends Equatable {
  final String userId;
  final String secret;
  final String newPassword;

  const ConfirmPasswordResetParams({
    required this.userId,
    required this.secret,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [userId, secret, newPassword];
}

class ConfirmPasswordResetUseCase implements UseCase<void, ConfirmPasswordResetParams> {
  final AuthRepository repository;

  ConfirmPasswordResetUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(ConfirmPasswordResetParams params) async {
    return await repository.confirmPasswordReset(
      userId: params.userId,
      secret: params.secret,
      newPassword: params.newPassword,
    );
  }
}
