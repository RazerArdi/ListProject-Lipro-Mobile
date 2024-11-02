import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var currentIndex = 0.obs;

  final onboardingData = [
    {
      "title": "Manage your tasks",
      "description": "You can easily manage all of your daily tasks in DoMe for free",
      "image": "assets/a1.png",
    },
    {
      "title": "Create daily routine",
      "description": "In UpTodo you can create your personalized routine to stay productive",
      "image": "assets/a2.png",
    },
    {
      "title": "Organize your tasks",
      "description": "You can organize your daily tasks by adding your tasks into separate categories",
      "image": "assets/a3.png",
    },
  ];

  void nextScreen() {
    if (currentIndex.value < onboardingData.length - 1) {
      currentIndex.value++;
    } else {
      Get.offNamed('/logreg');
    }
  }
}
