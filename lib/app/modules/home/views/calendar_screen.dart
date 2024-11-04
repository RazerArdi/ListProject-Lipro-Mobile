import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/controllers/calendar_controller.dart';
import 'package:lipro_mobile/app/modules/home/views/add_task_screen.dart';

class CalendarScreen extends StatelessWidget {
  final CalendarController controller = Get.put(CalendarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          _buildCalendar(),
          Expanded(child: _buildTaskList()),  // Expanding the task list
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    // Wrap only the specific text widget that relies on observable values with Obx
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.black,
      child: Obx(() {
        return Column(
          children: [
            Text(
              controller.selectedMonth,  // Use controller.selectedMonth directly without .value
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            // Calendar dates would go here (implement your calendar UI)
          ],
        );
      }),
    );
  }

  Widget _buildTaskList() {
    return Obx(() {
      // Wrapping only the ListView.builder with Obx to observe task updates
      return ListView.builder(
        itemCount: controller.tasks.length,
        itemBuilder: (context, index) {
          final task = controller.tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text("${task.date.toLocal()} ${task.time.format(context)}"),
            trailing: Text(task.category),
          );
        },
      );
    });
  }
}
