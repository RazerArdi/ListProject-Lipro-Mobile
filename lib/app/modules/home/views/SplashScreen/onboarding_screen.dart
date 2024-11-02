import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/controllers/OnboardingController.dart';

class OnboardingScreen extends StatelessWidget {
  final OnboardingController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Get.offNamed('/logreg'),
          child: Text(
            'SKIP',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: controller.onboardingData.length,
              onPageChanged: (index) {
                controller.currentIndex.value = index;
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Image.asset(controller.onboardingData[index]["image"]!, height: 200),
                      SizedBox(height: 20),
                      Text(
                        controller.onboardingData[index]["title"]!,
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        controller.onboardingData[index]["description"]!,
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      Spacer(),
                    ],
                  ),
                );
              },
            ),
          ),
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              controller.onboardingData.length,
                  (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                width: controller.currentIndex.value == index ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: controller.currentIndex.value == index ? Colors.purple : Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          )),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
              onPressed: controller.nextScreen,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Obx(() => Text(
                controller.currentIndex.value == controller.onboardingData.length - 1
                    ? 'GET STARTED'
                    : 'NEXT',
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
