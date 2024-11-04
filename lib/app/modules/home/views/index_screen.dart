import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/controllers/home_controller.dart';

class IndexScreen extends StatelessWidget {
  final HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(() {
        if (controller.tasks.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/emptyTask.png', height: 200),
              const SizedBox(height: 20),
              const Text(
                "What do you want to do today?",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 10),
              const Text(
                "Tap + to add your tasks",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          );
        } else {
          return ListView.builder(
            itemCount: controller.tasks.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  controller.tasks[index],
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
