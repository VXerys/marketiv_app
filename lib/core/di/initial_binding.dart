import 'package:get/get.dart';
import '../services/appwrite_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.putAsync(() => AppwriteService().init(), permanent: true);
    
    // Global Utilities / Services can be added here
  }
}
