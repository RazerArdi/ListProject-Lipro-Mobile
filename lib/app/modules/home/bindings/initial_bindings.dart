import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/controllers/OnboardingController.dart';
import '../controllers/splash_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
    Get.lazyPut<OnboardingController>(() => OnboardingController());
  }
}
