import 'package:get/get.dart';
import '../services/storage_service.dart';
import '../services/appwrite_service.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/send_email_verification_usecase.dart';
import '../../features/auth/domain/usecases/send_password_reset_usecase.dart';
import '../../features/auth/domain/usecases/confirm_password_reset_usecase.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Services — permanent: true
    Get.put<StorageService>(StorageService(), permanent: true);

    // 2. AppwriteService sudah diinisialisasi di main() sebelum runApp
    //    Tidak perlu Get.put karena AppwriteService pakai static methods

    // 3. Auth — global karena dipakai di banyak tempat
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        account: AppwriteService.account,
        databases: AppwriteService.databases,
      ),
      fenix: true,
    );
    
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(dataSource: Get.find<AuthRemoteDataSource>()),
      fenix: true,
    );

    Get.lazyPut(() => LoginUseCase(repository: Get.find()), fenix: true);
    Get.lazyPut(() => RegisterUseCase(repository: Get.find()), fenix: true);
    Get.lazyPut(() => LogoutUseCase(repository: Get.find()), fenix: true);
    Get.lazyPut(() => GetCurrentUserUseCase(repository: Get.find()), fenix: true);
    Get.lazyPut(() => SendEmailVerificationUseCase(repository: Get.find()), fenix: true);
    Get.lazyPut(() => SendPasswordResetUseCase(repository: Get.find()), fenix: true);
    Get.lazyPut(() => ConfirmPasswordResetUseCase(repository: Get.find()), fenix: true);
  }
}
