import 'package:get/get.dart';
import '../../../../core/services/appwrite_service.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/confirm_password_reset_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/send_email_verification_usecase.dart';
import '../../domain/usecases/send_password_reset_usecase.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Data Source
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        account: AppwriteService.account,
        databases: AppwriteService.databases,
      ),
    );

    // 2. Repository
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(dataSource: Get.find()),
    );

    // 3. Use Cases
    Get.lazyPut(() => LoginUseCase(repository: Get.find()));
    Get.lazyPut(() => RegisterUseCase(repository: Get.find()));
    Get.lazyPut(() => LogoutUseCase(repository: Get.find()));
    Get.lazyPut(() => GetCurrentUserUseCase(repository: Get.find()));
    Get.lazyPut(() => SendEmailVerificationUseCase(repository: Get.find()));
    Get.lazyPut(() => SendPasswordResetUseCase(repository: Get.find()));
    Get.lazyPut(() => ConfirmPasswordResetUseCase(repository: Get.find()));

    // 4. Controller
    Get.lazyPut<AuthController>(
      () => AuthController(
        registerUseCase: Get.find(),
        loginUseCase: Get.find(),
        logoutUseCase: Get.find(),
        getCurrentUserUseCase: Get.find(),
        sendEmailVerificationUseCase: Get.find(),
        sendPasswordResetUseCase: Get.find(),
        confirmPasswordResetUseCase: Get.find(),
      ),
    );
  }
}
