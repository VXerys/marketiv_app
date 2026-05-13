import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Use Get.put (not lazyPut) so the controller is immediately available
    // when SplashPage's GetView<SplashController> accesses it during build.
    Get.put(SplashController(Get.find()));
  }
}
